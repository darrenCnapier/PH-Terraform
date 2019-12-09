variable "name" {
  type = string
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "security_group_ids" {
  type = list(string)
  default = []
}

//variable "acm_cert_arn" {
//  type = string
//}

//variable "domain_name" {
//  type = string
//}

