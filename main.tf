data "aws_region" "current" {}

locals {
  function_log_group_name = "/aws/lambda/${module.this.id}"
  better_stack_entrypoint = startswith(var.better_stack_ingest_host, "https://") ? var.better_stack_ingest_host : "https://${var.better_stack_ingest_host}"
}

module "lambda" {
  source  = "cloudposse/lambda-function/aws"
  version = "0.6.1"

  filename          = var.artefact_filename
  s3_bucket         = var.artefact_s3_bucket
  s3_key            = var.artefact_s3_key
  s3_object_version = var.artefact_s3_object_version

  function_name                  = module.this.id
  handler                        = var.lambda_handler
  runtime                        = var.lambda_runtime
  architectures                  = var.lambda_architectures
  timeout                        = var.timeout
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.reserved_concurrent_executions

  lambda_environment = {
    variables = merge(
      {
        BETTER_STACK_ENTRYPOINT   = local.better_stack_entrypoint
        BETTER_STACK_SOURCE_TOKEN = var.better_stack_token
      },
      var.lambda_environment_variables
    )
  }
}

data "aws_cloudwatch_log_group" "default" {
  for_each = var.log_group_names

  name = each.value
}

resource "aws_lambda_permission" "allow_cloudwatch_logs" {
  for_each = var.log_group_names

  action        = "lambda:InvokeFunction"
  function_name = module.lambda.function_name
  principal     = "logs.${data.aws_region.current.region}.amazonaws.com"
  source_arn    = "${data.aws_cloudwatch_log_group.default[each.key].arn}:*"
}

resource "aws_cloudwatch_log_subscription_filter" "log_subscriptions" {
  for_each = var.log_group_names

  name            = module.this.id
  log_group_name  = each.value
  filter_pattern  = var.filter_pattern
  destination_arn = module.lambda.arn

  lifecycle {
    precondition {
      condition     = each.value != local.function_log_group_name
      error_message = "log_group_names entry \"${each.key}\" is the forwarder's own log group (${local.function_log_group_name}). Subscribing it makes the function invoke itself on its own output."
    }
  }
}
