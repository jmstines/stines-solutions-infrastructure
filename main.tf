terraform {
  backend "s3" {
    bucket         = "stines-solutions-state-bucket"
    key            = "infrastructure/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

data "aws_caller_identity" "current" {}

# ===== Artifacts Module (Lambda artifacts S3 bucket) =====
module "artifacts" {
  source = "./modules/artifacts"
}

# ===== Static Site CDN Module (Website S3 + CloudFront) =====
module "static_site_cdn" {
  source = "./modules/static_stite_cdn"
  
  domain_name               = var.domain_name
  domain_alternative_name   = var.domain_alternative_name
  certificate_arn           = module.dns.certificate_arn
}

# ===== DNS Module (Route53 + ACM Certificate) =====
module "dns" {
  source = "./modules/dns"
  
  providers = {
    aws = aws.us_east_1
  }
  
  domain_name             = var.domain_name
  domain_alternative_name = var.domain_alternative_name
  cloudfront_domain_name  = module.static_site_cdn.cloudfront_domain_name
  cloudfront_zone_id      = module.static_site_cdn.cloudfront_zone_id
}

# API Gateway is managed in the backend repository since it's tightly coupled with Lambda functions
