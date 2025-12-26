output "hosted_zone_id" {
  value = aws_route53_zone.main.zone_id
}

output "certificate_arn" {
  value = aws_acm_certificate.cert.arn
}

output "domain_name" {
  value = var.domain_name
}
