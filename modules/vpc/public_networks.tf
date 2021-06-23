resource "aws_subnet" "public" {
  count = local.az_num

  availability_zone       = data.aws_availability_zones.available.names[count.index]
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  tags                    = merge(var.tags, { "Name" = "Public-${cidrsubnet(var.vpc_cidr, 8, count.index)}" })
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = true
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.this.id
  tags   = merge(var.tags, { "Name" = "Public Route Table" })
}

resource "aws_route" "igw_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public_route_table_association" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}