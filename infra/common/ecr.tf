module "imagesanitizer_ecr" {
  source                            = "../modules/ecr"
  project                           = var.project
  environment                       = var.environment
  number_of_untagged_images_to_keep = var.number_of_untagged_images_to_keep
  purpose                           = "artifactstorage"
}
