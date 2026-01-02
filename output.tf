output "domain_name" {
  value = var.domain_name
}

output "website_bucket_name" {
  value = module.static_site_cdn.website_bucket_name
}

output "cloudfront_distribution_id" {
  value = module.static_site_cdn.cloudfront_distribution_id
}

output "cloudfront_distribution_arn" {
  value = module.static_site_cdn.cloudfront_distribution_arn
}

output "cloudfront_domain_name" {
  value = module.static_site_cdn.cloudfront_domain_name
}

output "lambda_artifact_bucket" {
  value = module.artifacts.lambda_artifact_bucket_name
}

output "hosted_zone_id" {
  value = module.dns.hosted_zone_id
}

output "domain_full_url" {
  value = var.domain_full_url
}
