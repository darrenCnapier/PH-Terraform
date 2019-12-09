variable "project_name" {
  type = string
}


variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/25"
}

variable "public_ports" {
  type = list(string)
  default = [
    22,
    80,
    443,
    8080,
  ]
}

variable "whitelisted_cidrs" {
  type    = list(string)
  default = ["194.183.167.110/32"]
}


variable "dev_db_username" {
  type = string
}

variable "dev_db_password" {
  type = string
}

variable "dev_db_name" {
  type = string
}

variable "staging_db_username" {
  type = string
}

variable "staging_db_password" {
  type = string
}

variable "staging_db_name" {
  type = string
}
//variable "domain_name" {
//  type = string
//  default = "uptech.team"
//}
//
variable "instance_type" {
  type = string
}

variable "instance_ssh_key_path" {
  type = string
}

variable "instance_volume_size" {
  type = number
}


