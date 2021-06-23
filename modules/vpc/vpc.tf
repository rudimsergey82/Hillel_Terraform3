resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  instance_tenancy     = "default"
  tags                 = merge(var.tags, { "Name" = var.vpc_cidr })
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = var.tags
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.public.1.id
}

resource "aws_eip" "this" {
  vpc  = "true"
  tags = var.tags
}

data "aws_availability_zones" "available" { // Sometimes placed into stand alone file, i.e. "dependencies.tf"
  state = "available"
}

locals {
  az_num = length(data.aws_availability_zones.available.names)
}
