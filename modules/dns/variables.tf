variable "domain_name" {
  description = "Primary domain name"
  type        = string
}

variable "domain_alternative_name" {
  description = "Alternative domain name (www)"
  type        = string
}

variable "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  type        = string
}

variable "cloudfront_zone_id" {
  description = "CloudFront distribution hosted zone ID"
  type        = string
}
