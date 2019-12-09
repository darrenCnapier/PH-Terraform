output "instance_ip" {
  value = aws_eip.this_ip.public_ip
}

output "ec2-access-role-name" {
  value = aws_iam_role.this_ec2_access_role.name
}
