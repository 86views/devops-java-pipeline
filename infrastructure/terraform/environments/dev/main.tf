# ----------------------------------------------------------------------------
# Data source
# ----------------------------------------------------------------------------
data "aws_availability_zones" "available" {
  state = "available"
}

# ----------------------------------------------------------------------------
# Locals
# ----------------------------------------------------------------------------
locals {
  name_prefix = endswith(var.project, "-${var.environment}") ? var.project : "${var.project}-${var.environment}"

  tags = {
    Project     = var.project
    Environment = var.environment
  }
}

# ----------------------------------------------------------------------------
# VPC module
# ----------------------------------------------------------------------------
module "vpc" {
  source = "../../modules/vpc"

  project_name        = var.project
  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  azs                 = data.aws_availability_zones.available.names
  tags                = local.tags
}

# ----------------------------------------------------------------------------
# Security Groups module
# ----------------------------------------------------------------------------
module "security_groups" {
  source = "../../modules/security-groups"

  project_name      = var.project
  environment       = var.environment
  vpc_id            = module.vpc.vpc_id
  container_port    = var.app_port
  alb_ingress_cidrs = var.alb_ingress_cidrs
  enable_https      = var.enable_https
  tags              = local.tags
}


# ----------------------------------------------------------------------------
# ALB module
# ----------------------------------------------------------------------------
module "alb" {
  source = "../../modules/alb"

  project_name               = var.project
  environment                = var.environment
  vpc_id                     = module.vpc.vpc_id
  public_subnet_ids          = module.vpc.public_subnet_ids
  alb_security_group_id      = module.security_groups.alb_security_group_id
  app_port                   = var.app_port
  health_check_path          = var.health_check_path
  enable_deletion_protection = var.enable_deletion_protection
  tags                       = local.tags
}

# ----------------------------------------------------------------------------
# ECR module
# ----------------------------------------------------------------------------
module "ecr" {
  source = "../../modules/ecr"

  repository_name      = "${var.project}-${var.environment}"
  image_tag_mutability = "MUTABLE"
  scan_on_push         = true
  max_image_count      = 5

  tags = local.tags
}

# ----------------------------------------------------------------------------
# RDS module
# ----------------------------------------------------------------------------
module "rds" {
  source = "../../modules/rds"

  project_name            = var.project
  environment             = var.environment
  public_subnet_ids       = module.vpc.public_subnet_ids
  security_group_id       = module.security_groups.rds_security_group_id
  db_name                 = var.db_name
  username                = var.db_username
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_allocated_storage
  max_allocated_storage   = var.db_max_allocated_storage
  multi_az                = var.db_multi_az
  backup_retention_period = var.db_backup_retention_period
  skip_final_snapshot     = var.db_skip_final_snapshot
  deletion_protection     = var.db_deletion_protection
  tags                    = local.tags
}

# ----------------------------------------------------------------------------
# IAM module
# ----------------------------------------------------------------------------
module "iam" {
  source = "../../modules/iam"

  name_prefix   = local.name_prefix
  tags          = local.tags
  db_secret_arn = module.rds.db_secret_arn

  extra_task_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  ]

  extra_execution_policy_arns = []
}

# ----------------------------------------------------------------------------
# ECS module
# ----------------------------------------------------------------------------
# ----------------------------------------------------------------------------
# ECS module
# ----------------------------------------------------------------------------
module "ecs" {
  source = "../../modules/ecs"

  project_name         = var.project
  environment          = var.environment
  public_subnet_ids    = module.vpc.public_subnet_ids
  security_group_id    = module.security_groups.ecs_security_group_id
  target_group_arn     = module.alb.target_group_arn
  container_name       = var.container_name
  app_port             = var.app_port
  health_check_path    = var.health_check_path
  cpu                  = var.ecs_cpu
  memory               = var.ecs_memory
  desired_count        = var.ecs_desired_count
  image_repository_url = module.ecr.repository_url
  image_tag            = var.image_tag
  spring_profile       = var.spring_profile
  execution_role_arn   = module.iam.execution_role_arn
  task_role_arn        = module.iam.task_role_arn

  db_host       = module.rds.db_instance_address
  db_port       = module.rds.db_instance_port
  db_name       = module.rds.db_instance_name
  db_secret_arn = module.rds.db_secret_arn

  aws_region = var.aws_region
  tags       = local.tags
}

# ----------------------------------------------------------------------------
# Monitoring module (CloudWatch Dashboard)
# ----------------------------------------------------------------------------
module "monitoring" {
  source = "../../modules/monitoring"

  aws_region              = var.aws_region
  dashboard_name          = "${local.name_prefix}-dashboard"
  ecs_cluster_name        = module.ecs.cluster_name
  ecs_service_name        = module.ecs.service_name
  alb_arn_suffix          = module.alb.lb_arn_suffix
  target_group_arn_suffix = module.alb.target_group_arn_suffix

}