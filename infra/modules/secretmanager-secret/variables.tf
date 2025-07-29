variable "project" {
  type        = string
  description = "Name of the project."
}

variable "secret_envvar_name" {
  type        = string
  description = "Name of the secret variable"
}

variable "environment" {
  type        = string
  description = "Name of the environment to be mentiontioned in the resource name."
}

variable "name_override" {
  type        = string
  description = "For backward compitability - ability to override the entire name"
  default     = null
}

variable "allowed_roles_arn" {
  type        = list(string)
  description = "List of allowed roles to access the secret. If empty, no additional access restrictions added."
  default     = []
}
