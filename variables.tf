variable "package_url" {
  description = "URL of the package to download"
  type        = string
  default     = "https://github.com/logtail/logtail-aws-lambda/releases/latest/download/logtail-aws-lambda.zip"
}

variable "package_checksum" {
  description = "Checksum of the package to verify"
  type        = string
  default     = "0588b968a890616f5fc877408f49381401496ca97b3a66c2e52e2096918b7119"
}

variable "better_stack_token" {
  description = "BetterStack token"
  type        = string
}

variable "better_stack_ingest_host" {
  description = "https endpoint for BetterStack ingest host. Prefix with https://"
  type        = string
}

variable "log_group_names" {
  description = "Map of short names to Cloudwatch log group names to subscribe to"
  type        = map(string)
  default     = {}
}

variable "timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 3
}

variable "memory_size" {
  description = "Lambda function memory size in MB"
  type        = number
  default     = 128
}
