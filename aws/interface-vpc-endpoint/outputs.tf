output "vpc_endpoint_id" {
  value       = aws_vpc_endpoint.this.id
  description = "The ID of the VPC endpoint created."
}

output "security_group_id" {
  value       = aws_security_group.this.id
  description = "The ID of the security group created for the VPC endpoint."
}
