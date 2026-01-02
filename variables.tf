variable "aws_region" {
  default = "us-east-1"
}

variable "domain_full_url" {
  description = "Domain name for API Gateway custom domain"
  default     = "https://www.stinessolutions.com"
}

variable "domain_name" {
  description = "Domain name for API Gateway custom domain"
  default     = "stinessolutions.com"
}

variable "domain_alternative_name" {
  description = "Alternative domain name for API Gateway custom domain"
  default     = "www.stinessolutions.com"
}