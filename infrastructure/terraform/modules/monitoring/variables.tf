# ----------------------------------------------------------------------------
# CloudWatch Dashboard variables
# ----------------------------------------------------------------------------

variable "aws_region" {
  description = "AWS region where the dashboard will be created and metrics sourced"
  type        = string
  default     = "us-east-1"
}

variable "dashboard_name" {
  description = "Name of the CloudWatch dashboard"
  type        = string
}

# ECS metrics – optional; if not provided, the ECS widget is omitted
variable "ecs_cluster_name" {
  description = "Name of the ECS cluster (used for the ECS widget). Set to null to skip."
  type        = string
  default     = null
}

variable "ecs_service_name" {
  description = "Name of the ECS service (used for the ECS widget). Required if ecs_cluster_name is set."
  type        = string
  default     = null
}

# ALB metrics – optional; if not provided, the ALB widget is omitted
variable "alb_arn_suffix" {
  description = "ARN suffix of the Application Load Balancer (e.g., app/name/...). Set to null to skip."
  type        = string
  default     = null
}

variable "target_group_arn_suffix" {
  description = "ARN suffix of the target group associated with the ALB. Required if alb_arn_suffix is set."
  type        = string
  default     = null
}