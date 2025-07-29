resource "aws_secretsmanager_secret" "main" {
  name                    = var.name_override == null ? module.label.name : var.name_override
  recovery_window_in_days = 0
  tags                    = module.label.tags
}
