provider "aws" {
  region = "ap-southeast-2"
}

locals {
  prefix = "${var.prefix}-${terraform.workspace}"
  common_tags = {
    Environment = terraform.workspace
    Project     = var.project
    ManagedBy   = "Terraform"
  }
}

data "aws_region" "current" {}