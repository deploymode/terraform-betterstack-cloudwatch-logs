output "lambda_function_arn" {
  description = "ARN of the created Lambda function"
  value       = module.log_forwarder.lambda_function_arn
}
