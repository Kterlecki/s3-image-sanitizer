module "label" {
  source      = "../label"
  type        = "secret"
  project     = var.project
  environment = var.environment
  attribute   = var.secret_envvar_name
}
