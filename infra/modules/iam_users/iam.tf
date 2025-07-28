# IAM Users for S3 Image Sanitizer - not recommended as IAM roles a better solution

# User A - Read/Write access to Bucket A (landing bucket)
resource "aws_iam_user" "user_a" {
  name = "${module.label}-user-a"
  path = "/"

}

resource "aws_iam_access_key" "user_a_key" {
  user = aws_iam_user.user_a.name
}

# User A Policy - Read/Write to Landing Bucket (Bucket A)
resource "aws_iam_user_policy" "user_a_policy" {
  name = "${module.label}-user-a-s3-policy"
  user = aws_iam_user.user_a.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
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
          "arn:aws:s3:::${var.landing_s3_bucket_id}",
          "arn:aws:s3:::${var.landing_s3_bucket_id}/*"
        ]
      }
    ]
  })
}

# User B - Read access to Bucket B (output bucket)
resource "aws_iam_user" "user_b" {
  name = "${module.label}-user-b"
  path = "/"
}

resource "aws_iam_access_key" "user_b_key" {
  user = aws_iam_user.user_b.name
}

# User B Policy - Read-only access to Output Bucket (Bucket B)
resource "aws_iam_user_policy" "user_b_policy" {
  name = "${module.label}-user-b-s3-policy"
  user = aws_iam_user.user_b.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowUserBReadOutputBucket"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = [
          var.output_s3_bucket_arn,
          "${var.output_s3_bucket_arn}/*"
        ]
      }
    ]
  })
}
