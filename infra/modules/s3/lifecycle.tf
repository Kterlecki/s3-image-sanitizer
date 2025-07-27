resource "aws_s3_bucket_lifecycle_configuration" "lifecycle" {
  bucket = aws_s3_bucket.bucket.id
  # When Amazon S3 aborts a multipart upload, it deletes all the parts associated with the multipart upload.
  # This process helps control your storage costs by ensuring that you don't have incomplete multipart uploads with parts that are stored in Amazon S3.
  rule {
    id     = "abort-incomplete-multipart-upload-after-${var.abort_incomplete_multipart_upload_after_days}-days"
    status = "Enabled"
    filter {}

    abort_incomplete_multipart_upload {
      days_after_initiation = var.abort_incomplete_multipart_upload_after_days
    }
  }
  # Objects in current version of the S3 bucket can be permanently deleted from the bucket.
  rule {
    id     = var.is_expiration_lifecycle_rule_enabled ? "expire-after-${var.expire_after_days}-days" : "expiration-lifecycle-rule-disabled"
    status = var.is_expiration_lifecycle_rule_enabled ? "Enabled" : "Disabled"
    filter {}
    
    # Only delete objects that are current versions, Each upload will have a unique name, so dont need to enable noncurrent version expiration
    expiration {
      days = var.expire_after_days
    }
  }
}

# # Transition to cheaper storage classes
# rule {
#   id     = "storage-class-transitions"
#   status = "Enabled"
#   filter {}
  
#   transition {
#     days          = 30
#     storage_class = "STANDARD_IA"  # Infrequent Access
#   }
  
#   transition {
#     days          = 90
#     storage_class = "GLACIER"      # Archive after 90 days
#   }
  
#   transition {
#     days          = 365
#     storage_class = "DEEP_ARCHIVE" # Deep archive after 1 year
#   }
# }