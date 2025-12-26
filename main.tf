terraform {
  backend "s3" {
    bucket         = "stines-solutions-state-bucket"
    key            = "infrastructure/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

data "aws_caller_identity" "current" {}

# ===== Artifacts Module (Lambda artifacts S3 bucket) =====
module "artifacts" {
  source = "./modules/artifacts"
}

# ===== Static Site CDN Module (Website S3 + CloudFront) =====
module "static_site_cdn" {
  source = "./modules/static_stite_cdn"
  
  domain_name               = var.domain_name
  domain_alternative_name   = var.domain_alternative_name
  certificate_arn           = module.dns.certificate_arn
}

# ===== DNS Module (Route53 + ACM Certificate) =====
module "dns" {
  source = "./modules/dns"
  
  domain_name             = var.domain_name
  domain_alternative_name = var.domain_alternative_name
  cloudfront_domain_name  = module.static_site_cdn.cloudfront_domain_name
  cloudfront_zone_id      = module.static_site_cdn.cloudfront_zone_id
}

# ===== API Gateway Module =====
module "api" {
  source = "./modules/api"
  
  lambda_function_arn = aws_lambda_function.contact_lambda.arn
  lambda_function_name = aws_lambda_function.contact_lambda.function_name
  domain_full_url     = var.domain_full_url
}

# ===== Lambda Function (Contact Form) =====
# The Lambda function references the artifact bucket from the artifacts module
data "aws_s3_object" "lambda_zip" {
  bucket = module.artifacts.lambda_artifact_bucket_name
  key    = var.lambda_code_s3_key
}

resource "aws_lambda_function" "contact_lambda" {
  function_name = var.lambda_function_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "sendEmailApi.handler"
  runtime       = "nodejs18.x"

  # Use S3 artifacts (provided by CI/CD pipeline)
  s3_bucket        = module.artifacts.lambda_artifact_bucket_name
  s3_key           = var.lambda_code_s3_key
  source_code_hash = data.aws_s3_object.lambda_zip.etag  # ensures updates when key changes

  environment {
    variables = {
      SOURCE_EMAIL      = var.source_email
      DESTINATION_EMAIL = var.destination_email
      DOMAIN_NAME       = var.domain_name
    }
  }
}

# ===== Lambda IAM Role and Policies =====
resource "aws_iam_role" "lambda_role" {
  name = var.lambda_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "lambda_ses_policy" {
  name        = "lambda-ses-policy"
  description = "Allow Lambda to send email via SES"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "ses:SendEmail",
        "ses:SendRawEmail"
      ]
      Effect   = "Allow"
      Resource = "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_ses_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_ses_policy.arn
}
