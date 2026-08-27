module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.name}-vpc"
  cidr = local.cidr_block

  azs             = local.azs
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets
  intra_subnets = local.intra_subnet
  map_public_ip_on_launch = "true"
  enable_nat_gateway = true
  single_nat_gateway = true
  tags = {  
    Terraform = "true"
    Environment = local.env
  }
}
resource "aws_security_group" "sg-rds" {
    vpc_id      = module.vpc.vpc_id
    tags = {
        Name = "${local.env}-${local.name}-sg-rds"
        Environment = local.env
    }
        ingress {
        from_port   = 3306 #SQL PORT
        to_port     = 3306
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

