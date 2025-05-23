output "lambda_function_arn" {
  description = "ARN of the created Lambda function"
  value       = module.lambda.arn
}

output "lambda_function_name" {
  description = "Name of the created Lambda function"
  value       = module.lambda.function_name
}

output "lambda_invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  value       = module.lambda.invoke_arn
}

output "lambda_role_arn" {
  description = "ARN of the IAM role associated with the Lambda function"
  value       = module.lambda.role_arn
}

output "lambda_log_group_name" {
  description = "Name of the CloudWatch log group for the Lambda function"
  value       = module.lambda.cloudwatch_log_group_name
}
