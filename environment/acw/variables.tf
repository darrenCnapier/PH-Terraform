variable "name_for_cloudwatch_log_group" {
  description = "The name of the log group. If omitted, Terraform will assign a random, unique name."
  default     = ""
}
variable "retention_in_days_for_cloudwatch_log_group" {
  description = "Specifies the number of days you want to retain log events in the specified log group."
  default     = "0"
}

variable "project_name" {
  type = string
}

variable "env" {
  type = string
}
