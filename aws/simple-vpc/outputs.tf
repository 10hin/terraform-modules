output "availability_zone_ids_to_use" {
  value       = local.aws_az_ids
  description = "The availability zone IDs to use."
}

output "availability_zone_names_to_use" {
  value       = local.aws_az_names
  description = "The availability zone names to use."
}

output "availability_zone_id_to_name" {
  value       = zipmap(local.aws_az_ids, local.aws_az_names)
  description = "A map of availability zone IDs to names."
}

output "availability_zone_name_to_id" {
  value       = zipmap(local.aws_az_names, local.aws_az_ids)
  description = "A map of availability zone names to IDs."
}

output "vpc_id" {
  value       = aws_vpc.this.id
  description = "The ID of the VPC"
}

output "internet_gateway_id" {
  value       = aws_internet_gateway.this.id
  description = "The ID of the Internet Gateway"
}

output "nat_gateway_ids" {
  value = [
    for az_id in slice(local.aws_az_ids, 0, local.nat_gateway_count) :
    aws_nat_gateway.this[az_id].id
  ]
  description = "The IDs of the NAT Gateways"
}

output "private_subnet_ids" {
  value = [
    for az_id in local.aws_az_ids :
    aws_subnet.private[az_id].id
  ]
}

output "private_subnet_id_to_az_id" {
  value       = zipmap([for az_id in local.aws_az_ids : aws_subnet.private[az_id].id], local.aws_az_ids)
  description = "A map of private subnet IDs to availability zone IDs."
}

output "az_id_to_private_subnet_id" {
  value       = zipmap(local.aws_az_ids, [for az_id in local.aws_az_ids : aws_subnet.private[az_id].id])
  description = "A map of availability zone IDs to private subnet IDs."
}

output "public_subnet_ids" {
  value = [
    for az_id in local.aws_az_ids :
    aws_subnet.public[az_id].id
  ]
}

output "public_subnet_id_to_az_id" {
  value       = zipmap([for az_id in local.aws_az_ids : aws_subnet.public[az_id].id], local.aws_az_ids)
  description = "A map of public subnet IDs to availability zone IDs."
}

output "az_id_to_public_subnet_id" {
  value       = zipmap(local.aws_az_ids, [for az_id in local.aws_az_ids : aws_subnet.public[az_id].id])
  description = "A map of availability zone IDs to public subnet IDs."
}

output "default_route_table_id" {
  value       = aws_vpc.this.default_route_table_id
  description = "The ID of the default route table (not used) for the VPC"
}

output "public_route_table_ids" {
  value = [
    for az_id in local.aws_az_ids :
    aws_route_table.public[az_id].id
  ]
  description = "The IDs of the public route tables"
}

output "private_route_table_ids" {
  value = [
    for az_id in local.aws_az_ids :
    aws_route_table.private[az_id].id
  ]
  description = "The IDs of the private route tables"
}
