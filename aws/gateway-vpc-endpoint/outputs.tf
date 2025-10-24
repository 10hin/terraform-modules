output "vpc_endpoint_id" {
  value = aws_vpc_endpoint.this.id
  description = "The ID of the VPC endpoint created."
}

output "prefix_list_id" {
  value = aws_vpc_endpoint.this.prefix_list_id
  description = "The prefix list ID associated with the VPC endpoint."
}
