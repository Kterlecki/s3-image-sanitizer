module "image_landing_s3" {
  source                           = "../modules/s3"
  project                          = var.project
  purpose                          = "${var.purpose}-landing"
  environment                      = var.environment
  are_bucket_notifications_enabled = true
  is_intransit_https_enabled       = true
}

module "image_output_s3" {
  source                           = "../modules/s3"
  project                          = var.project
  purpose                          = "${var.purpose}-output"
  environment                      = var.environment
  are_bucket_notifications_enabled = true # Enabled for S3 event notifications,  Notifiying potential downstream processes
  is_intransit_https_enabled       = true
}

module "lambda_python_zip_s3" {
  source                           = "../modules/s3"
  project                          = var.project
  purpose                          = "${var.purpose}-lambda-python-zip"
  environment                      = var.environment
  are_bucket_notifications_enabled = false
  is_intransit_https_enabled       = true
  enable_s3_bucket_versioning      = "Enabled" 
}
