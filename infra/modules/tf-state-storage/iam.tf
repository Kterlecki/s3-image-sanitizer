data "aws_caller_identity" "current" {}

resource "aws_iam_role" "tf_state_management_role" {
  name = "${module.label_tf_state_management_role.name}-role"

  assume_role_policy   = data.aws_iam_policy_document.s3_state_assume_role_policy.json
  tags                 = module.label.tags
}

data "aws_iam_policy_document" "s3_state_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "AWS"
      identifiers = [
        data.aws_caller_identity.current.arn
      ]
    }
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "tf_state_management_policy_document" {
  statement {
    actions = [
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.terraform_state_bucket.arn
    ]
  }

  statement {
    actions = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]

    resources = [
      "${aws_s3_bucket.terraform_state_bucket.arn}/*"
    ]
  }

}

resource "aws_iam_policy" "iam_state_management_policy" {
  name   = "${module.label_tf_state_management_role.name}-policy"
  policy = data.aws_iam_policy_document.tf_state_management_policy_document.json
  tags   = module.label.tags
}

resource "aws_iam_role_policy_attachment" "policy_attach" {
  role       = aws_iam_role.tf_state_management_role.name
  policy_arn = aws_iam_policy.iam_state_management_policy.arn
}
