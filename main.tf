data "archive_file" "archive_file" {
  type        = "zip"
  source_file = "lambda/main.py"
  output_path = "lambda/main.zip"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

data "aws_caller_identity" "current" {}



resource "aws_iam_role" "iam_for_lambda" {
  name               = "iam_for_lambda"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# Creating lambda function using python to replace the text with desired bank name
resource "aws_lambda_function" "replacetext" {
  filename          = "lambda/main.zip"
  function_name     = var.function_name
  role              = aws_iam_role.iam_for_lambda.arn
  handler           = "main.lambda_handler"
  source_code_hash  = data.archive_file.archive_file.output_base64sha256
  runtime           = "python3.8"
  tags              = var.tags
}

#Creating API gateway using rest api to invoke the lamda
resource "aws_api_gateway_rest_api" "example" {
  name = var.api_name
}

resource "aws_api_gateway_resource" "example" {
  parent_id   = aws_api_gateway_rest_api.example.root_resource_id
  path_part   = "replace_text"
  rest_api_id = aws_api_gateway_rest_api.example.id
}

resource "aws_api_gateway_method" "method" {
  authorization = "NONE"
  http_method   = "POST"
  resource_id   = aws_api_gateway_resource.example.id
  rest_api_id   = aws_api_gateway_rest_api.example.id
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.example.id
  resource_id             = aws_api_gateway_resource.example.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.replacetext.invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.replacetext.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.aws_region}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.example.id}/*"
  
}


resource "aws_api_gateway_deployment" "api-deployment" {
  rest_api_id = aws_api_gateway_rest_api.example.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.example.id,
      aws_api_gateway_method.method.id,
      aws_api_gateway_integration.integration.id,
    ]))
  }
}

resource "aws_api_gateway_stage" "example" {
  deployment_id = aws_api_gateway_deployment.api-deployment.id
  rest_api_id   = aws_api_gateway_rest_api.example.id
  stage_name    = var.stage
}

#Url to which we can send the POST request to change the text
locals {
  url = "${aws_api_gateway_deployment.api-deployment.invoke_url}${aws_api_gateway_stage.example.stage_name}/${aws_api_gateway_resource.example.path_part}"
}