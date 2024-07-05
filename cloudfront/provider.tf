terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  backend "s3" {
    region         = "us-east-1"
    bucket         = "tf-state-06072024"
    key            = "cloudfront.tf"
    dynamodb_table = "tf-state-lock"
  }
}

provider "aws" {
  region = "us-east-1"
}