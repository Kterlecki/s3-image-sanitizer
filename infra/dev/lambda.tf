module "imagesanitizer_lambda" {
  source                  = "../modules/lambda"
  project                 = var.project
  environment             = var.environment
  purpose                 = var.purpose
  vpc_id                  = data.aws_vpc.imagesanitizer.id
  subnet_ids              = local.subnet_ids
  lambda_architecture     = var.lambda_architecture
  timeout                 = var.lambda_timeout
  envvars                 = local.env_vars
  image_uri               = local.imagesanitizer_container_image
  lambda_image_command    = var.lambda_image_command
  lambda_image_entrypoint = var.lambda_image_entrypoint
  package_type            = var.package_type
  memory_size             = var.memory_size
  ephemeral_storage_size  = var.ephemeral_storage_size
  lambda_role_policy_statements = [
    {
      sid    = "ImageSanitizerAllowECRPull"
      effect = "Allow"
      actions = [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:SetRepositoryPolicy",
        "ecr:GetAuthorizationToken"
      ]
      resources = [
        "*"
      ]
    },
    {
      sid    = "ImageSanitizerAllowLambdaToStart"
      effect = "Allow"
      actions = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "secretsmanager:GetSecretValue",
        "kms:Decrypt",
        "lambda:InvokeFunction",
        "ec2:DescribeNetworkInterfaces",
        "ec2:CreateNetworkInterface",
        "ec2:DeleteNetworkInterface",
        "ec2:DescribeInstances",
        "ec2:AttachNetworkInterface"
      ]
      resources = [
        "*"
      ],
    },
    {
      sid    = "ImageSanitizerAllowS3Access"
      effect = "Allow"
      actions = [
        "s3:GetObject",
        "s3:ListBucket",
        "s3:GetBucketLocation"
      ]
      resources = [
        module.image_landing_s3.arn,
        "${module.image_landing_s3.arn}/*",
      ]
    },
    {
      sid    = "ImageSanitizerAllowS3Push"
      effect = "Allow"
      actions = [
        "s3:PutObject",
      ]
      resources = [
        module.image_output_s3.arn,
        "${module.image_output_s3.arn}/*"
      ]
    }
  ]
}

locals {
  ecr_url                        = data.aws_ecr_repository.imagesanitizer.repository_url
  image_tag                      = var.environment
  imagesanitizer_container_image = "${local.ecr_url}:${local.image_tag}"

  env_vars = {
    "PARAMETERS_SECRETS_EXTENSION_HTTP_PORT" = "2773"
    "S3_BUCKET"                              = data.aws_s3_bucket.processed_files.bucket
  }
}
