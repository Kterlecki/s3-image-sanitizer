variable "project" {
  type        = string
  description = "Name of the project"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "iam_user_policy_statements" {
  type        = any
  description = "A list of policy statements to allow the iam user to access AWS resources."
  default     = []
}

variable "purpose" {
  type        = string
  description = "Purpose of the iam user function"
}

