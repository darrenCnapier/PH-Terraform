output "public-subnet-ids" {
  value = aws_subnet.this_public_subnet.*.id
}

output "private-subnet-ids" {
  value = aws_subnet.this_private_subnet.*.id
}

output "public-subnet-cidrs" {
  value = aws_subnet.this_public_subnet.*.cidr_block
}

output "private-subnet-cidrs" {
  value = aws_subnet.this_private_subnet.*.cidr_block
}


output "vpc-id" {
  value = aws_vpc.this_vpc.id
}
