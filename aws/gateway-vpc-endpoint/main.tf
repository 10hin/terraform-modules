resource "aws_vpc_endpoint" "this" {
  vpc_id = var.vpc_id
  service_name = var.service_name
  vpc_endpoint_type = "Gateway"
  policy = var.policy
  tags = {
    Name = var.base_name
  }
}

resource "aws_vpc_endpoint_route_table_association" "this" {
  for_each = var.route_table_ids

  vpc_endpoint_id = aws_vpc_endpoint.this.id
  route_table_id  = each.value
}
