output "name" {
  value       = aws_s3_bucket_acl.bucket_acl.bucket
  description = "Bucket unique identifier"
}

output "arn" {
  value       = aws_s3_bucket.bucket.arn
  description = "ARN of the bucket"
}
