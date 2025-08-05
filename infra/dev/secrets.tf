module "user_a_secret" {
  source             = "../modules/secretmanager-secret"
  secret_envvar_name = "USER_A_SECRET"
  project            = var.project
  environment        = var.environment
  allowed_roles_arn  = local.allowed_roles_secrets
}
module "user_b_secret" {
  source             = "../modules/secretmanager-secret"
  secret_envvar_name = "USER_B_SECRET"
  project            = var.project
  environment        = var.environment
  allowed_roles_arn  = local.allowed_roles_secrets
}
module "user_a_key" {
  source             = "../modules/secretmanager-secret"
  secret_envvar_name = "USER_A_KEY"
  project            = var.project
  environment        = var.environment
  allowed_roles_arn  = local.allowed_roles_secrets
}
module "user_b_key" {
  source             = "../modules/secretmanager-secret"
  secret_envvar_name = "USER_B_KEY"
  project            = var.project
  environment        = var.environment
  allowed_roles_arn  = local.allowed_roles_secrets
}

locals {
  allowed_roles_secrets = concat(var.default_roles_for_accessing_secrets, [module.user_a.iam_user_arn, module.user_b.iam_user_arn])
}
