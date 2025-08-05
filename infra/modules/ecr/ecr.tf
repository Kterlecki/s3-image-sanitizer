resource "aws_ecr_repository" "this" {
  image_tag_mutability = "MUTABLE"
  name                 = module.label.name
  tags                 = module.label.tags

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = true
  }
}
