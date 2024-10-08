# Purpose: This file is used to define the required providers for the terraform configuration
terraform {

  # Define the required version of Terraform that will be used by this project
  required_providers {

    # Define the required provider for AWS
    aws = {
      source  = "hashicorp/aws" # Source for the AWS provider
      version = "~> 5.0"        # Version of the AWS provider
    }
  }

  backend "s3" {
    bucket         = "terraform-module-project-bucket"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-module-project-table"
  }
}
