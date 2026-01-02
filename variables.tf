variable "aws_region" {
  default = "us-east-1"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function (managed by backend project)"
  default     = "contact-form-lambda"
}

variable "login_lambda_function_name" {
  description = "Name of the login Lambda function"
  default     = "auth-login-lambda"
}

variable "verify_lambda_function_name" {
  description = "Name of the verify Lambda function"
  default     = "auth-verify-lambda"
}

variable "logout_lambda_function_name" {
  description = "Name of the logout Lambda function"
  default     = "auth-logout-lambda"
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