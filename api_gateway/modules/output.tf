output "api_url" {
  description = "API endpoint URL for division function"
  value       = "${aws_api_gateway_rest_api.api.execution_arn}/prod/divide"
}