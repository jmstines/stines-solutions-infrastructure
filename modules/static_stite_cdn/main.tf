# aws_s3_bucket.website
# aws_s3_bucket_public_access_block.website_block (fix to block all public access)
# aws_s3_bucket_policy.website_policy (fix policy—see below)
# aws_cloudfront_origin_access_control.oac
# aws_cloudfront_distribution.website_cdn (update to modern cache policies; add SPA fallback)
# Remove: aws_cloudfront_origin_access_identity.oai (unused with OAC)
# Remove: aws_s3_bucket.redirect_site (CloudFront can serve both apex+www via aliases; if you want www→apex redirect, do it with a CloudFront Function or response headers)
# Outputs:

# website_bucket_name
# cloudfront_distribution_id
# cloudfront_distribution_arn
# cloudfront_domain_name

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "website" {
  bucket = "stinessolutions.com"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  tags = {
    Name        = "Stines Solutions Static Website"
    Environment = "Production"
    Owner       = "Jeffrey Stines"
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket" "redirect_site" {
  bucket = "www.stinessolutions.com"

  website {
    redirect_all_requests_to = "stinessolutions.com"
  }

  tags = {
    Name        = "Redirect Bucket"
    Environment = "Production"
    Owner       = "Jeffrey Stines"
  }
  
  lifecycle {
      prevent_destroy = false
      ignore_changes  = [bucket]
    }
}

resource "aws_s3_bucket_public_access_block" "website_block" {
  bucket                  = aws_s3_bucket.website.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "website_policy" {
    bucket = aws_s3_bucket.website.id
    policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
        {
        Sid       = "AllowCloudFrontReadViaOAC",
        Effect    = "Allow",
        Principal = { Service = "cloudfront.amazonaws.com" },
        Action    = ["s3:GetObject"],
        Resource  = "${aws_s3_bucket.website.arn}/*",
        Condition = {
            StringEquals = {
            "AWS:SourceArn"     = aws_cloudfront_distribution.website_cdn.arn,
            "AWS:SourceAccount" = data.aws_caller_identity.current.account_id
            }
        }
        }
    ]
    })
}

resource "aws_cloudfront_origin_access_control" "oac" {
  name                              = "S3-OAC"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "website_cdn" {
  origin {
    domain_name              = aws_s3_bucket.website.bucket_regional_domain_name
    origin_id                = "S3-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.oac.id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = [var.domain_alternative_name, var.domain_name]

  viewer_certificate {
    acm_certificate_arn      = var.certificate_arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
  
  default_cache_behavior {
    target_origin_id       = "S3-origin" # Match origin_id exactly
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    compress              = true

    cache_policy_id            = data.aws_cloudfront_cache_policy.caching_optimized.id
    origin_request_policy_id   = data.aws_cloudfront_origin_request_policy.cors_s3_origin.id
  }

  custom_error_response {
    error_code         = 404
    response_code      = 200
    response_page_path = "/index.html"
  }
  custom_error_response {
    error_code         = 403
    response_code      = 200
    response_page_path = "/index.html"
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US"]
    }
  }
}

data "aws_cloudfront_cache_policy" "caching_optimized" {
  name = "Managed-CachingOptimized"
}
data "aws_cloudfront_origin_request_policy" "cors_s3_origin" {
  name = "Managed-CORS-S3Origin"
}
