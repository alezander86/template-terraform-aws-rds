provider "aws" {
  region = var.region
}

terraform {

  required_version = "= 1.5.7"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.17.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  # backend "s3" {
  #   bucket         = "terraform-states-<ACCOUNT_ID>"
  #   key            = "<REGION>/<CLUSTER_NAME>/iam/terraform.tfstate"
  #   region         = "<REGION>"
  #   acl            = "bucket-owner-full-control"
  #   dynamodb_table = "terraform_locks"
  #   encrypt        = true
  # }

}
