# Athletes: PK only
resource "aws_dynamodb_table" "athletes" {
  name         = "athletes-${var.env}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "athlete_id"

  attribute {
    name = "athlete_id"
    type = "S"
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.data.arn
  }
}

# Workouts: PK + SK + GSI(workout_date)
resource "aws_dynamodb_table" "workouts" {
  name         = "workouts-${var.env}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "athlete_id"
  range_key    = "workout_id"

  attribute {
    name = "athlete_id"
    type = "S"
  }
  attribute {
    name = "workout_id"
    type = "S"
  }
  attribute {
    name = "workout_date"
    type = "S"
  }

  global_secondary_index {
    name            = "workout_date"
    hash_key        = "athlete_id"
    range_key       = "workout_date"
    projection_type = "ALL"
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.data.arn
  }
}

# Metrics: PK + SK (per-day)
resource "aws_dynamodb_table" "metrics" {
  name         = "metrics-${var.env}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "athlete_id"
  range_key    = "metric_date"

  attribute {
    name = "athlete_id"
    type = "S"
  }
  attribute {
    name = "metric_date"
    type = "S"
  }

  server_side_encryption {
    enabled     = true
    kms_key_arn = aws_kms_key.data.arn
  }
}
