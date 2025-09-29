resource "aws_apigatewayv2_api" "http" {
  name          = "ff-${var.env}-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_integration" "upload_url" {
  api_id                 = aws_apigatewayv2_api.http.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.upload_url.arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_integration" "get_metrics" {
  api_id                 = aws_apigatewayv2_api.http.id
  integration_type       = "AWS_PROXY"
  integration_uri        = aws_lambda_function.get_metrics.arn
  payload_format_version = "2.0"
}

resource "aws_apigatewayv2_route" "route_upload_url" {
  api_id    = aws_apigatewayv2_api.http.id
  route_key = "POST /upload-url"
  target    = "integrations/${aws_apigatewayv2_integration.upload_url.id}"
}

resource "aws_apigatewayv2_route" "route_get_metrics" {
  api_id    = aws_apigatewayv2_api.http.id
  route_key = "GET /metrics/today"
  target    = "integrations/${aws_apigatewayv2_integration.get_metrics.id}"
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name              = "/aws/apigwv2/ff-${var.env}-api"
  retention_in_days = 14
}

resource "aws_apigatewayv2_stage" "dev" {
  api_id      = aws_apigatewayv2_api.http.id
  name        = "$default"
  auto_deploy = true

  access_log_settings {
    destination_arn = aws_cloudwatch_log_group.api_gw.arn
    format = jsonencode({
      requestId = "$context.requestId",
      routeKey  = "$context.routeKey",
      status    = "$context.status"
    })
  }
}

resource "aws_lambda_permission" "allow_invoke_upload" {
  statement_id  = "AllowAPIGwInvokeUpload"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.upload_url.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http.execution_arn}/*/*"
}

resource "aws_lambda_permission" "allow_invoke_metrics" {
  statement_id  = "AllowAPIGwInvokeMetrics"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get_metrics.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http.execution_arn}/*/*"
}

output "api_base_url" { value = aws_apigatewayv2_api.http.api_endpoint }
