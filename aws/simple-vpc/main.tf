data "aws_partition" "current" {}
data "aws_region" "current" {}
data "aws_availability_zones" "available" {
  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
}

locals {
  aws_partition = data.aws_partition.current.partition
  aws_region    = data.aws_region.current.name

  aws_az_ids   = slice(data.aws_availability_zones.available.zone_ids, 0, var.availability_zone_count)
  aws_az_names = slice(data.aws_availability_zones.available.names, 0, var.availability_zone_count)

  subnet_types = ["private", "public"]
  subnet_cidr_blocks = {
    for subnet_type_idx, subnet_type in local.subnet_types :
    subnet_type => {
      for az_idx, az_id in local.aws_az_ids :
      az_id => cidrsubnet(var.cidr_block, ceil(log(var.availability_zone_count * length(local.subnet_types), 2)), subnet_type_idx * var.availability_zone_count + az_idx)
    }
  }

  nat_gateway_count = var.nat_gateway_allocation == "single" ? 1 : (var.nat_gateway_allocation == "ha" ? var.availability_zone_count : 0)
}

resource "aws_vpc" "this" {
  cidr_block                           = var.cidr_block
  instance_tenancy                     = var.instance_tenancy
  enable_dns_support                   = var.enable_dns_support
  enable_dns_hostnames                 = var.enable_dns_hostnames
  enable_network_address_usage_metrics = var.enable_network_address_usage_metrics
  tags = {
    Name = "${var.base_name}-vpc"
  }
}

resource "aws_default_network_acl" "this" {
  default_network_acl_id = aws_vpc.this.default_network_acl_id
}

resource "aws_default_route_table" "this" {
  default_route_table_id = aws_vpc.this.default_route_table_id
  route                  = []
}

resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.base_name}-igw"
  }
}

resource "aws_subnet" "private" {
  for_each = toset(local.aws_az_ids)

  vpc_id                                      = aws_vpc.this.id
  availability_zone_id                        = each.key
  cidr_block                                  = local.subnet_cidr_blocks["private"][each.key]
  map_public_ip_on_launch                     = false
  enable_resource_name_dns_a_record_on_launch = var.enable_resource_name_dns_a_record_on_launch
  private_dns_hostname_type_on_launch         = var.private_dns_hostname_type_on_launch
  tags = {
    Name               = "${var.base_name}-subnet-private-${local.aws_az_names[index(local.aws_az_ids, each.key)]}"
    AvailabilityZone   = local.aws_az_names[index(local.aws_az_ids, each.key)]
    AvailabilityZoneID = each.key
    SubnetType         = "private"
  }
}

resource "aws_route_table" "private" {
  for_each = toset(local.aws_az_ids)

  vpc_id = aws_vpc.this.id
  tags = {
    Name               = "${var.base_name}-rt-private-${local.aws_az_names[index(local.aws_az_ids, each.key)]}"
    AvailabilityZone   = local.aws_az_names[index(local.aws_az_ids, each.key)]
    AvailabilityZoneID = each.key
    SubnetType         = "private"
  }
}

resource "aws_route_table_association" "private" {
  for_each = toset(local.aws_az_ids)

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}

resource "aws_route" "private_to_natgw" {
  for_each = toset(local.aws_az_ids)

  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[local.aws_az_ids[max(0, min(local.nat_gateway_count - 1, index(local.aws_az_ids, each.key)))]].id
}

resource "aws_network_acl" "private" {
  for_each = toset(local.aws_az_ids)

  vpc_id = aws_vpc.this.id
  tags = {
    Name               = "${var.base_name}-acl-private-${local.aws_az_names[index(local.aws_az_ids, each.key)]}"
    AvailabilityZone   = local.aws_az_names[index(local.aws_az_ids, each.key)]
    AvailabilityZoneID = each.key
    SubnetType         = "private"
  }
}

resource "aws_network_acl_association" "private" {
  for_each = toset(local.aws_az_ids)

  subnet_id      = aws_subnet.private[each.key].id
  network_acl_id = aws_network_acl.private[each.key].id
}

resource "aws_network_acl_rule" "private_allow_all_ingress" {
  for_each = toset(local.aws_az_ids)

  network_acl_id = aws_network_acl.private[each.key].id
  rule_number    = 100
  egress         = false
  rule_action    = "allow"
  protocol       = -1
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "private_allow_all_egress" {
  for_each = toset(local.aws_az_ids)

  network_acl_id = aws_network_acl.private[each.key].id
  rule_number    = 100
  egress         = true
  rule_action    = "allow"
  protocol       = -1
  cidr_block     = "0.0.0.0/0"
}

resource "aws_subnet" "public" {
  for_each = toset(local.aws_az_ids)

  vpc_id                                      = aws_vpc.this.id
  availability_zone_id                        = each.key
  cidr_block                                  = local.subnet_cidr_blocks["public"][each.key]
  map_public_ip_on_launch                     = false
  enable_resource_name_dns_a_record_on_launch = var.enable_resource_name_dns_a_record_on_launch
  private_dns_hostname_type_on_launch         = var.private_dns_hostname_type_on_launch
  tags = {
    Name               = "${var.base_name}-subnet-public-${local.aws_az_names[index(local.aws_az_ids, each.key)]}"
    AvailabilityZone   = local.aws_az_names[index(local.aws_az_ids, each.key)]
    AvailabilityZoneID = each.key
    SubnetType         = "public"
  }
}

resource "aws_route_table" "public" {
  for_each = toset(local.aws_az_ids)

  vpc_id = aws_vpc.this.id
  tags = {
    Name               = "${var.base_name}-rt-public-${local.aws_az_names[index(local.aws_az_ids, each.key)]}"
    AvailabilityZone   = local.aws_az_names[index(local.aws_az_ids, each.key)]
    AvailabilityZoneID = each.key
    SubnetType         = "public"
  }
}

resource "aws_route_table_association" "public" {
  for_each = toset(local.aws_az_ids)

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public[each.key].id
}

resource "aws_route" "public_to_igw" {
  for_each = toset(local.aws_az_ids)

  route_table_id         = aws_route_table.public[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_network_acl" "public" {
  for_each = toset(local.aws_az_ids)

  vpc_id = aws_vpc.this.id
  tags = {
    Name               = "${var.base_name}-acl-public-${local.aws_az_names[index(local.aws_az_ids, each.key)]}"
    AvailabilityZone   = local.aws_az_names[index(local.aws_az_ids, each.key)]
    AvailabilityZoneID = each.key
    SubnetType         = "public"
  }
}

resource "aws_network_acl_association" "public" {
  for_each = toset(local.aws_az_ids)

  subnet_id      = aws_subnet.public[each.key].id
  network_acl_id = aws_network_acl.public[each.key].id
}

resource "aws_network_acl_rule" "public_allow_all_ingress" {
  for_each = toset(local.aws_az_ids)

  network_acl_id = aws_network_acl.public[each.key].id
  rule_number    = 100
  egress         = false
  rule_action    = "allow"
  protocol       = -1
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "public_allow_all_egress" {
  for_each = toset(local.aws_az_ids)

  network_acl_id = aws_network_acl.public[each.key].id
  rule_number    = 100
  egress         = true
  rule_action    = "allow"
  protocol       = -1
  cidr_block     = "0.0.0.0/0"
}

resource "aws_eip" "natgw" {
  for_each = toset(slice(local.aws_az_ids, 0, local.nat_gateway_count))

  domain = "vpc"
  tags = {
    Name               = "${var.base_name}-natgw-eip-${local.aws_az_names[index(local.aws_az_ids, each.key)]}"
    AvailabilityZone   = local.aws_az_names[index(local.aws_az_ids, each.key)]
    AvailabilityZoneID = each.key
  }
}

resource "aws_nat_gateway" "this" {
  for_each = toset(slice(local.aws_az_ids, 0, local.nat_gateway_count))

  allocation_id = aws_eip.natgw[each.key].id
  subnet_id     = aws_subnet.public[each.key].id
  tags = {
    Name               = "${var.base_name}-natgw-${local.aws_az_names[index(local.aws_az_ids, each.key)]}"
    AvailabilityZone   = local.aws_az_names[index(local.aws_az_ids, each.key)]
    AvailabilityZoneID = each.key
  }
}
