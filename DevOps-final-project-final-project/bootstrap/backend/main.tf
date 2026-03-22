terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.50"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "backend" {
  source              = "../../modules/s3-backend"
  bucket_name         = "${var.project_name}-tfstate-${data.aws_caller_identity.current.account_id}"
  dynamodb_table_name = "${var.project_name}-tf-lock"
  tags                = var.tags
}

data "aws_caller_identity" "current" {}

output "bucket_name" {
  value = module.backend.bucket_name
}

output "dynamodb_table_name" {
  value = module.backend.dynamodb_table_name
}
