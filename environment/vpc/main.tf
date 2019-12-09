### VPC ###
resource "aws_vpc" "this_vpc" {
  cidr_block = var.cidr
  enable_dns_hostnames = true

  tags = {
    Name = "${var.name}_vpc"
    Terraform = true
    Project = var.name
  }
}

resource "aws_internet_gateway" "this_gateway" {
  vpc_id = aws_vpc.this_vpc.id

  tags = {
    Name = "${var.name}_internet_gateway"
    Terraform = true
    Project = var.name
  }
}


### Public Subnets ###

resource "aws_subnet" "this_public_subnet" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.this_vpc.id
  cidr_block = cidrsubnet(var.cidr, 3, count.index)
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}_public_${var.availability_zones[count.index]}"
    Terraform = true
    Project = var.name
  }
}

### Private Subnets ###

resource "aws_eip" "this_eip" {
  count = length(var.availability_zones)
  vpc = true
  tags = {
    Name = "${var.name}_eip"
    Terraform = true
    Project = var.name
  }
}

resource "aws_nat_gateway" "this_nat" {
  count = length(var.availability_zones)
  allocation_id = aws_eip.this_eip.*.id[count.index]
  subnet_id = aws_subnet.this_public_subnet.*.id[count.index]

  tags = {
    Name = "${var.name}_nat_${var.availability_zones[count.index]}"
    Terraform = true
    Project = var.name
  }

  depends_on = [
    "aws_eip.this_eip",
    "aws_internet_gateway.this_gateway",
    "aws_subnet.this_public_subnet"
  ]
}

resource "aws_subnet" "this_private_subnet" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.this_vpc.id
  cidr_block = cidrsubnet(var.cidr, 3, count.index + length(var.availability_zones))
  availability_zone = var.availability_zones[count.index]
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.name}_private_${var.availability_zones[count.index]}"
    Terraform = true
    Project = var.name
  }
}


### Routing public subnets ###

resource "aws_route_table" "route" {
  vpc_id = aws_vpc.this_vpc.id

  # Default route through Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this_gateway.id
  }

  tags = {
    Name = "${var.name}_public_route_table"
    Terraform = true
    Project = var.name
  }
}

resource "aws_route_table_association" "route" {
  count = length(var.availability_zones)
  subnet_id = aws_subnet.this_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.route.id
}


### Routing private subnets ###

resource "aws_route_table" "private_route" {
  count = length(var.availability_zones)
  vpc_id = aws_vpc.this_vpc.id

  # Default route through NAT
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.this_nat.*.id[count.index]
  }

  tags = {
    Name = "${var.name}_private_route_table_${var.availability_zones[count.index]}"
    Terraform = true
    Project = var.name
  }
}

resource "aws_route_table_association" "private_route" {
  count = length(var.availability_zones)
  subnet_id = aws_subnet.this_private_subnet.*.id[count.index]
  route_table_id = aws_route_table.private_route.*.id[count.index]
}

