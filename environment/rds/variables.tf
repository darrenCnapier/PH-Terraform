variable "name" {
  type = string
}

variable "env" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
  default = []
}

variable "security_group_ids" {
  type = list(string)
  default = []
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "db_name" {
  type = string
}
