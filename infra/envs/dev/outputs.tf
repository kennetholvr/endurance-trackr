output "kms_key_alias" { value = aws_kms_alias.data.name }
output "raw_bucket" { value = aws_s3_bucket.raw.bucket }
output "logs_bucket" { value = aws_s3_bucket.logs.bucket }

output "table_athletes" { value = aws_dynamodb_table.athletes.name }
output "table_workouts" { value = aws_dynamodb_table.workouts.name }
output "table_metrics" { value = aws_dynamodb_table.metrics.name }
