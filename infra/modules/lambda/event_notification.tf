resource "aws_lambda_permission" "allow_s3_invoke" {
  statement_id  = "AllowS3Invoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_sanitizer.function_name
  principal     = "s3.amazonaws.com"

  source_arn = var.landing_s3_bucket_arn
  
}

resource "aws_s3_bucket_notification" "notify_lambda" {
  bucket = var.landing_s3_bucket_id

  lambda_function {
    events = ["s3:ObjectCreated:*"]
    filter_prefix = "images/"
    filter_suffix = ".jpg"
    lambda_function_arn = aws_lambda_function.image_sanitizer.arn
  }

  depends_on = [aws_lambda_permission.allow_s3_invoke]
}

# Decided to go with S3 event notifications instead of EventBridge for simplicity
# EventBridge could be used for more complex workflows or if you need to trigger multiple targets
# but for this use case, S3 event notifications are sufficient and more straightforward.
