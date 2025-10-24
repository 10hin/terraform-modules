# `aws/gateway-vpc-endpoint`

Create VPC Endpoint with type "Gateway".

## Diagram

```mermaid
flowchart TB
  classDef dottedBorder stroke-dasharray: 2 2;
  subgraph vpc
    subgraph subnet1
      rt1(["Route Table 1"])
      class rt1 dottedBorder;
    end
    class subnet1 dottedBorder;
    subgraph subnet2
      rt2(["Route Table 2"])
      class rt2 dottedBorder;
    end
    class subnet2 dottedBorder;
    vpce["VPC Endpoint"]
    rt1 -...-> vpce
    rt2 -...-> vpce
  end
  class vpc dottedBorder;
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
| aws_vpc_endpoint.this | resource |
| aws_vpc_endpoint_route_table_association.this | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_base_name"></a> [base\_name](#input\_base\_name) | The base name for the resources. | `string` | `"mynetwork"` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | The policy document for the VPC endpoint. | `string` | `"{}"` | no |
| <a name="input_route_table_ids"></a> [route\_table\_ids](#input\_route\_table\_ids) | Map of route table IDs (may be unknown at plan time) with arbitrary keys (must be known at plan time). | `map(string)` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | The name of the AWS service for the VPC endpoint (e.g., com.amazonaws.us-west-2.s3). | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC where the endpoint will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_prefix_list_id"></a> [prefix\_list\_id](#output\_prefix\_list\_id) | The prefix list ID associated with the VPC endpoint. |
| <a name="output_vpc_endpoint_id"></a> [vpc\_endpoint\_id](#output\_vpc\_endpoint\_id) | The ID of the VPC endpoint created. |
<!-- END_TF_DOCS -->
