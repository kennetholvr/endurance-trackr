terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
  profile = "personal"
}

resource "aws_s3_bucket" "sandbox" {
  bucket = "endurance-kenneth-sandbox-001" # must be globally unique!
}
