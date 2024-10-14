# AWS region where resources will be created
variable "region" {
  description = "The AWS region where resources will be created"
  default     = ""
}

# List of subnet IDs for the RDS DB subnet group
variable "subnet_ids" {
  description = "List of subnet IDs for the RDS DB subnet group"
  type        = list(string)
  default     = []
}

# Password length for the generated random password
variable "password_length" {
  description = "The length of the generated password"
  default     = 16
}

# Include special characters in the generated password
variable "password_special" {
  description = "Include special characters in the password"
  default     = true
}

# Allowed special characters in the generated password
variable "password_override_special" {
  description = "Allowed special characters in the password"
  default     = "_-!"
}

# Name of the DB subnet group
variable "db_subnet_group_name" {
  description = "Name of the DB subnet group"
  default     = "sonarqube-db-subnet-group"
}

# Identifier for the RDS instance
variable "db_instance_identifier" {
  description = "The identifier for the RDS instance"
  default     = "sonarqube-db"
}

# Instance class for the RDS instance
variable "db_instance_class" {
  description = "The class of the RDS instance"
  default     = "db.t3.micro"
}

# Database engine to be used for the RDS instance
variable "db_engine" {
  description = "The database engine for the RDS instance"
  default     = "postgres"
}

# Database engine version for the RDS instance
variable "db_engine_version" {
  description = "The version of the database engine"
  default     = "16.3"
}

# Allocated storage (in GB) for the RDS instance
variable "db_allocated_storage" {
  description = "The allocated storage for the RDS instance (in GB)"
  default     = 5
}

# Database name
variable "db_name" {
  description = "The name of the database"
  default     = "sonarqube"
}

# Username for the database
variable "db_username" {
  description = "The username for the database"
  default     = "sonar"
}

# Whether the database should be publicly accessible
variable "db_publicly_accessible" {
  description = "Indicates if the database should be publicly accessible"
  default     = false
}

# Whether to skip the final snapshot when deleting the database
variable "db_skip_final_snapshot" {
  description = "Whether to skip the final snapshot when deleting the database"
  default     = true
}

# Tag name for the RDS instance
variable "db_instance_tag_name" {
  description = "Tag name for the RDS instance"
  default     = "sonarqube-db"
}

# Name of the SSM parameter to store the database password
variable "ssm_parameter_name" {
  description = "The name of the SSM parameter to store the database password"
  default     = "/rds/sonarqube/password"
}
