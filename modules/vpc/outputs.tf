output "public_networks" {
  value = aws_subnet.public.*.id
}

output "private_networks" {
  value = aws_subnet.private.*.id
}

output "vpc_id" {
  value = aws_vpc.this.id
}

output "az_list" {
  value = data.aws_availability_zones.available.names
}