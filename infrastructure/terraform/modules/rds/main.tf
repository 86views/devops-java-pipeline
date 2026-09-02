# ----------------------------------------------------------------------------
# RDS with password stored in AWS Secrets Manager
# ----------------------------------------------------------------------------

# Generate a secure random password (optional – you can also set manually)
resource "random_password" "db_password" {
  length  = 16
  special = false
}

# Create the secret in Secrets Manager
resource "aws_secretsmanager_secret" "db_credentials" {
  name        = "${var.project_name}-${var.environment}-db-credentials"
  description = "Credentials for RDS MySQL database"

  tags = merge(var.tags, {
    Name        = "${var.project_name}-${var.environment}-db-secret"
    Project     = var.project_name
    Environment = var.environment
  })
}

# Store username and password as a JSON object
resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.username
    password = random_password.db_password.result
    dbname   = var.db_name

    # Instead, store only username/password for retrieval by apps.
  })
}

# DB subnet group using public subnets
resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-${var.environment}-db-subnets"
  subnet_ids = var.public_subnet_ids

  tags = merge(var.tags, {
    Name        = "${var.project_name}-${var.environment}-db-subnets"
    Project     = var.project_name
    Environment = var.environment
  })
}

# RDS instance – password taken from the secret
resource "aws_db_instance" "this" {
  identifier = "${var.project_name}-${var.environment}-mysql"

  engine         = "mysql"
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = var.db_name
  username = var.username
  password = random_password.db_password.result # Use the same generated password

  port = 3306

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [var.security_group_id]

  publicly_accessible        = false
  multi_az                   = var.multi_az
  backup_retention_period    = var.backup_retention_period
  skip_final_snapshot        = var.skip_final_snapshot
  deletion_protection        = var.deletion_protection
  auto_minor_version_upgrade = true

  tags = merge(var.tags, {
    Name        = "${var.project_name}-${var.environment}-mysql"
    Project     = var.project_name
    Environment = var.environment
  })
}

# (Optional) After RDS creation, update the secret with the host address.
# Since we can't have a circular dependency, we can use a null_resource or a second secret version.
# Usually applications retrieve the host from the RDS output, not from the secret.
# So we omit host from the secret.