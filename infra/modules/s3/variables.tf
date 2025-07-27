variable "purpose" {
  type        = string
  description = "Purpose of the bucket that will be used in the name of the bucket."
}

variable "project" {
  type        = string
  description = "Name of the project."
}

variable "are_bucket_notifications_enabled" {
  type        = bool
  description = "Bucket will be used for eventing. This enables event notification to be sent out from S3 to EventBridge."
  default     = false
}

variable "abort_incomplete_multipart_upload_after_days" {
  type        = number
  description = "Cost saving rule. Number of days after which an incomplete upload is aborted."
  default     = 7
}

variable "environment" {
  type        = string
  description = "Name of the environment to be mentiontioned in the resource name."
}

variable "is_intransit_https_enabled" {
  type        = bool
  description = "Data will travel to and from bucket in encrypted form and secured by HTTPS."
  default     = false
}

variable "expire_after_days" {
  type        = number
  description = "Number of days after which files in the bucket are permanently deleted."
  default     = 1
}

variable "is_expiration_lifecycle_rule_enabled" {
  type        = bool
  description = "Objects in S3 bucket can be permanently deleted from the bucket."
  default     = false
}

variable "enable_s3_bucket_versioning" {
  type        = string
  description = "Enable S3 bucket versioning."
  default     = "Disabled"
}
