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

output "api_gateway_url" {
  value = module.api.api_base_url
}

output "api_routes" {
  value = module.api.api_routes
}

output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}

output "lambda_function_arn" {
  value = aws_lambda_function.contact_lambda.arn
}

output "lambda_artifact_bucket" {
  value = module.artifacts.lambda_artifact_bucket_name
}

output "hosted_zone_id" {
  value = module.dns.hosted_zone_id
}
