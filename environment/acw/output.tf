output "cw_log_group_ids" {
  description = ""
  value       = aws_cloudwatch_log_group.cw_log_group.*.id
}

output "cw_log_group_names" {
  description = ""
  value       = "${aws_cloudwatch_log_group.cw_log_group.*.name}"
}

output "cloudwatch_log_stream_names" {
  description = ""
  value       = "${aws_cloudwatch_log_stream.cloudwatch_log_stream.*.name}"
}

