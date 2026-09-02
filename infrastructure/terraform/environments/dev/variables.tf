# ----------------------------------------------------------------------------
# Core variables
# ----------------------------------------------------------------------------

variable "aws_region" {
  description = "AWS region where resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Project name (without environment suffix). Used for naming and tagging."
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod). Used for naming and tagging."
  type        = string
}

variable "tags" {
  description = "Additional tags to apply to all resources (will be merged with project/environment tags)"
  type        = map(string)
  default     = {}
}

# ----------------------------------------------------------------------------
# VPC variables
# ----------------------------------------------------------------------------

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets (one per AZ)"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# ----------------------------------------------------------------------------
# ALB variables
# ----------------------------------------------------------------------------

variable "alb_ingress_cidrs" {
  description = "List of CIDR blocks allowed to access the ALB (e.g., ['0.0.0.0/0'] for public access)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_https" {
  description = "Enable HTTPS (port 443) listener on the ALB (requires ACM certificate)"
  type        = bool
  default     = false
}

variable "app_port" {
  description = "Port on which the application container listens"
  type        = number
  default     = 8080
}

variable "health_check_path" {
  description = "Path for health checks (e.g., /actuator/health for Spring Boot, / for simple)"
  type        = string
  default     = "/actuator/health"
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection on the ALB"
  type        = bool
  default     = false
}

# ----------------------------------------------------------------------------
# ECS variables
# ----------------------------------------------------------------------------

variable "container_name" {
  description = "Name of the container in the ECS task definition"
  type        = string
  default     = "app"
}

variable "ecs_cpu" {
  description = "CPU units for the ECS task (e.g., 256, 512). Free tier: 256 is fine."
  type        = string
  default     = "256"
}

variable "ecs_memory" {
  description = "Memory (MiB) for the ECS task (e.g., 512, 1024). Free tier: 512 is fine."
  type        = string
  default     = "512"
}

variable "ecs_desired_count" {
  description = "Desired number of ECS tasks running"
  type        = number
  default     = 1
}



variable "image_tag" {
  description = "Image tag to deploy (e.g., latest, v1.0.0)"
  type        = string
  default     = "latest"
}

variable "spring_profile" {
  description = "Spring profile to activate (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

# ----------------------------------------------------------------------------
# RDS variables
# ----------------------------------------------------------------------------

variable "db_name" {
  description = "Name of the database to create"
  type        = string
}

variable "db_username" {
  description = "Master username for the database"
  type        = string
  sensitive   = true
}

variable "db_engine_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  description = "RDS instance class (free tier: db.t4g.micro or db.t2.micro)"
  type        = string
  default     = "db.t4g.micro"
}

variable "db_allocated_storage" {
  description = "Initial storage size in GB"
  type        = number
  default     = 20
}

variable "db_max_allocated_storage" {
  description = "Maximum storage size in GB for autoscaling (0 disables)."
  type        = number
  default     = 100
}

variable "db_multi_az" {
  description = "Enable Multi-AZ deployment (not recommended for free tier)"
  type        = bool
  default     = false
}

variable "db_backup_retention_period" {
  description = "Number of days to retain backups (0 disables)"
  type        = number
  default     = 7
}

variable "db_skip_final_snapshot" {
  description = "Skip final snapshot when destroying the DB (set false to protect data)"
  type        = bool
  default     = true
}

variable "db_deletion_protection" {
  description = "Enable deletion protection to prevent accidental deletion"
  type        = bool
  default     = false
}