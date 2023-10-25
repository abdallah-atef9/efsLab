terraform {
  required_version = ">=0.12" # ate least 0.12
}
# modules/vpc/main.tf
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.name
  }
}

/*

    Creating Subnets

*/
resource "aws_subnet" "public" {
  count = length(var.public_subnets)

  cidr_block = var.public_subnets[count.index]
  vpc_id     = aws_vpc.main.id
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-public-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count = length(var.private_subnets)

  cidr_block = var.private_subnets[count.index]
  vpc_id     = aws_vpc.main.id
  # map_public_ip_on_launch = true

  tags = {
    Name = "${var.name}-private-${count.index}"
  }
}
/*

    Creating Internet Gateway

*/
resource "aws_internet_gateway" "ntrntgw" {
  vpc_id = aws_vpc.main.id
}

/*
    Creating NATGateway

*/
resource "aws_eip" "nat_ip" {

}
resource "aws_nat_gateway" "nateGateway" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public[1].id

}
/*

    Creating Routing Table

*/
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}
resource "aws_route" "publicRoute" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.ntrntgw.id
}
resource "aws_route_table_association" "rtaPublic" {
  subnet_id      = aws_subnet.public[1].id
  route_table_id = aws_route_table.public.id
}

# -----------------------------------------------------------------
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "privateRoute" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nateGateway.id
}

resource "aws_route_table_association" "rtaPrivate1" {
  subnet_id      = aws_subnet.private[1].id
  route_table_id = aws_route_table.private.id
}

# ----------------------------------------------------------------------

/*

    OUTPTUS

*/
output "vpc_id" {
  value = aws_vpc.main.id
}

output "vpc_cidrblock" {
  value = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.private.*.id
}
