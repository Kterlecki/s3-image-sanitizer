module "label" {
  source      = "../label"
  type        = "lambda"
  project     = var.project
  environment = var.environment
}