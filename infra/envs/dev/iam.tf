data "aws_iam_policy_document" "lambda_trust" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_exec" {
  name               = "ff-${var.env}-lambda-exec"
  assume_role_policy = data.aws_iam_policy_document.lambda_trust.json
  tags               = { Role = "lambda-exec" }
}

resource "aws_iam_role_policy_attachment" "logs_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# get-metrics needs read on metrics table
data "aws_iam_policy_document" "metrics_read" {
  statement {
    effect    = "Allow"
    actions   = ["dynamodb:GetItem"]
    resources = [aws_dynamodb_table.metrics.arn]
  }
}
resource "aws_iam_policy" "metrics_read" {
  name   = "ff-${var.env}-metrics-read"
  policy = data.aws_iam_policy_document.metrics_read.json
}
resource "aws_iam_role_policy_attachment" "metrics_read_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.metrics_read.arn
}

# Allow Lambda to use the CMK that encrypts S3/DynamoDB
data "aws_iam_policy_document" "kms_data_access" {
  statement {
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [aws_kms_key.data.arn]
  }
}

resource "aws_iam_policy" "kms_data_access" {
  name   = "ff-${var.env}-kms-data-access"
  policy = data.aws_iam_policy_document.kms_data_access.json
}

resource "aws_iam_role_policy_attachment" "kms_data_access_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.kms_data_access.arn
}

# Allow presigned PUTs under uploads/ in the raw bucket
data "aws_iam_policy_document" "upload_put" {
  statement {
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.raw.arn}/uploads/*"]
  }
}

resource "aws_iam_policy" "upload_put" {
  name   = "ff-${var.env}-raw-put"
  policy = data.aws_iam_policy_document.upload_put.json
}

resource "aws_iam_role_policy_attachment" "upload_put_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.upload_put.arn
}