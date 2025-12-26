output "website_bucket_name" {
  value = aws_s3_bucket.website.bucket
}

output "cloudfront_distribution_id" {
  value = aws_cloudfront_distribution.website_cdn.id
}

output "cloudfront_distribution_arn" {
  value = aws_cloudfront_distribution.website_cdn.arn
}

output "cloudfront_domain_name" {
  value = aws_cloudfront_distribution.website_cdn.domain_name
}

output "cloudfront_zone_id" {
  value = aws_cloudfront_distribution.website_cdn.hosted_zone_id
}
