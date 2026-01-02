# aws_s3_bucket.lambda_artifacts
# Output:

# lambda_artifact_bucket_name

resource "aws_s3_bucket" "lambda_artifacts" {
    bucket = "stines-solutions-lambda-artifacts"
}

resource "aws_s3_bucket_lifecycle_configuration" "lambda_artifacts" {
  bucket = aws_s3_bucket.lambda_artifacts.id

  rule {
    id     = "delete-old-lambdas"
    status = "Enabled"

    filter {
      prefix = "lambda/contact/"
    }

    expiration {
      days = 7
    }
  }
}