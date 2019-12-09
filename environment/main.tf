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
data "aws_db_instance" "production_postgres" {
  db_instance_identifier = "database-1-instance-1"
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
<<<<<<< HEAD


//
//# SSM
//module "dev_ssm" {
//  source = "./ssm"
//  name = var.project_name
//  env = "dev"
//  docs_user = var.docs_user
//  docs_password = var.docs_password
//  twilio_account_id = var.twilio_account_id
//  twilio_auth_token = var.twilio_auth_token
//  twilio_phone_number = var.twilio_phone_number
//  sentry_dsn = var.sentry_dsn
//  firebase_auth_json = var.firebase_auth_json
//  s3_bucket_name = module.dev_bucket.s3-bucket-name
//}
//module "staging_ssm" {
//  source = "./ssm"
//  name = var.project_name
//  env = "staging"
//  docs_user = var.docs_user
//  docs_password = var.docs_password
//  twilio_account_id = var.twilio_account_id
//  twilio_auth_token = var.twilio_auth_token
//  twilio_phone_number = var.twilio_phone_number
//  sentry_dsn = var.sentry_dsn
//  firebase_auth_json = var.firebase_auth_json
//  s3_bucket_name = module.staging_bucket.s3-bucket-name
//}
//
//
=======
>>>>>>> 0b9204970ed2ef135b99bec991b890274b47e8f2
# ECR

module "ecr" {
  source = "./ecr"
  name = "petehealth/petehealth_portal"
  project_name = var.project_name
}


<<<<<<< HEAD
module "production_instance" {
=======
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
>>>>>>> 0b9204970ed2ef135b99bec991b890274b47e8f2
  source = "./ec2"
  project_name = var.project_name
  env = "production"
  instance_type = var.instance_type
  subnet_id = module.vpc.public-subnet-ids[0]
  ssh_key_path = var.instance_ssh_key_path
  volume_size = var.instance_volume_size
  security_groups = [
    module.security_groups.public-security-group-id,
    module.security_groups.private-security-group-id]
  vpc_id = module.vpc.vpc-id
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
}
<<<<<<< HEAD

=======
>>>>>>> 0b9204970ed2ef135b99bec991b890274b47e8f2
# IAM
module "service_iam" {
  source   = "./service_iam_user"
  name = var.project_name
  username = "${var.project_name}-service-user"
}

<<<<<<< HEAD
#ACW
module "production_cloudwatch" {
  source = "./acw"
  name_for_cloudwatch_log_group = var.name_for_cloudwatch_log_group
  retention_in_days_for_cloudwatch_log_group = var.retention_in_days_for_cloudwatch_log_group
  project_name = var.project_name
  env = "production"
}

module "staging_cloudwatch" {
  source = "./acw"
  name_for_cloudwatch_log_group = var.name_for_cloudwatch_log_group
  retention_in_days_for_cloudwatch_log_group = var.retention_in_days_for_cloudwatch_log_group
  project_name = var.project_name
  env = "staging"
}

module "lambda" {
  source = "./lambda"
}
