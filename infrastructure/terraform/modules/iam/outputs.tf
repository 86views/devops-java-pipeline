# ----------------------------------------------------------------------------
# IAM Outputs
# ----------------------------------------------------------------------------

output "execution_role_arn" {
  description = "ARN of the ECS task execution role"
  value       = aws_iam_role.execution.arn
}

output "execution_role_name" {
  description = "Name of the ECS task execution role"
  value       = aws_iam_role.execution.name
}

output "task_role_arn" {
  description = "ARN of the ECS task role"
  value       = aws_iam_role.task.arn
}

output "task_role_name" {
  description = "Name of the ECS task role"
  value       = aws_iam_role.task.name
}

output "secrets_policy_arn" {
  description = "ARN of the Secrets Manager policy attached to the ECS execution role"
  value       = aws_iam_policy.secrets_access.arn
}

output "secrets_policy_name" {
  description = "Name of the Secrets Manager policy"
  value       = aws_iam_policy.secrets_access.name
}