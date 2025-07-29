module "label" {
  source      = "../label"
  type        = "lambda"
  project     = var.project
  environment = var.environment
  attribute   = var.purpose
}

module "label_lambda_role" {
  source    = "../label"
  context   = module.label.context
  type      = "role"
  attribute = var.purpose
}

module "label_sg" {
  source    = "../label"
  context   = module.label.context
  type      = "sg"
  attribute = var.purpose
}

module "label_lambda_aws_access_policy" {
  source  = "../label"
  context = module.label.context
  type    = "policy"
}
