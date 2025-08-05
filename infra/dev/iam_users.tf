module "user_a" {
  source      = "../modules/iam_users"
  project     = var.project
  environment = var.environment
  purpose     = "user-a"
  iam_user_policy_statements = [
    {
      Sid    = "AllowUserAReadWriteLandingBucket"
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket",
        "s3:GetBucketLocation"
      ]
      Resource = [
        module.image_landing_s3.arn,
        "${module.image_landing_s3.arn}/*"
      ]
    },
    {
      Sid    = "DenyUserIamAccess"
      Effect = "Deny"
      Action = [
        "iam:*"
      ]
      Resource = [
        "*"
      ]
    }
  ]
}
module "user_b" {
  source      = "../modules/iam_users"
  project     = var.project
  environment = var.environment
  purpose     = "user-b"
  iam_user_policy_statements = [
    {
      Sid    = "AllowUserAReadWriteLandingBucket"
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket",
        "s3:GetBucketLocation"
      ]
      Resource = [
        module.image_landing_s3.arn,
        "${module.image_landing_s3.arn}/*"
      ]
    },
    {
      Sid    = "DenyUserIamAccess"
      Effect = "Deny"
      Action = [
        "iam:*"
      ]
      Resource = [
        "*"
      ]
    }
  ]
}