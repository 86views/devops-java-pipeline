
# ----------------------------------------------------------------------------
# ECS Tasks Trust Policy
# ----------------------------------------------------------------------------

data "aws_iam_policy_document" "ecs_assume" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# ----------------------------------------------------------------------------
# ECS Task Execution Role
#
# Used by the ECS/Fargate agent for:
# - Pulling container images from Amazon ECR
# - Sending container logs to CloudWatch Logs
# - Retrieving secrets referenced by the ECS task definition
# ----------------------------------------------------------------------------

resource "aws_iam_role" "execution" {
  name               = "${var.name_prefix}-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume.json

  tags = var.tags
}

# Standard AWS-managed ECS execution policy.
#
# Provides the standard permissions required by Fargate to:
# - Authenticate to ECR
# - Pull images from ECR
# - Write logs to CloudWatch Logs
resource "aws_iam_role_policy_attachment" "execution" {
  role       = aws_iam_role.execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Optional additional execution-role policies.
resource "aws_iam_role_policy_attachment" "execution_extra" {
  for_each = toset(var.extra_execution_policy_arns)

  role       = aws_iam_role.execution.name
  policy_arn = each.value
}

# ----------------------------------------------------------------------------
# Secrets Manager Policy for ECS Task Execution Role
#
# ECS uses the execution role to retrieve secrets referenced by:
#
# secrets = [
#   {
#     name      = "DB_USERNAME"
#     valueFrom = "${var.db_secret_arn}:username::"
#   },
#   {
#     name      = "DB_PASSWORD"
#     valueFrom = "${var.db_secret_arn}:password::"
#   }
# ]
# ----------------------------------------------------------------------------

resource "aws_iam_policy" "secrets_access" {
  name        = "${var.name_prefix}-secrets-access"
  description = "Allow ECS task execution role to read RDS credentials from Secrets Manager"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = var.db_secret_arn != null ? [
      {
        Effect = "Allow"

        Action = [
          "secretsmanager:GetSecretValue"
        ]

        Resource = [
          var.db_secret_arn
        ]
      }
    ] : []
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "execution_secrets" {
  role       = aws_iam_role.execution.name
  policy_arn = aws_iam_policy.secrets_access.arn
}

# ----------------------------------------------------------------------------
# ECS Task Role
#
# Used by the application running inside the container when it needs
# to call AWS services.
# ----------------------------------------------------------------------------

resource "aws_iam_role" "task" {
  name               = "${var.name_prefix}-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume.json

  tags = var.tags
}

# Optional additional application/task-role policies.
#
# These are intentionally separate from the ECS execution role.
resource "aws_iam_role_policy_attachment" "task_extra" {
  for_each = toset(var.extra_task_policy_arns)

  role       = aws_iam_role.task.name
  policy_arn = each.value
}

