variable "environment" {
  type        = string
  description = "Infra environment."
}

variable "project" {
  type        = string
  description = "Name of the project."
}

variable "number_of_untagged_images_to_keep" {
  type        = number
  description = "Number of untagged images to keep."
}

variable "purpose" {
  type        = string
  description = "Purpose of the ecr that will be used in the name of the ecr repo."
}
