variable "aws_region" {
  default = "us-east-1"
}

variable "lambda_role_name" {
  default = "contact-form-lambda-role"
}

variable "lambda_function_name" {
  default = "contact-form-lambda"
}

variable "lambda_code_s3_key" {
  description = "Path to the Lambda ZIP in the artifact bucket (e.g., lambda/contact/<git-sha>.zip)"
  type        = string
}

variable "source_email" {
  description = "Verified SES email address"
  type        = string
}

variable "destination_email" {
  description = "Destination email for contact form"
  type        = string
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