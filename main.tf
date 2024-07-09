# Providers
provider "aws" {
  region = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 1.4"
    }
  }
}

# Backend configuration
terraform {
  backend "s3" {
    bucket  = "ldall-tf-backend"
    key     = "resume/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

# Local variables
locals {
  tags = {
    Owner       = "ldall"
    Environment = "Development"
    Creator     = "Terraform"
    Service     = "Resume"
  }
}

# ACM Certificate for the distribution
module "acm_request_certificate" {
  source = "cloudposse/acm-request-certificate/aws"

  version = "v0.18.0"

  domain_name                       = "lucasdallocchio.com"
  process_domain_validation_options = true
  ttl                               = "300"

  tags = local.tags
}

# CloudFront distribution and s3 bucket
module "cdn" {
  source  = "cloudposse/cloudfront-s3-cdn/aws"
  version = "v0.95.0"

  name              = "lucasdall-resume"
  aliases           = ["lucasdallocchio.com"]
  dns_alias_enabled = true
  parent_zone_name  = "lucasdallocchio.com"

  cloudfront_access_log_create_bucket = false
  cloudfront_access_logging_enabled   = false
  s3_access_logging_enabled           = false

  acm_certificate_arn = module.acm_request_certificate.arn

  tags = local.tags

  depends_on = [module.acm_request_certificate]
}

# Outputs
output "bucket_name" {
  value = module.cdn.s3_bucket
}

output "distribution_id" {
  value = module.cdn.cf_id

}
