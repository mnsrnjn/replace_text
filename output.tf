output "function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.replacetext.arn
}

output "function_name" {
  description = "The name of the Lambda function"
  value       = aws_lambda_function.replacetext.function_name
}

output "name" {
  description = "API Gateway name"
  value       = aws_api_gateway_rest_api.example.name
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}

output "invocation_url" {
  description = "Serverless invoke url"
  value       = local.url
}