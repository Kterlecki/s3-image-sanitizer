locals {
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last ${var.number_of_untagged_images_to_keep} images",
        selection = {
          tagStatus   = "untagged",
          countType   = "imageCountMoreThan",
          countNumber = var.number_of_untagged_images_to_keep
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = module.label.tags
}

resource "aws_ecr_lifecycle_policy" "keep_untagged_images" {
  repository = aws_ecr_repository.this.name
  policy     = local.repository_lifecycle_policy
}
