resource "aws_cloudwatch_log_group" "cw_log_group" {
  name                = "${var.project_name}_log_group_${var.env}"
  retention_in_days   = var.retention_in_days_for_cloudwatch_log_group


  tags = {
    Name = "${var.project_name}_${var.env}_log_group"
    Terraform = true
    Enviroment = var.env
    Project = var.project_name
  }
}

resource "aws_cloudwatch_log_stream" "cloudwatch_log_stream" {
  name           = "${var.project_name}_log_stream_${var.env}"
  log_group_name = aws_cloudwatch_log_group.cw_log_group.name
}



