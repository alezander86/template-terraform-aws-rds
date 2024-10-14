# Generate a random password for the database
resource "random_password" "db_password" {
  length           = var.password_length           # Password length
  special          = var.password_special          # Include special characters
  override_special = var.password_override_special # Allowed special characters
}

# Generate a random key for tagging
resource "random_string" "simple_key" {
  length  = 12    # Length of the random key
  upper   = true  # Use uppercase letters
  lower   = true  # Use lowercase letters
  numeric = true  # Use numbers
  special = false # Do not use special characters
}

# Generate a KMS key to be used for encryption
resource "aws_kms_key" "rds_kms_key" {
  description             = "KMS key for RDS and SSM encryption"
  deletion_window_in_days = 30 # Window for deletion of the key, if ever needed

  # Enable automatic yearly key rotation
  enable_key_rotation = true
}

locals {
  # Required values
  subnet_ids = var.subnet_ids

  # Optional tags
  tags = {
    "SysName"   = "EPAM"
    "Project"   = "KubeRocketCI"
    "SimpleKey" = random_string.simple_key.result # Use the generated random key for tagging
  }
}

# Create a subnet group for RDS using existing subnets
resource "aws_db_subnet_group" "db_subnet_group" {
  name       = var.db_subnet_group_name
  subnet_ids = local.subnet_ids

  tags = {
    Name      = var.db_subnet_group_name
    SysName   = local.tags["SysName"]
    Project   = local.tags["Project"]
    SimpleKey = local.tags["SimpleKey"] # Use the generated random key for tagging
  }
}

# Create the RDS instance using the generated password
resource "aws_db_instance" "database_instance" {
  identifier           = var.db_instance_identifier               # Unique identifier for the RDS instance
  instance_class       = var.db_instance_class                    # Instance class (size)
  engine               = var.db_engine                            # Database engine (e.g., PostgreSQL)
  engine_version       = var.db_engine_version                    # Database engine version
  allocated_storage    = var.db_allocated_storage                 # Allocated storage (in GB)
  db_name              = var.db_name                              # Database name
  username             = var.db_username                          # Database username
  password             = random_password.db_password.result       # Use the generated password
  publicly_accessible  = var.db_publicly_accessible               # Should not be publicly accessible
  skip_final_snapshot  = var.db_skip_final_snapshot               # Skip the final snapshot on deletion
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name # Use the created DB Subnet Group

  # Enable automatic minor version upgrades
  auto_minor_version_upgrade = true

  # Enable enhanced monitoring
  monitoring_interval = 60 # Monitoring interval in seconds (between 1 and 60)

  # Additional configurations for compliance and security
  performance_insights_enabled    = true                        # Enable performance insights
  performance_insights_kms_key_id = aws_kms_key.rds_kms_key.arn # Use the generated KMS key for encryption
  deletion_protection             = true                        # Prevent accidental deletion of the database
  multi_az                        = true                        # Enable Multi-AZ for high availability
  enabled_cloudwatch_logs_exports = ["postgresql"]              # Enable logging for PostgreSQL to CloudWatch

  # Enable storage encryption for the RDS instance
  storage_encrypted = true

  # Set the backup retention period in days
  backup_retention_period = 7

  # Enable IAM database authentication
  iam_database_authentication_enabled = true

  # Tags for the RDS instance
  tags = {
    Name = var.db_instance_tag_name
  }
}

# Store the database password in AWS SSM Parameter Store as a SecureString
resource "aws_ssm_parameter" "db_password" {
  name  = var.ssm_parameter_name
  type  = "SecureString"
  value = random_password.db_password.result

  # Use the generated KMS key for encryption
  key_id = aws_kms_key.rds_kms_key.arn
}
