data "aws_iam_policy_document" "secrets_access_policy" {
  count = length(var.allowed_roles_arn) == 0 ? 0 : 1
  statement {
    sid    = "RestrictAccessToSecrets"
    effect = "Deny"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    resources = [aws_secretsmanager_secret.main.arn]
    condition {
      test     = "StringNotLike"
      variable = "aws:PrincipalArn"
      values   = var.allowed_roles_arn
    }
  }
  statement {

  }
}

resource "aws_secretsmanager_secret_policy" "client_secret_access_policy" {
  count      = length(var.allowed_roles_arn) == 0 ? 0 : 1
  policy     = data.aws_iam_policy_document.secrets_access_policy[0].json
  secret_arn = aws_secretsmanager_secret.main.arn
}
