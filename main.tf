# Providers
provider "aws" {
  region = "us-west-1"
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

# Data sources
data "aws_caller_identity" "current" {}
data "aws_canonical_user_id" "current" {}

# AWS S3 Bucket for hosting the website
module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.2"

  bucket = "lucas-dall-resume-bucket"

  # Bucket policies
  attach_deny_insecure_transport_policy    = true
  attach_require_latest_tls_policy         = true
  attach_deny_incorrect_encryption_headers = true

  # S3 Bucket Ownership Controls
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls
  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"

  expected_bucket_owner = data.aws_caller_identity.current.account_id

  acl = "private"

  versioning = {
    status     = true
    mfa_delete = false
  }

  website = {
    index_document = "index.html"
    error_document = "error.html"
  }

  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        kms_master_key_id = "aws/s3"
        sse_algorithm     = "AES256"
      }
    }
  }

  tags = {
    Owner       = "ldall"
    Environment = "Development"
    Creatior    = "Terraform"
  }
}
