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
  //acm_cert_arn = module.alb.acm-cert-arn
  //domain_name = var.domain_name
}
//
//
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
//
//
//
//module "dev_subdomain" {
//  source = "./route53"
//  domain_name = var.domain_name
//  subdomain = "dev-petehealth"
//  alb_zone_id = module.alb.alb-zone-id
//  alb_dns_name = module.alb.alb-dns-name
//  name = var.project_name
//  env = "dev"
//}
//
//module "staging_subdomain" {
//  source       = "./route53"
//  domain_name  = var.domain_name
//  subdomain    = "staging-petehealth"
//  alb_zone_id  = module.alb.alb-zone-id
//  alb_dns_name = module.alb.alb-dns-name
//  name = var.project_name
//  env = "staging"
//}
//
//
//
# IAM
module "service_iam" {
  source   = "./service_iam_user"
  name = var.project_name
  username = "${var.project_name}-service-user"
}

#ACW
module "prodaction_cloudwatch" {
  source = "./acw"
  name_for_cloudwatch_log_group = var.name_for_cloudwatch_log_group
  retention_in_days_for_cloudwatch_log_group = var.retention_in_days_for_cloudwatch_log_group
  project_name = var.project_name
  env = "prodaction"
}

module "staging_cloudwatch" {
  source = "./acw"
  name_for_cloudwatch_log_group = var.name_for_cloudwatch_log_group
  retention_in_days_for_cloudwatch_log_group = var.retention_in_days_for_cloudwatch_log_group
  project_name = var.project_name
  env = "staging"
}
