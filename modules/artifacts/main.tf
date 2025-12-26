# aws_s3_bucket.lambda_artifacts
# Output:

# lambda_artifact_bucket_name

resource "aws_s3_bucket" "lambda_artifacts" {
    bucket = "stines-solutions-lambda-artifacts"
}