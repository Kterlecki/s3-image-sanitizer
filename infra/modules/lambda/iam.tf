resource "aws_iam_role" "lambda_role" {
  name               = module.label_lambda_role.name
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy_document.json
  tags               = module.label_lambda_role.tags
}

data "aws_iam_policy_document" "lambda_assume_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_role_access_resource_policy" {
  count = length(var.lambda_role_policy_statements) > 0 ? 1 : 0

  dynamic "statement" {
    for_each = var.lambda_role_policy_statements

    content {
      sid           = try(statement.value.sid, null)
      effect        = try(statement.value.effect, null)
      actions       = try(statement.value.actions, null)
      not_actions   = try(statement.value.not_actions, null)
      resources     = try(statement.value.resources, null)
      not_resources = try(statement.value.not_resources, null)

      dynamic "principals" {
        for_each = try(statement.value.principals, [])

        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }
    }
  }
}

resource "aws_iam_policy" "lambda_role_access_resource_policy" {
  count  = length(var.lambda_role_policy_statements) > 0 ? 1 : 0
  name   = module.label_lambda_aws_access_policy.name
  policy = data.aws_iam_policy_document.lambda_role_access_resource_policy[0].json
  tags   = module.label.tags
}

resource "aws_iam_role_policy_attachment" "lambda_role_access_resource_policy_attach" {
  count      = length(var.lambda_role_policy_statements) > 0 ? 1 : 0
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_role_access_resource_policy[0].arn
}
