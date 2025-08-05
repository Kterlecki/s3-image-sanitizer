module "label" {
  source      = "../label"
  type        = "s3"
  project     = var.project
  attribute   = var.purpose
  environment = var.environment
}
