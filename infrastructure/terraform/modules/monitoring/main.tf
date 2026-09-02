# Single CloudWatch dashboard pulling together ECS and ALB metrics.
# Purely observability — the free tier includes 3 dashboards/month at no cost.

locals {
  ecs_widget = var.ecs_cluster_name != null ? [{
    type   = "metric"
    x      = 0
    y      = 0
    width  = 12
    height = 6
    properties = {
      title  = "ECS Service — CPU & Memory"
      view   = "timeSeries"
      region = var.aws_region
      metrics = [
        ["AWS/ECS", "CPUUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", var.ecs_service_name],
        ["AWS/ECS", "MemoryUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", var.ecs_service_name]
      ]
      period = 300
      stat   = "Average"
    }
  }] : []

  alb_widget = var.alb_arn_suffix != null ? [{
    type   = "metric"
    x      = 12
    y      = 0
    width  = 12
    height = 6
    properties = {
      title  = "ALB — Requests & Target Health"
      view   = "timeSeries"
      region = var.aws_region
      metrics = [
        ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", var.alb_arn_suffix],
        ["AWS/ApplicationELB", "HealthyHostCount", "TargetGroup", var.target_group_arn_suffix, "LoadBalancer", var.alb_arn_suffix],
        ["AWS/ApplicationELB", "UnHealthyHostCount", "TargetGroup", var.target_group_arn_suffix, "LoadBalancer", var.alb_arn_suffix]
      ]
      period = 300
      stat   = "Sum"
    }
  }] : []

  # Lambda and Billing widgets removed — only ECS and ALB remain.

  all_widgets = concat(local.ecs_widget, local.alb_widget)
}

resource "aws_cloudwatch_dashboard" "this" {
  dashboard_name = var.dashboard_name
  dashboard_body = jsonencode({
    widgets = local.all_widgets
  })
}