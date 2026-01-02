variable "lambda_function_arn" {
  description = "ARN of the Lambda function to integrate with API Gateway"
  type        = string
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  type        = string
}
variable "login_lambda_function_name" {
  description = "Name of the login Lambda function"
  type        = string
}

variable "verify_lambda_function_name" {
  description = "Name of the verify Lambda function"
  type        = string
}

variable "logout_lambda_function_name" {
  description = "Name of the logout Lambda function"
  type        = string
}
variable "domain_full_url" {
  description = "Full domain URL for CORS configuration"
  type        = string
}

variable "domain_name" {
  description = "Base domain name for API custom domain"
  type        = string
}

variable "route53_zone_id" {
  description = "Route53 hosted zone ID for DNS records"
  type        = string
}
