terraform {
  backend "s3" {
    bucket = "imagesanitizer-s3-state"
    key    = "dev/imagesanitizer/terraform.tfstate"
    region = "us-east-1"

    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "imagesanitizer" {
  # VPC shouldnt be created in this project, as a result we are using a data source to query the existing VPC.
  # So this query selects VPC.
  default = false
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.imagesanitizer.id]
  }
}

data "aws_subnet" "selected_subnet" {
  for_each = toset(local.subnet_ids)
  id       = each.value
}

locals {
  # Assuming multiple subnets are available, we select the first and the last one for redundancy.
  # This is a simplistic approach; in production, you might want to select subnets based on specific criteria.
  # Ensure that the selected subnets are in different availability zones for high availability.
  subnet_ids = [
    data.aws_subnets.all.ids[1],
    data.aws_subnets.all.ids[length(data.aws_subnets.all.ids) - 4]
  ]
}

module "label_ecr" {
  source      = "../../modules/label"
  type        = "ecrrepository"
  project     = var.project
  environment = "crossenv"
  attribute   = "artifactstorage"
}

data "aws_ecr_repository" "imagesanitizer" {
  name = module.label_ecr.repository_name
}
