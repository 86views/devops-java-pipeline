variable "name_prefix" {
  description = "Prefix used for naming all resources (e.g., 'myapp-dev')"
  type        = string
}

variable "tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default     = {}
}

variable "db_secret_arn" {
  description = "ARN of the Secrets Manager secret containing DB credentials. If null, the secrets policy will be empty."
  type        = string
  default     = null
}

variable "extra_execution_policy_arns" {
  description = "List of additional managed policy ARNs to attach to the ECS execution role"
  type        = list(string)
  default     = []
}

variable "extra_task_policy_arns" {
  description = "List of additional managed policy ARNs to attach to the ECS task role"
  type        = list(string)
  default     = []
}