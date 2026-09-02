# ----------------------------------------------------------------------------
# Security Group variables
# ----------------------------------------------------------------------------

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "ID of the VPC where security groups are created"
  type        = string
}

# ALB security group variables
variable "alb_ingress_cidrs" {
  description = "List of CIDR blocks allowed to access the ALB (e.g., ['0.0.0.0/0'] for public)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "enable_https" {
  description = "Enable HTTPS (port 443) inbound rule on ALB"
  type        = bool
  default     = false
}

# ECS tasks security group variables
variable "container_port" {
  description = "Port on which the container listens (used for ingress from ALB)"
  type        = number
}