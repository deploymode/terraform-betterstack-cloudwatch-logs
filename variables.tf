variable "artefact_s3_bucket" {
  description = "S3 bucket holding the Lambda deployment package. Must be in the same region as the function. Conflicts with artefact_filename"
  type        = string
  default     = null
}

variable "artefact_s3_key" {
  description = "S3 key of the Lambda deployment package"
  type        = string
  default     = null
}

variable "artefact_s3_object_version" {
  description = "S3 object version of the Lambda deployment package. Set to pin the reference against the key being overwritten"
  type        = string
  default     = null
}

variable "artefact_filename" {
  description = "Path to a local Lambda deployment package. Conflicts with artefact_s3_bucket"
  type        = string
  default     = null

  validation {
    condition     = (var.artefact_filename == null) != (var.artefact_s3_bucket == null)
    error_message = "Set exactly one of artefact_s3_bucket or artefact_filename."
  }
}

variable "lambda_runtime" {
  description = "Lambda runtime identifier. The default describes Logtail's stock package"
  type        = string
  default     = "nodejs22.x"
}

variable "lambda_handler" {
  description = "Lambda handler. The default describes Logtail's stock package"
  type        = string
  default     = "index.handler"
}

variable "lambda_architectures" {
  description = "Instruction set architecture for the function. The default describes Logtail's stock package"
  type        = list(string)
  default     = ["x86_64"]
}

variable "better_stack_token" {
  description = "BetterStack source token"
  type        = string
  sensitive   = true

  validation {
    condition     = length(trimspace(var.better_stack_token)) > 0
    error_message = "better_stack_token must not be empty."
  }
}

variable "better_stack_ingest_host" {
  description = "BetterStack ingesting host as shown on the source, without a scheme, e.g. in.example.betterstackdata.com. The module adds https://. A value that already starts with https:// is accepted"
  type        = string

  validation {
    condition     = length(trimspace(var.better_stack_ingest_host)) > 0 && !startswith(var.better_stack_ingest_host, "http://")
    error_message = "better_stack_ingest_host must be a non-empty host name. Plain http:// is not accepted."
  }
}

variable "lambda_environment_variables" {
  description = "Additional environment variables for the function, merged over BETTER_STACK_ENTRYPOINT and BETTER_STACK_SOURCE_TOKEN"
  type        = map(string)
  default     = {}
}

variable "log_group_names" {
  description = "Map of short names to Cloudwatch log group names to subscribe to"
  type        = map(string)
  default     = {}
}

variable "filter_pattern" {
  description = "Subscription filter pattern applied to every log group. Empty matches every line"
  type        = string
  default     = ""
}

variable "timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
  default     = 30
}

variable "memory_size" {
  description = "Lambda function memory size in MB"
  type        = number
  default     = 128
}

variable "reserved_concurrent_executions" {
  description = "Reserved concurrency for the function. -1 removes the limit. Alarm on the Throttles metric if you set one"
  type        = number
  default     = -1

  validation {
    condition     = var.reserved_concurrent_executions == -1 || var.reserved_concurrent_executions > 0
    error_message = "reserved_concurrent_executions must be -1 (no limit) or greater than zero. Lambda treats 0 as disabling the function; use enabled = false instead."
  }
}

variable "maximum_retry_attempts" {
  description = "Retries Lambda makes after a failed asynchronous invocation. CloudWatch Logs invokes asynchronously, so a retry resends the whole batch and duplicates lines the package already delivered. Set 0 to drop a failed batch instead"
  type        = number
  default     = 2

  validation {
    condition     = var.maximum_retry_attempts >= 0 && var.maximum_retry_attempts <= 2
    error_message = "maximum_retry_attempts must be between 0 and 2."
  }
}

variable "cloudwatch_logs_retention_in_days" {
  description = "Retention in days of the function's own CloudWatch log group"
  type        = number
  default     = 14
}
