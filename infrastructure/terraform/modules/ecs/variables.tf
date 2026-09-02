# ----------------------------------------------------------------------------
# General Project & Environment Variables
# ----------------------------------------------------------------------------

variable "project_name" {
  type        = string
  description = "Name of the project used for resource naming and tagging."
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, staging, prod)."
}

variable "aws_region" {
  type        = string
  description = "AWS Region where the CloudWatch log stream and ECS resources reside."
  default     = "us-east-1"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to all created resources."
  default     = {}
}

# ----------------------------------------------------------------------------
# ECS Task Definition Variables
# ----------------------------------------------------------------------------

variable "cpu" {
  type        = string
  description = "Number of CPU units used by the task (e.g., '256' for 0.25 vCPU, '512' for 0.5 vCPU)."
  default     = "256"
}

variable "memory" {
  type        = string
  description = "Amount of memory (in MiB) used by the task (e.g., '512', '1024')."
  default     = "512"
}

variable "execution_role_arn" {
  type        = string
  description = "ARN of the IAM role that allows ECS to pull ECR images and send CloudWatch logs."
}

variable "task_role_arn" {
  type        = string
  description = "ARN of the IAM role that allows the containerized application to make calls to AWS services."
  default     = null
}

# ----------------------------------------------------------------------------
# Container & Image Variables
# ----------------------------------------------------------------------------

variable "container_name" {
  type        = string
  description = "Name of the container inside the task definition and target group specification."
}

variable "image_repository_url" {
  type        = string
  description = "URL of the ECR repository (e.g., 123456789012.dkr.ecr.us-east-1.amazonaws.com/my-repo)."
}

variable "image_tag" {
  type        = string
  description = "Docker image tag to deploy (e.g., 'latest' or build number)."
  default     = "latest"
}

variable "app_port" {
  type        = number
  description = "Port exposed by the Spring Boot container (e.g., 8080)."
  default     = 8080
}

variable "spring_profile" {
  type        = string
  description = "Active Spring profile passed as an environment variable to the container."
  default     = "prod"
}

# ----------------------------------------------------------------------------
# Logging & Health Check Variables
# ----------------------------------------------------------------------------

variable "log_group_name" {
  type        = string
  description = "Name of the CloudWatch log group"
  default     = "" # Prevents Terraform from requiring it in the root module
}
variable "health_check_path" {
  type        = string
  description = "Health check HTTP path endpoint for wget inside the container."
  default     = "/actuator/health"
}

# ----------------------------------------------------------------------------
# ECS Service & Network Variables
# ----------------------------------------------------------------------------

variable "desired_count" {
  type        = number
  description = "Desired number of running instances of the task."
  default     = 1
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of public subnet IDs where Fargate tasks will run with public IPs."
}

variable "security_group_id" {
  type        = string
  description = "Security group ID assigned to the ECS task network interface."
}

variable "target_group_arn" {
  type        = string
  description = "ARN of the ALB Target Group to attach to the ECS service."
}

variable "log_retention_days" {
  description = "Retention days for CloudWatch logs"
  type        = number
  default     = 7
}


variable "db_host" {
  type        = string
  description = "RDS endpoint used by the Spring Boot application."
}

variable "db_port" {
  type        = number
  description = "RDS MySQL port."
  default     = 3306
}

variable "db_name" {
  type        = string
  description = "RDS database name."
}

variable "db_secret_arn" {
  type        = string
  description = "ARN of the Secrets Manager secret containing database credentials."
}