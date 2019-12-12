variable "env" {
  type = string
}

variable "ivinex_username" {
  type = string
}

variable "ivinex_password" {
  type = string
}

variable "cl_username" {
  type = string
}

variable "cl_password" {
  type = string
}

variable "gmail_email" {
  type = string
}

variable "gmail_password" {
  type = string
}

variable "twilio_sid" {
  type = string
}

variable "twilio_token" {
  type = string
}

variable "twilio_from" {
  type = string
}

variable "pg_host" {
  type = string
}

variable "pg_database" {
  type = string
}

variable "pg_username" {
  type = string
}

variable "pg_password" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
}

variable "subnet_ids" {
  type = list(string)
}
