output "lambda_artifact_bucket_name" {
  value = aws_s3_bucket.lambda_artifacts.bucket
}

output "lambda_artifact_bucket_arn" {
  value = aws_s3_bucket.lambda_artifacts.arn
}
