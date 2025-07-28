variable "project" {
  type        = string
  description = "Name of the project"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "landing_s3_bucket_id" {
  type        = string
  description = "Landing S3 bucket ID"
}

variable "output_s3_bucket_arn" {
  type        = string
  description = "Output S3 bucket ARN"
}
