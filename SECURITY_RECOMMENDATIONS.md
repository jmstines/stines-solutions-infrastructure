# Infrastructure Security Recommendations

## Status
- ✅ **Implemented**: API Gateway rate limiting
- ✅ **Implemented**: Lambda function restricted to API Gateway only
- ⚠️ **Pending**: Items below

## High Priority

### 1. AWS WAF for API Gateway
**Risk**: DDoS attacks, common web exploits
**Impact**: High - Could result in service disruption or data breach

Add AWS WAF to protect the API Gateway:
```terraform
resource "aws_wafv2_web_acl" "api_waf" {
  name  = "contact-api-waf"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "RateLimitRule"
    priority = 1

    override_action {
      none {}
    }

    statement {
      rate_based_statement {
        limit              = 2000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitRule"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "ContactAPIWAF"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "api_association" {
  resource_arn = aws_api_gateway_stage.contact_stage.arn
  web_acl_arn  = aws_wafv2_web_acl.api_waf.arn
}
```

**Estimated Cost**: ~$5-10/month + $0.60 per million requests

### 2. CloudFront Security Headers
**Risk**: Clickjacking, XSS attacks
**Impact**: Medium - Could expose users to malicious content

Add response headers policy to CloudFront:
```terraform
resource "aws_cloudfront_response_headers_policy" "security_headers" {
  name = "security-headers-policy"

  security_headers_config {
    content_type_options {
      override = true
    }
    frame_options {
      frame_option = "DENY"
      override     = true
    }
    referrer_policy {
      referrer_policy = "strict-origin-when-cross-origin"
      override        = true
    }
    xss_protection {
      mode_block = true
      protection = true
      override   = true
    }
    strict_transport_security {
      access_control_max_age_sec = 31536000
      include_subdomains         = true
      override                   = true
    }
    content_security_policy {
      content_security_policy = "default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline';"
      override                = true
    }
  }
}

# Add to CloudFront distribution
resource "aws_cloudfront_distribution" "website_cdn" {
  # ... existing config ...
  
  default_cache_behavior {
    # ... existing config ...
    response_headers_policy_id = aws_cloudfront_response_headers_policy.security_headers.id
  }
}
```

## Medium Priority

### 3. API Gateway Access Logging Enhancement
**Current**: Basic access logs enabled
**Improvement**: Add detailed execution logs and alarms

Add CloudWatch alarms for suspicious activity:
```terraform
resource "aws_cloudwatch_metric_alarm" "api_4xx_errors" {
  alarm_name          = "contact-api-high-4xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "4XXError"
  namespace           = "AWS/ApiGateway"
  period              = 300
  statistic           = "Sum"
  threshold           = 50
  alarm_description   = "Alert when API has high 4xx errors"
  
  dimensions = {
    ApiName = "contact-api"
  }
}
```

### 4. S3 Bucket Versioning
**Risk**: Accidental deletion or overwrite of website files
**Impact**: Low - Can redeploy from source

Enable versioning on the website bucket:
```terraform
resource "aws_s3_bucket_versioning" "website" {
  bucket = aws_s3_bucket.website.id
  
  versioning_configuration {
    status = "Enabled"
  }
}
```

### 5. Secrets Manager for Email Configuration
**Current**: Email addresses in environment variables
**Improvement**: Move to AWS Secrets Manager

**Estimated Cost**: $0.40/month per secret

## Low Priority

### 6. CloudTrail for Audit Logging
Enable CloudTrail to track all API calls for compliance and forensics.

### 7. GuardDuty
Enable AWS GuardDuty for intelligent threat detection.

**Estimated Cost**: ~$5-10/month for small workload

## Cost Summary
- WAF: ~$5-10/month
- Secrets Manager: ~$1/month
- GuardDuty: ~$5-10/month
- **Total**: ~$11-21/month additional

## Review Schedule
- Review quarterly or after any security incident
- Last updated: January 2, 2026
