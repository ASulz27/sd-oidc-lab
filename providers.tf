terraform {
  required_version = ">= 1.7.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

variable "lab" {
  type = string
}

provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Project   = "aws-oidc-lab"
      Lab       = var.lab
      ManagedBy = "terraform"
    }

  }

}  