# ----------------------------------------------------------------------------
# Application Load Balancer, Target Group, and Listener
# Public-facing ALB in public subnets, forwarding HTTP traffic to ECS tasks
# ----------------------------------------------------------------------------

resource "aws_lb" "this" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false # Internet-facing
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id] # Use a dedicated ALB SG (or pass the same as ECS if allowed)
  subnets            = var.public_subnet_ids       # ALB placed in public subnets

  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(var.tags, {
    Name        = "${var.project_name}-${var.environment}-alb"
    Project     = var.project_name
    Environment = var.environment
  })
}

resource "aws_lb_target_group" "this" {
  name        = "${var.project_name}-${var.environment}-tg"
  port        = var.app_port
  protocol    = "HTTP"
  target_type = "ip" # ECS Fargate tasks use IP targets
  vpc_id      = var.vpc_id

  health_check {
    path                = var.health_check_path
    matcher             = "200-399" # Accept 2xx and 3xx as healthy
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
  }

  tags = merge(var.tags, {
    Name        = "${var.project_name}-${var.environment}-tg"
    Project     = var.project_name
    Environment = var.environment
  })
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }

  tags = merge(var.tags, {
    Name        = "${var.project_name}-${var.environment}-listener"
    Project     = var.project_name
    Environment = var.environment
  })
}