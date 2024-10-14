provider "aws" {
  region = var.region  # AWS region where resources will be created
}

# Generate a random password for the database
resource "random_password" "db_password" {
  length           = var.password_length           # Password length
  special          = var.password_special          # Include special characters
  override_special = var.password_override_special # Allowed special characters
}

# Create a subnet group for RDS using existing subnets
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.db_subnet_group_name
  subnet_ids = var.subnet_ids

  tags = {
    Name = var.db_subnet_group_name
  }
}

# Create the RDS instance using the generated password
resource "aws_db_instance" "database_instance" {
  identifier              = var.db_instance_identifier # Unique identifier for the RDS instance
  instance_class          = var.db_instance_class      # Instance class
  engine                  = var.db_engine              # Database engine (PostgreSQL)
  engine_version          = var.db_engine_version      # Database engine version
  allocated_storage       = var.db_allocated_storage   # Allocated storage (in GB)
  db_name                 = var.db_name                # Database name
  username                = var.db_username            # Database username
  password                = random_password.db_password.result  # Use the generated password
  publicly_accessible     = var.db_publicly_accessible # Database will not be publicly accessible
  skip_final_snapshot     = var.db_skip_final_snapshot # Skip the final snapshot on deletion
  db_subnet_group_name    = aws_db_subnet_group.db_subnet_group.name  # Use the created DB Subnet Group

  tags = {
    Name = var.db_instance_tag_name  # Tag for the RDS instance
  }
}

# Store the database password in AWS SSM Parameter Store as a SecureString
resource "aws_ssm_parameter" "db_password" {
  name  = var.ssm_parameter_name
  type  = "SecureString"
  value = random_password.db_password.result
}

# terraform {
#   backend "s3" {
#     bucket         = "" # Name of the S3 bucket for storing the remote state
#     key            = "" # Path inside the S3 bucket where the state file is stored
#     region         = "" # AWS region where the S3 bucket is located
#     acl            = "" # ACL for S3 bucket access control
#     dynamodb_table = "" # Name of the DynamoDB table for locking
#   }
# }
