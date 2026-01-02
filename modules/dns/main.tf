# aws_route53_zone.main
# aws_route53_record.main_site
# aws_route53_record.redirect_site (point both apex + www to the same CloudFront distribution)
# aws_acm_certificate.cert (us-east-1 provider alias)
# Add: aws_acm_certificate_validation with DNS validation records
# Output:

# hosted_zone_id
# certificate_arn
# domain_name

# aws_route53_zone.main
# aws_route53_record.main_site
# aws_route53_record.redirect_site (point both apex + www to the same CloudFront distribution)
# aws_acm_certificate.cert (us-east-1 provider alias)
# Add: aws_acm_certificate_validation with DNS validation records
# Output:

# hosted_zone_id
# certificate_arn
# domain_name

resource "aws_route53_zone" "main" {
  name = "stinessolutions.com"
}

resource "aws_route53_record" "redirect_site" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_alternative_name
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "main_site" {
  zone_id = aws_route53_zone.main.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.cloudfront_domain_name
    zone_id                = var.cloudfront_zone_id
    evaluate_target_health = false
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  subject_alternative_names = [
    var.domain_alternative_name,
    "api.${var.domain_name}"
  ]

  lifecycle {
    create_before_destroy = true
  }
}