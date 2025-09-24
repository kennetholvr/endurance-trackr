terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.region
  profile = "personal"

  default_tags {
    tags = {
      Project = "FitnessForm"
      Env     = var.env
      Owner   = "Ken"
    }
  }
}