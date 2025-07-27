module "label" {
  source          = "../label"
  type            = "s3"
  project         = var.project
  environment     = var.environment
  attribute       = "state"
}

module "label_tf_state_management_role" {
  source    = "../label"
  type      = "role"
  attribute = "tfstate-management"
  context   = module.label.context
}
