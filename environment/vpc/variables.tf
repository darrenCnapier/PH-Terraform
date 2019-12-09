variable "name" {
  type = string
}

variable "cidr" {
  type = string
  description = "The CIDR block for the VPC."
  default = "10.0.0.0/27"
}

variable "availability_zones" {
  type = list(string)
  default = []
}

variable "aws_region" {
  type = string
}
