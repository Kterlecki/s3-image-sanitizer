terraform {
  backend "s3" {
    bucket = "imagesanitizer-s3-state"
    key    = "dev/imagesanitizer/terraform.tfstate"
    region = "us-east-1"

    use_lockfile   = true
    encrypt        = true
  }
}

provider "aws" {
  region = "us-east-1"
}
