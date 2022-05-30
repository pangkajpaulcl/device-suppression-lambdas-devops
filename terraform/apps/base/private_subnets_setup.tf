
resource "aws_vpc_ipv4_cidr_block_association" "main_vpc_cidr_private_subnets" {
  vpc_id     = data.aws_vpc.main_vpc.id
  cidr_block = "10.7.0.0/16" # NOTE: This should be /20 but AWS won't take it
}

locals {
  # One public subnet to attach NAT GW
  public_subnet_1_id = "subnet-0fcf713e732fafd02"
}

resource "aws_subnet" "private_subnets" {
  for_each = local.private_subnets # From separate file

  vpc_id            = data.aws_vpc.main_vpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.zone
  tags = {
    Name = each.value.name
  }
  depends_on = [aws_vpc_ipv4_cidr_block_association.main_vpc_cidr_private_subnets]
}

resource "aws_eip" "nat_eip" {
  vpc              = true
  public_ipv4_pool = "amazon"
  tags = {
    Name = "For NAT for private subnets",
  }
  depends_on = [aws_subnet.private_subnets]
}

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = local.public_subnet_1_id
  tags = {
    Name = "For private subnets"
  }
}

resource "aws_route_table" "private_subnet_route_table" {
  vpc_id = data.aws_vpc.main_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "For private subnets"
  }
}

resource "aws_route_table_association" "private_subnet_route_assocs" {
  for_each = aws_subnet.private_subnets

  route_table_id = aws_route_table.private_subnet_route_table.id
  subnet_id      = each.value.id
}


