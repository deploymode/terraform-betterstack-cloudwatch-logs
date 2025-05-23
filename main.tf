data "external" "download_and_verify" {
  program = ["python3", "${path.module}/scripts/get_package.py"]

  query = {
    url      = var.package_url
    checksum = var.package_checksum
    file_name = "logtail-aws-lambda.zip"
  }
}

data "aws_region" "current" {}

module "lambda" {
  source  = "cloudposse/lambda-function/aws"
  version = "0.6.1"

  filename      = data.external.download_and_verify.result["file"]
  function_name = module.this.id
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  lambda_environment = {
    variables = {
    BETTER_STACK_ENTRYPOINT   = var.better_stack_ingest_host
    BETTER_STACK_SOURCE_TOKEN = var.better_stack_token
    }
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
  principal     = "logs.${data.aws_region.current.name}.amazonaws.com"
  source_arn    = "${data.aws_cloudwatch_log_group.default[each.key].arn}:*"
}

resource "aws_cloudwatch_log_subscription_filter" "log_subscriptions" {
  for_each = var.log_group_names

  name            = module.this.id
  log_group_name  = each.value
  filter_pattern  = "" # match everything
  destination_arn = module.lambda.arn
}
