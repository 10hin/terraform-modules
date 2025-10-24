resource "aws_vpc_endpoint" "this" {
  vpc_id              = var.vpc_id
  service_name        = var.service_name
  vpc_endpoint_type   = "Interface"
  policy              = var.policy
  private_dns_enabled = var.private_dns_enabled
  tags = {
    Name = var.base_name
  }
}

resource "aws_security_group" "this" {
  name   = var.base_name
  vpc_id = var.vpc_id
}

resource "aws_vpc_endpoint_security_group_association" "this" {
  for_each = var.subnet_ids

  vpc_endpoint_id   = aws_vpc_endpoint.this.id
  security_group_id = aws_security_group.this.id
}

resource "aws_vpc_endpoint_subnet_association" "this" {
  for_each = var.subnet_ids

  vpc_endpoint_id = aws_vpc_endpoint.this.id
  subnet_id       = each.value
  depends_on = [
    awsp_vpc_endpoint_security_group_association.this,
  ]
}
