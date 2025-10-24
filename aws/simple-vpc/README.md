# `aws/simple-vpc`

Create simple (standard and easy) VPC.

This module creates:

- VPC
- You can change the number of availability zone to use.
  - Default: 3
- Public subnets
  - The number of public subnets is equal to the number of  availability zone to use.
  - Public subnets have default route to Internet Gateway of VPC.
- Private subnets
  - The number of public subnets is equal to the number of availability zone to use.
  - Private subnets have default route to NAT Gateway.
- Default SecurityGroup/NetworkACL/RouteTable entries will be cleared

## Diagram

### `nat_gateway_allocation = "ha"`

```mermaid
flowchart TB
  subgraph legend
    direction RL
    legend_rt([Route Table]) -. "Route" .-> legend_rt_target[Target]
  end
  subgraph region
    subgraph VPC
      direction RL
      subgraph zone3
        subgraph public3
          pubrt3(["public Route Table 3"])
          pubnacl3(["public Network ACL 3"])
          eip3["Elastic IP 3"]
          natgw3["NAT Gateway 3"]
          natgw3 -.- eip3
        end
        subgraph private3
          pvtrt3(["private Route Table 3"])
          pvtnacl3(["private Network ACL 3"])
        end
        pvtrt3 -...->|"0.0.0.0/0"| natgw3
      end
      subgraph zone2
        subgraph public2
          pubrt2(["public Route Table 2"])
          pubnacl2(["public Network ACL 2"])
          eip2["Elastic IP 2"]
          natgw2["NAT Gateway 2"]
          natgw2 -.- eip2
        end
        subgraph private2
          pvtrt2(["private Route Table 2"])
          pvtnacl2(["private Network ACL 2"])
        end
        pvtrt2 -...->|"0.0.0.0/0"| natgw2
      end
      subgraph zone1
        subgraph public1
          pubrt1(["public Route Table 1"])
          pubnacl1(["public Network ACL 1"])
          eip1["Elastic IP 1"]
          natgw1["NAT Gateway 1"]
          natgw1 -.- eip1
        end
        subgraph private1
          pvtrt1(["private Route Table 1"])
          pvtnacl1(["private Network ACL 1"])
        end
        pvtrt1 -...->|"0.0.0.0/0"| natgw1
      end
      igw["Internet Gateway"]
      pubrt1 -...->|"0.0.0.0/0"| igw
      pubrt2 -...->|"0.0.0.0/0"| igw
      pubrt3 -...->|"0.0.0.0/0"| igw
      defrt(["default Route Table"])
      defnacl(["default Network ACL"])
      defsg(["default Security Group"])
    end
  end
```

### `nat_gateway_allocation = "single"`

```mermaid
flowchart TB
  subgraph legend
    direction RL
    legend_rt([Route Table]) -. "Route" .-> legend_rt_target[Target]
  end
  subgraph region
    subgraph VPC
      direction RL
      subgraph zone3
        subgraph public3
          pubrt3(["public Route Table 3"])
          pubnacl3(["public Network ACL 3"])
        end
        subgraph private3
          pvtrt3(["private Route Table 3"])
          pvtnacl3(["private Network ACL 3"])
        end
        pvtrt3 ~~~~~ pubrt3
      end
      subgraph zone2
        subgraph public2
          pubrt2(["public Route Table 2"])
          pubnacl2(["public Network ACL 2"])
        end
        subgraph private2
          pvtrt2(["private Route Table 2"])
          pvtnacl2(["private Network ACL 2"])
        end
        pvtrt2 ~~~~~ pubrt2
      end
      subgraph zone1
        subgraph public1
          pubrt1(["public Route Table 1"])
          pubnacl1(["public Network ACL 1"])
          eip["Elastic IP"]
          natgw["NAT Gateway"]
          natgw -.- eip
        end
        subgraph private1
          pvtrt1(["private Route Table 1"])
          pvtnacl1(["private Network ACL 1"])
        end
        pvtrt1 ~~~~~ pubrt1
      end
      pvtrt1 -...->|"0.0.0.0/0"| natgw
      pvtrt2 -...->|"0.0.0.0/0"| natgw
      pvtrt3 -...->|"0.0.0.0/0"| natgw
      igw["Internet Gateway"]
      pubrt1 -...->|"0.0.0.0/0"| igw
      pubrt2 -...->|"0.0.0.0/0"| igw
      pubrt3 -...->|"0.0.0.0/0"| igw
      defrt(["default Route Table"])
      defnacl(["default Network ACL"])
      defsg(["default Security Group"])
    end
  end
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| aws_default_network_acl.this | resource |
| aws_default_route_table.this | resource |
| aws_default_security_group.this | resource |
| aws_eip.natgw | resource |
| aws_internet_gateway.this | resource |
| aws_nat_gateway.this | resource |
| aws_network_acl.private | resource |
| aws_network_acl.public | resource |
| aws_network_acl_association.private | resource |
| aws_network_acl_association.public | resource |
| aws_network_acl_rule.private_allow_all_egress | resource |
| aws_network_acl_rule.private_allow_all_ingress | resource |
| aws_network_acl_rule.public_allow_all_egress | resource |
| aws_network_acl_rule.public_allow_all_ingress | resource |
| aws_route.private_to_natgw | resource |
| aws_route.public_to_igw | resource |
| aws_route_table.private | resource |
| aws_route_table.public | resource |
| aws_route_table_association.private | resource |
| aws_route_table_association.public | resource |
| aws_subnet.private | resource |
| aws_subnet.public | resource |
| aws_vpc.this | resource |
| aws_availability_zones.available | data source |
| aws_partition.current | data source |
| aws_region.current | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zone_count"></a> [availability\_zone\_count](#input\_availability\_zone\_count) | The number of availability zones to use. | `number` | `3` | no |
| <a name="input_base_name"></a> [base\_name](#input\_base\_name) | The base name for the resources. | `string` | `"mynetwork"` | no |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | The CIDR block for the VPC. | `string` | `"10.0.0.0/16"` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Whether to enable DNS hostnames in the VPC. | `bool` | `true` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Whether to enable DNS support in the VPC. | `bool` | `true` | no |
| <a name="input_enable_network_address_usage_metrics"></a> [enable\_network\_address\_usage\_metrics](#input\_enable\_network\_address\_usage\_metrics) | Whether to enable network address usage metrics in the VPC. | `bool` | `true` | no |
| <a name="input_enable_resource_name_dns_a_record_on_launch"></a> [enable\_resource\_name\_dns\_a\_record\_on\_launch](#input\_enable\_resource\_name\_dns\_a\_record\_on\_launch) | Whether to enable resource name DNS A record on launch. | `bool` | `true` | no |
| <a name="input_instance_tenancy"></a> [instance\_tenancy](#input\_instance\_tenancy) | The instance tenancy for the VPC. | `string` | `"default"` | no |
| <a name="input_nat_gateway_allocation"></a> [nat\_gateway\_allocation](#input\_nat\_gateway\_allocation) | Type of NAT Gateway allocation. ("single" or "ha") | `string` | `"single"` | no |
| <a name="input_private_dns_hostname_type_on_launch"></a> [private\_dns\_hostname\_type\_on\_launch](#input\_private\_dns\_hostname\_type\_on\_launch) | The private DNS hostname type on launch. | `string` | `"ip-name"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_availability_zone_id_to_name"></a> [availability\_zone\_id\_to\_name](#output\_availability\_zone\_id\_to\_name) | A map of availability zone IDs to names. |
| <a name="output_availability_zone_ids_to_use"></a> [availability\_zone\_ids\_to\_use](#output\_availability\_zone\_ids\_to\_use) | The availability zone IDs to use. |
| <a name="output_availability_zone_name_to_id"></a> [availability\_zone\_name\_to\_id](#output\_availability\_zone\_name\_to\_id) | A map of availability zone names to IDs. |
| <a name="output_availability_zone_names_to_use"></a> [availability\_zone\_names\_to\_use](#output\_availability\_zone\_names\_to\_use) | The availability zone names to use. |
| <a name="output_az_id_to_private_subnet_id"></a> [az\_id\_to\_private\_subnet\_id](#output\_az\_id\_to\_private\_subnet\_id) | A map of availability zone IDs to private subnet IDs. |
| <a name="output_az_id_to_public_subnet_id"></a> [az\_id\_to\_public\_subnet\_id](#output\_az\_id\_to\_public\_subnet\_id) | A map of availability zone IDs to public subnet IDs. |
| <a name="output_default_route_table_id"></a> [default\_route\_table\_id](#output\_default\_route\_table\_id) | The ID of the default route table (not used) for the VPC |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | The ID of the Internet Gateway |
| <a name="output_nat_gateway_ids"></a> [nat\_gateway\_ids](#output\_nat\_gateway\_ids) | The IDs of the NAT Gateways |
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | The IDs of the private route tables |
| <a name="output_private_subnet_id_to_az_id"></a> [private\_subnet\_id\_to\_az\_id](#output\_private\_subnet\_id\_to\_az\_id) | A map of private subnet IDs to availability zone IDs. |
| <a name="output_private_subnet_ids"></a> [private\_subnet\_ids](#output\_private\_subnet\_ids) | The list of IDs of the private subnets. |
| <a name="output_public_route_table_ids"></a> [public\_route\_table\_ids](#output\_public\_route\_table\_ids) | The IDs of the public route tables |
| <a name="output_public_subnet_id_to_az_id"></a> [public\_subnet\_id\_to\_az\_id](#output\_public\_subnet\_id\_to\_az\_id) | A map of public subnet IDs to availability zone IDs. |
| <a name="output_public_subnet_ids"></a> [public\_subnet\_ids](#output\_public\_subnet\_ids) | The list of IDs of the public subnets. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
<!-- END_TF_DOCS -->
