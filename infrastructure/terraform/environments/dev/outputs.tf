output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "alb_dns_name" {
  value = module.alb.lb_dns_name
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "ecs_service_name" {
  value = module.ecs.service_name
}

output "rds_endpoint" {
  value     = module.rds.db_instance_address
  sensitive = true
}

output "rds_secret_arn" {
  value     = module.rds.db_secret_arn
  sensitive = true
}

output "dashboard_name" {
  value = module.monitoring.dashboard_name
}

output "ecr_repository_url" {
  description = "ECR repository URL used by ECS and Jenkins."
  value       = module.ecr.repository_url
}