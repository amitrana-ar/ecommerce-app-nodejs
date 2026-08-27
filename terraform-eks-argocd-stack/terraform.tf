terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }       
  }

  backend "s3" {
      bucket = "artechworld-terraform-state"
      key    = "eks/terraform.tfstate"
      region = "ap-south-1"
      use_lockfile = "true"
      encrypt = "true"
  }
}
      
provider "aws" {
    region = "ap-south-1"
}

