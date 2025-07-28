variable "project" {
  type        = string
  description = "Name of the project."
}

variable "environment" {
  type        = string
  description = "Name of the environment to be mentiontioned in the resource name."
}

variable "purpose" {
  type        = string
  description = "Purpose of the lambda function"
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID"
}
variable "subnet_ids" {
  type        = list(string)
  description = "The subnet IDs that the lambda function will use"
}

variable "lambda_architecture" {
  type        = string
  description = "The architecture that the lambda function will use, i.e. arm64 or x86_64"
}

variable "timeout" {
  type        = string
  description = "The timeout for the lambda function"
}

variable "image_uri" {
  type        = string
  description = "The image for the lambda function"
}

variable "package_type" {
  type        = string
  description = "The package type for the lambda function"
}

variable "envvars" {
  type        = map(string)
  description = "A dictionary which's Key is an name of envvar and Value is the value given for that variable"
}

variable "lambda_image_command" {
  type        = list(string)
  description = "The Lambda Handler image command used to specify the entry point for the lambda function to target."
}

variable "lambda_image_entrypoint" {
  type        = list(string)
  description = "Specifies the entrypoint required to invoke a Lambda function"
}

variable "lambda_role_policy_statements" {
  type        = any
  description = "A list of policy statements to allow the ecs task to access AWS resources. This is what the container application will use."
  default     = []
}

variable "memory_size" {
  type        = number
  description = "The memory size for the lambda function in MB"
}

variable "ephemeral_storage_size" {
  type        = number
  description = "The ephemeral storage size for the lambda function in MB (512-10240)"
  default     = 512
}
