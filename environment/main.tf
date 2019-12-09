terraform {
  backend "s3" {
    key = "dev/state.tfstate"
    encrypt = true
  }
}

# VPC
module "vpc" {
  source = "./vpc"
  name = var.project_name
  cidr = var.vpc_cidr
  availability_zones = [
    "${var.aws_region}b",
    "${var.aws_region}c",
  ]
  aws_region = var.aws_region
}

# Security groups
module "security_groups" {
  source = "./security_group"
  name = var.project_name
  vpc_id = module.vpc.vpc-id
  public_ports = var.public_ports
  whitelisted_cidrs = flatten([
    module.vpc.private-subnet-cidrs,
    module.vpc.public-subnet-cidrs,
    var.whitelisted_cidrs,
  ])
}

# RDS
module "prodaction_postgres" {
  source = "./rds"
  name = var.project_name

  env = "prodaction"
  subnet_ids = flatten([
    module.vpc.public-subnet-ids])
  security_group_ids = [
    module.security_groups.private-security-group-id,
  ]

  username = var.dev_db_username
  password = var.dev_db_password
  db_name = var.dev_db_name
}

module "staging_postgres" {
  source     = "./rds"
  name       = var.project_name
  env        = "staging"
  subnet_ids = flatten([module.vpc.private-subnet-ids, module.vpc.public-subnet-ids])
  security_group_ids = [
    module.security_groups.private-security-group-id,
    module.security_groups.public-security-group-id,
  ]
  username = var.staging_db_username
  password = var.staging_db_password
  db_name  = var.staging_db_name
}
# ECR

module "ecr" {
  source = "./ecr"
  name = "petehealth/petehealth_portal"
  project_name = var.project_name
  role_names = [module.prodaction_instance.ec2-access-role-name, module.staging_instance.ec2-access-role-name]
}


# ALB
module "alb" {
  source = "./alb"
  name = var.project_name
  public_subnet_ids = flatten([
    module.vpc.public-subnet-ids])
  security_group_ids = [
    module.security_groups.open-security-group-id,
  ]
}
module "prodaction_instance" {
  source = "./ec2"
  project_name = var.project_name
  env = "prodaction"
  instance_type = var.instance_type
  subnet_id = module.vpc.public-subnet-ids[0]
  ssh_key_path = var.instance_ssh_key_path
  volume_size = var.instance_volume_size
  security_groups = [
    module.security_groups.public-security-group-id,
    module.security_groups.private-security-group-id]
  vpc_id = module.vpc.vpc-id
  #subdomain_name = module.dev_subdomain.domain-name
  alb_listener_arn = module.alb.alb-listener-arn
}

module "staging_instance" {
  source = "./ec2"
  project_name = var.project_name
  env = "staging"
  instance_type = var.instance_type
  subnet_id = module.vpc.public-subnet-ids[1]
  ssh_key_path = var.instance_ssh_key_path
  volume_size = var.instance_volume_size
  security_groups = [
    module.security_groups.public-security-group-id,
    module.security_groups.private-security-group-id]
  vpc_id = module.vpc.vpc-id
  alb_listener_arn = module.alb.alb-listener-arn
}
# IAM
module "service_iam" {
  source   = "./service_iam_user"
  name = var.project_name
  username = "${var.project_name}-service-user"
}

