#locals {
#  create_route_table_rules = var.create_route_table_rules
#}

######
# VPC
######
resource "aws_vpc" "this" {
  cidr_block           = var.cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags                 = merge(var.tags, { Name = "${var.vpc_prefix}-${var.vpc_suffix}-vpc"})
}

#################
# Devops Subnets
#################
resource "aws_subnet" "devops" {
  count = length(var.devops_subnets) > 0 ? length(var.devops_subnets) : 0

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.devops_subnets[count.index]
  availability_zone = element(var.azs, count.index)
  tags              = merge(var.tags, { Name = "${var.vpc_prefix}-${var.vpc_suffix}-devops-private-${substr(element(var.azs, count.index), -2, 2)}" })
  #tags              = merge(var.tags, { Name = "${var.vpc_prefix}-subnet-devops-${substr(element(var.azs, count.index), -2, 2)}" })
}

resource "aws_route_table" "devops" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.vpc_prefix}-${var.vpc_suffix}-devops-private-rt" })
}

resource "aws_route_table_association" "devops_subnets" {
  count          = length(var.devops_subnets)
  subnet_id      = aws_subnet.devops[count.index].id
  route_table_id = aws_route_table.devops.id
}

#resource "aws_route" "vpc_peering_devops" {
#  count = length(var.route_table_rules) > 0 ? length(var.route_table_rules) : 0
#  #count = var.vpc_peering_enabled ? 1 : 0
#  route_table_id = aws_route_table.devops
#  destination_cidr_block = var.peer_receiver_cidr
#  vpc_peering_connection_id = var.peering_connection_id
#}

###############
# Data Subnets
###############
resource "aws_subnet" "data" {
  count = length(var.data_subnets) > 0 ? length(var.data_subnets) : 0

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.data_subnets[count.index]
  availability_zone = element(var.azs, count.index)
  tags              = merge(var.tags, { Name = "${var.vpc_prefix}-${var.vpc_suffix}-data-private-${substr(element(var.azs, count.index), -2, 2)}" })
  #tags              = merge(var.tags, { Name = "${var.vpc_prefix}-subnet-data-${substr(element(var.azs, count.index), -2, 2)}" })
}

resource "aws_route_table" "data" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.vpc_prefix}-${var.vpc_suffix}-data-private-rt" })
}

resource "aws_route_table_association" "data_subnets" {
  count          = length(var.data_subnets)
  subnet_id      = aws_subnet.data[count.index].id
  route_table_id = aws_route_table.data.id
}

#resource "aws_route" "data_routes" {
#  count = var.peering_enabled ? 1 : 0
#
#  route_table_id = aws_route_table.data
#  destination_cidr_block = var.route_destination
#  vpc_peering_connection_id = var.peering_connection_id
#}

#############
# App subnet
#############
resource "aws_subnet" "app" {
  count = length(var.app_subnets) > 0 ? length(var.app_subnets) : 0

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.app_subnets[count.index]
  availability_zone = element(var.azs, count.index)
  tags              = merge(var.tags, { Name = "${var.vpc_prefix}-${var.vpc_suffix}-app-private-${substr(element(var.azs, count.index), -2, 2)}" })
  #tags              = merge(var.tags, { Name = "${var.vpc_prefix}-subnet-app-${substr(element(var.azs, count.index), -2, 2)}" })
}

resource "aws_route_table" "app" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.vpc_prefix}-${var.vpc_suffix}-app-private-rt" })
}

resource "aws_route_table_association" "app_subnets" {
  count          = length(var.app_subnets)
  subnet_id      = aws_subnet.app[count.index].id
  route_table_id = aws_route_table.app.id
}

#resource "aws_route" "vpc_peering_vpn" {
#  count = var.vpc_peering_enabled ? 1 : 0
#  route_table_id = aws_route_table.vpn
#  destination_cidr_block = var.peer_receiver_cidr
#  vpc_peering_connection_id = var.peering_connection_id
#}

################
# Public subnet
################
resource "aws_subnet" "public" {
  count = length(var.public_subnets) > 0 ? length(var.public_subnets) : 0

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = element(var.azs, count.index)
  tags              = merge(var.tags, { Name = "${var.vpc_prefix}-${var.vpc_suffix}-public-${substr(element(var.azs, count.index), -2, 2)}" })
  #tags              = merge(var.tags, { Name = "${var.vpc_prefix}-subnet-public-${substr(element(var.azs, count.index), -2, 2)}" })
  map_public_ip_on_launch = var.assign_public_ip
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.vpc_prefix}-${var.vpc_suffix}-public-rt" })
}

resource "aws_route_table_association" "public_subnets" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

#resource "aws_route" "vpc_peering_vpn" {
#  count = var.vpc_peering_enabled ? 1 : 0
#  route_table_id = aws_route_table.vpn
#  destination_cidr_block = var.peer_receiver_cidr
#  vpc_peering_connection_id = var.peering_connection_id
#}

#############
# VPN subnet
#############
resource "aws_subnet" "vpn" {
  count = length(var.vpn_subnets) > 0 ? length(var.vpn_subnets) : 0

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.vpn_subnets[count.index]
  availability_zone       = element(var.azs, count.index)
  tags              = merge(var.tags, { Name = "${var.vpc_prefix}-${var.vpc_suffix}-vpn-private-${substr(element(var.azs, count.index), -2, 2)}" })
  #tags              = merge(var.tags, { Name = "${var.vpc_prefix}-subnet-vpn-${substr(element(var.azs, count.index), -2, 2)}" })
}

resource "aws_route_table" "vpn" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.vpc_prefix}-${var.vpc_suffix}-vpn-private-rt" })
}

resource "aws_route_table_association" "vpn_subnets" {
  count          = length(var.vpn_subnets)
  subnet_id      = aws_subnet.vpn[count.index].id
  route_table_id = aws_route_table.vpn.id
}

#resource "aws_route" "vpc_peering_vpn" {
#  count = var.vpc_peering_enabled ? 1 : 0
#  route_table_id = aws_route_table.vpn
#  destination_cidr_block = var.peer_receiver_cidr
#  vpc_peering_connection_id = var.peering_connection_id
#}

###############################
# Public Internet Egress Routes
###############################
resource "aws_route" "internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

##################
# Internet Gateway
##################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { Name = "${var.vpc_prefix}-${var.vpc_suffix}-igw"})
}