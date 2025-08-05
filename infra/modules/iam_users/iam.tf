# IAM Users for S3 Image Sanitizer - not recommended as IAM roles a better solution

resource "aws_iam_user" "user" {
  name = "${module.label}-${var.purpose}"
  path = "/"

}

resource "aws_iam_access_key" "user_key" {
  user = aws_iam_user.user.name
}

# User Policy - Permissions given to user for specific resource
resource "aws_iam_user_policy" "user_policy" {
  name = "${module.label}-${var.purpose}-s3-policy"
  user = aws_iam_user.user.name

  policy = jsonencode({
    Statement = var.iam_user_policy_statements
    Version   = "2012-10-17"
  })
}
