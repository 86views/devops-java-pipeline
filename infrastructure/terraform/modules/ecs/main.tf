# ----------------------------------------------------------------------------
# ECS Cluster, Task Definition, and Service
# with public subnets and assign_public_ip = true (no NAT required)
# ----------------------------------------------------------------------------

resource "aws_ecs_cluster" "this" {
  name = "${var.project_name}-${var.environment}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(var.tags, {
    Name        = "${var.project_name}-${var.environment}-cluster"
    Project     = var.project_name
    Environment = var.environment
  })
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${var.project_name}-${var.environment}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([{
    name      = var.container_name
    image     = "${var.image_repository_url}:${var.image_tag}"
    essential = true

    portMappings = [{
      containerPort = var.app_port
      hostPort      = var.app_port
      protocol      = "tcp"
    }]

    environment = [
      {
        name  = "SPRING_PROFILES_ACTIVE"
        value = var.spring_profile
      },
      {
        name  = "SERVER_PORT"
        value = tostring(var.app_port)
      },
      {
        name  = "DATABASE"
        value = "mysql"
      },
      {
        name  = "SPRING_DATASOURCE_URL"
        value = "jdbc:mysql://${var.db_host}:${var.db_port}/${var.db_name}"
      },
      {
        name  = "SPRING_DATASOURCE_DRIVER"
        value = "com.mysql.cj.jdbc.Driver"
      }
    ]

    secrets = [
      {
        name      = "DB_USERNAME"
        valueFrom = "${var.db_secret_arn}:username::"
      },
      {
        name      = "DB_PASSWORD"
        valueFrom = "${var.db_secret_arn}:password::"
      }
    ]

    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.this.name
        awslogs-region        = var.aws_region
        awslogs-stream-prefix = "app"
      }
    }

    healthCheck = {
      command     = ["CMD-SHELL", "wget -q -O - http://127.0.0.1:${var.app_port}${var.health_check_path} || exit 1"]
      interval    = 30
      timeout     = 5
      retries     = 3
      startPeriod = 60
    }
  }])

  tags = merge(var.tags, {
    Name        = "${var.project_name}-${var.environment}-td"
    Project     = var.project_name
    Environment = var.environment
  })
}


resource "aws_cloudwatch_log_group" "this" {
  name              = var.log_group_name != "" ? var.log_group_name : "/ecs/${var.project_name}-${var.environment}-app"
  retention_in_days = var.log_retention_days
  tags              = var.tags
}

# ----------------------------------------------------------------------------
# CloudWatch Log Group for ECS
# ----------------------------------------------------------------------------


resource "aws_ecs_service" "this" {
  name                               = "${var.project_name}-${var.environment}-service"
  cluster                            = aws_ecs_cluster.this.id
  task_definition                    = aws_ecs_task_definition.this.arn
  desired_count                      = var.desired_count
  launch_type                        = "FARGATE"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  health_check_grace_period_seconds  = 90

  network_configuration {
    # *** CHANGED: Use PUBLIC subnets (no NAT required) ***
    subnets          = var.public_subnet_ids # <-- now expects public subnet IDs
    security_groups  = [var.security_group_id]
    assign_public_ip = true # <-- tasks get public IPs, internet via IGW
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.app_port
  }

  # (Optional) You can add a lifecycle rule to prevent accidental replacement


  tags = merge(var.tags, {
    Name        = "${var.project_name}-${var.environment}-service"
    Project     = var.project_name
    Environment = var.environment
  })

  # Ensure the task definition and cluster exist before service creation
  depends_on = [
    aws_ecs_cluster.this,
    aws_ecs_task_definition.this
  ]
}