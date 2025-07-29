resource "aws_lambda_function" "lambda" {
  function_name = module.label.name
  role          = aws_iam_role.lambda_role.arn
  architectures = [var.lambda_architecture]
  timeout       = var.timeout
  package_type  = var.package_type
  image_uri     = var.image_uri
  memory_size   = var.memory_size

  ephemeral_storage {
    size = var.ephemeral_storage_size
  }

  image_config {
    command     = var.lambda_image_command
    entry_point = var.lambda_image_entrypoint
  }
  environment {
    variables = var.envvars
  }
  vpc_config {
    subnet_ids                  = var.subnet_ids
    security_group_ids          = [aws_security_group.lambda_sg.id]
    ipv6_allowed_for_dual_stack = false
  }
}
