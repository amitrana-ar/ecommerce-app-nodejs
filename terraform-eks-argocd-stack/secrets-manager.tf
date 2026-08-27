resource "aws_secretsmanager_secret" "rds_secret" {
  name = "${local.env}-${local.name}-secret"
  description = "RDS password for ${local.env}-${local.name}"
  tags = {
    Name = "${local.env}-${local.name}-secret"
    Environment = local.env
  }
}

resource "aws_secretsmanager_secret_version" "rds_secret_version" {
  secret_id     = aws_secretsmanager_secret.rds_secret.id
  secret_string = jsonencode({
    DB_USER_NAME = var.rds_db_username
    DB_USER_PASSWORD = var.rds_db_password
    DB_SCHEMA_NAME = var.db_schema_name
    DB_HOST_URL = aws_db_instance.aws_rds.address
    DB_PORT = aws_db_instance.aws_rds.port
    JWT_SECRET = var.jwt_secret
  })
}