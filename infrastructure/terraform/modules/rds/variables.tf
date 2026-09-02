# ----------------------------------------------------------------------------
# RDS Database variables
# ----------------------------------------------------------------------------

variable "project_name" {
  description = "Project name used for resource naming and tagging"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "engine_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0"
}

variable "instance_class" {
  description = "RDS instance class (e.g., db.t4g.micro for free tier)"
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "Initial storage size in GB"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum storage size in GB (for storage autoscaling). Set to 0 to disable."
  type        = number
  default     = 100
}

variable "db_name" {
  description = "The name of the database to create"
  type        = string
}

variable "username" {
  description = "Master username for the database"
  type        = string
  sensitive   = true
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the DB subnet group"
  type        = list(string)
}

# password variable REMOVED – now stored in Secrets Manager

variable "security_group_id" {
  description = "Security group ID to attach to the RDS instance (controls inbound traffic)"
  type        = string
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment (not recommended for free tier)"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Number of days to retain backups (0 disables backups)"
  type        = number
  default     = 7
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot when destroying the DB (set false to protect data)"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Enable deletion protection to prevent accidental deletion"
  type        = bool
  default     = false
}