resource "aws_subnet" "private" {
  count = local.az_num

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index + local.az_num)
  tags                    = merge(var.tags, { "Name" = "Private-${cidrsubnet(var.vpc_cidr, 8, count.index + local.az_num)}" })
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = false
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { "Name" = "Private Route Table" })
}

resource "aws_route" "nat_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.this.id
}

resource "aws_route_table_association" "private_route_table_association" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt.id
}