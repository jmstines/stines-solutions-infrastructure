variable "domain_name" {
  description = "Primary domain name"
  type        = string
}

variable "domain_alternative_name" {
  description = "Alternative domain name (www)"
  type        = string
}

variable "certificate_arn" {
  description = "ACM certificate ARN for the domain"
  type        = string
}
