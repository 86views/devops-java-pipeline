# ----------------------------------------------------------------------------
# Cluster Outputs
# ----------------------------------------------------------------------------

output "cluster_id" {
  value       = aws_ecs_cluster.this.id
  description = "The Amazon Resource Name (ARN) that identifies the cluster."
}

output "cluster_name" {
  value       = aws_ecs_cluster.this.name
  description = "The name of the ECS cluster."
}

output "cluster_arn" {
  value       = aws_ecs_cluster.this.arn
  description = "The ARN of the ECS cluster."
}

# ----------------------------------------------------------------------------
# Task Definition Outputs
# ----------------------------------------------------------------------------

output "task_definition_arn" {
  value       = aws_ecs_task_definition.this.arn
  description = "Full ARN of the Task Definition including revision number."
}

output "task_definition_family" {
  value       = aws_ecs_task_definition.this.family
  description = "The unique name/family of the Task Definition."
}

# ----------------------------------------------------------------------------
# Service Outputs
# ----------------------------------------------------------------------------

output "service_id" {
  value       = aws_ecs_service.this.id
  description = "The Amazon Resource Name (ARN) that identifies the service."
}

output "service_name" {
  value       = aws_ecs_service.this.name
  description = "The name of the ECS service."
}

output "log_group_name" {
  description = "Name of the CloudWatch Log Group created by ECS module"
  value       = aws_cloudwatch_log_group.this.name
}

output "log_group_arn" {
  description = "ARN of the CloudWatch Log Group created by ECS module"
  value       = aws_cloudwatch_log_group.this.arn

}