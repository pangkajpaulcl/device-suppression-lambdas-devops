
# data "aws_availability_zones" "available" {}

resource "aws_vpc" "head" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "${var.tenancy}"

  tags = {
    Name = "${var.app_name}-${var.development_environment}"
    Environment = var.development_environment
  }
}

resource "aws_subnet" "head" {
  count = length(var.subnet_cidrs)
  vpc_id     = "${var.vpc_id}"
  cidr_block = var.subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name = "${var.app_name}-${var.development_environment}"
    Environment = var.development_environment

  }
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.head.id

  tags = {
    Name = "${var.app_name}-${var.development_environment}"
    Environment = var.development_environment

  }
}

resource "aws_egress_only_internet_gateway" "egress" {
  vpc_id = aws_vpc.head.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.head.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.egress.id
  }

  tags = {
    Name = "${var.app_name}-${var.development_environment}"
    Environment = var.development_environment

  }
}

resource "aws_main_route_table_association" "a" {
  vpc_id         = aws_vpc.head.id
  route_table_id = aws_route_table.main.id
}

