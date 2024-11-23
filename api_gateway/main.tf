provider "aws" {
  region = "us-east-1"  # Change the region as needed
}

data "aws_caller_identity" "current" {}

resource "aws_lambda_function" "division_lambda" {
  function_name = "division_lambda"
  runtime       = "python3.8"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda_exec.arn
  source_code_hash = filebase64sha256("lambda_function.zip")
  filename      = "lambda_function.zip"
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role_unique"  # Change to a unique role name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Effect = "Allow"
      Sid    = ""
    }]
  })
}

resource "aws_iam_policy_attachment" "lambda_policy_attachment" {
  name       = "lambda_policy_attachment"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_api_gateway_rest_api" "division_api" {
  name        = "division_api"
  description = "API for division operation"
}

resource "aws_api_gateway_resource" "division" {
  rest_api_id = aws_api_gateway_rest_api.division_api.id
  parent_id   = aws_api_gateway_rest_api.division_api.root_resource_id
  path_part   = "divide"
}

resource "aws_api_gateway_method" "get_division" {
  rest_api_id   = aws_api_gateway_rest_api.division_api.id
  resource_id   = aws_api_gateway_resource.division.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.division_api.id
  resource_id = aws_api_gateway_resource.division.id
  http_method = aws_api_gateway_method.get_division.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.division_lambda.invoke_arn
}

resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.division_lambda.function_name
  principal     = "apigateway.amazonaws.com"
}

resource "aws_api_gateway_deployment" "division_deployment" {
  rest_api_id = aws_api_gateway_rest_api.division_api.id
}

resource "aws_api_gateway_stage" "division_stage" {
  deployment_id = aws_api_gateway_deployment.division_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.division_api.id
  stage_name    = "prod"
}

output "api_endpoint" {
  value = "${aws_api_gateway_rest_api.division_api.execution_arn}/${aws_api_gateway_resource.division.path_part}"
}

output "api_endpoint_url" {
  value = "https://${aws_api_gateway_rest_api.division_api.id}.execute-api.us-east-1.amazonaws.com/prod/divide"
  description = "The URL to invoke the API Gateway for division"
}

