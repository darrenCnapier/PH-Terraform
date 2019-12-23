variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "instance_type" {
  type = string
  default = "t2.micro"
}

variable "subnet_id" {
  type = string
}

variable "ssh_key_path" {
  type = string
}

variable "volume_size" {
  default = 10
}

variable "security_groups" {
  default = []
}

variable "vpc_id" {
  type = string
}

