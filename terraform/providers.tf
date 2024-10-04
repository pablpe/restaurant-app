terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.70.0"
    }
  }
}

provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    bucket         = "restaurant-app-state-bucket"
    key            = "state/key"
    region         = "eu-north-1"
    dynamodb_table = "restaurant-table"
  }
}

