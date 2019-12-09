variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_ports" {
  type = list(number)
  default = [22, 80, 443]
}

variable "whitelisted_cidrs" {
  type = list(string)
  default = []
}
