variable "region" {
  type = string
}

variable "artefact_s3_bucket" {
  description = "S3 bucket holding the Lambda deployment package"
  type        = string
}

variable "artefact_s3_key" {
  description = "S3 key of the Lambda deployment package"
  type        = string
}

variable "better_stack_token" {
  description = "BetterStack token"
  type        = string
}

variable "better_stack_ingest_host" {
  description = "BetterStack ingest host"
  type        = string
}
