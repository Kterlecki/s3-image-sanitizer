variable "project" {
  type        = string
  description = "Name of the project."
  default     = "imagesanitizer"
}

variable "environment" {
  type        = string
  description = "Infra environment."
  default     = "crossenv"
}

variable "number_of_untagged_images_to_keep" {
  type        = number
  description = "Number of untagged images to keep."
  default     = 30
}
