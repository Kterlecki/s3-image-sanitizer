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
