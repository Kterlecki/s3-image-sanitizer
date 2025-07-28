variable "environment" {
  type        = string
  description = "Name of the environment to be mentiontioned in the resource name."
  default     = "dev"
}

variable "purpose" {
  description = "Purpose of the functionality"
  type        = string
  default     = "etl"
}

variable "project" {
  type        = string
  description = "Name of the project."
  default     = "imagesanitizer"
}

variable "lambda_image_command" {
  type        = list(string)
  description = "The Lambda Handler image command used to specify the entry point for the lambda function to target."
  default     = ["apps.etl.src.main.handler"]
}

variable "lambda_image_entrypoint" {
  type        = list(string)
  description = "Specifies the entrypoint required to invoke a Lambda function"
  default     = ["/usr/local/bin/python", "-m", "awslambdaric"]
}
variable "package_type" {
  type        = string
  description = "The package type for the lambda function"
  default     = "Image"
}

# variable "imagesanitizer_ecr_url" {
#   description = "URL for the ECR repository of ImageSanitizer"
#   type        = string
#   default     = "{amazon-account-id}.dkr.ecr.us-east-1.amazonaws.com/imagesanitizer-crossenv-ecrrepository-artifactstorage"
# }

variable "lambda_timeout" {
  type        = string
  description = "The timeout for the lambda function"
  default     = "300" # 5 minutes for larger file processing
}

# Use arm64 architecture for better performance and cost efficiency
variable "lambda_architecture" {
  type        = string
  description = "The architecture that the lambda function will use, i.e. arm64"
  default     = "arm64"
}
variable "memory_size" {
  type        = number
  description = "The memory size for the lambda function in MB"
  default     = 1024
}

variable "ephemeral_storage_size" {
  type        = number
  description = "The ephemeral storage size for the lambda function in MB"
  default     = 2048
}
