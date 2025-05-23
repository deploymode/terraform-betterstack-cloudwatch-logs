resource "random_pet" "this" {
  length = 2
}

resource "aws_cloudwatch_log_group" "default" {
  name              = "/test/${random_pet.this.id}"
  retention_in_days = 7
}

module "log_forwarder" {
  source = "../.."

  better_stack_token       = var.better_stack_token
  better_stack_ingest_host = var.better_stack_ingest_host

  log_group_names = {
    default = aws_cloudwatch_log_group.default.name
  }

  context = module.this.context
}
