module "label" {
  source          = "../../modules/label"
  type            = "ecrrepository"
  project         = var.project
  environment     = var.environment
  attribute       = var.purpose
}
