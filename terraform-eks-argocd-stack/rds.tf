resource "aws_db_instance" "aws_rds" {
    identifier           = "${local.env}-${local.name}-rds"
    engine               = "mysql"
    engine_version       = "8.0"
    instance_class       = local.rds_instance_class
    allocated_storage    = local.rds_storage_size
    db_name              = local.rds_db_name
    username             = var.rds_db_username
    password             = var.rds_db_password
    
    db_subnet_group_name = aws_db_subnet_group.rds_subnet_group.name
    vpc_security_group_ids = [aws_security_group.sg-rds.id]   
    
    skip_final_snapshot  = true    
    tags = {
      name = "${local.env}-${local.name}-rds"
    }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "${local.env}-${local.name}-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name        = "${local.env}-${local.name}-subnet-group"
    Environment = local.env
  }
}