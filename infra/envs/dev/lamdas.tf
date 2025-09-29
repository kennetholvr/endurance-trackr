resource "aws_lambda_function" "upload_url" {
  function_name    = "ff-${var.env}-upload-url"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  filename         = data.archive_file.upload_url_zip.output_path
  source_code_hash = data.archive_file.upload_url_zip.output_base64sha256
  timeout          = 10
  architectures    = ["arm64"]

  environment {
    variables = {
      RAW_BUCKET = aws_s3_bucket.raw.bucket
    }
  }
  tags = { Function = "upload-url" }
}

resource "aws_lambda_function" "get_metrics" {
  function_name    = "ff-${var.env}-get-metrics"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  filename         = data.archive_file.get_metrics_zip.output_path
  source_code_hash = data.archive_file.get_metrics_zip.output_base64sha256
  timeout          = 10
  architectures    = ["arm64"]

  environment {
    variables = {
      METRICS_TABLE = aws_dynamodb_table.metrics.name
    }
  }
  tags = { Function = "get-metrics" }
}
