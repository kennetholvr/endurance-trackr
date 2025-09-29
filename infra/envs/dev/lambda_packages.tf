
data "archive_file" "upload_url_zip" {
  type        = "zip"
  source_dir  = abspath("${path.module}/../../../backend/upload-url")
  output_path = "${path.module}/.build/upload-url.zip"
}

data "archive_file" "get_metrics_zip" {
  type        = "zip"
  source_dir  = abspath("${path.module}/../../../backend/get-metrics")
  output_path = "${path.module}/.build/get-metrics.zip"
}