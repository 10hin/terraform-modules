# `aws/interface-vpc-endpoint`

Create VPC Endpoint with type "Interface" and Security Group for it.

## Diagram

```mermaid
flowchart TB
  classDef dottedBorder stroke-dasharray: 2 2;
  subgraph vpc
    subgraph subnet1
      subgraph sg1["Security Group"]
        ep1(("EP"))
      end
    end
    class subnet1 dottedBorder;
    subgraph subnet2
      subgraph sg2["Security Group"]
        ep2(("EP"))
      end
    end
    class subnet2 dottedBorder;
    vpce["VPC Endpoint"]
    ep1 -.- vpce
    ep2 -.- vpce
  end
  sg1 -.- sg2
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
| aws_security_group.this | resource |
| aws_vpc_endpoint.this | resource |
| aws_vpc_endpoint_security_group_association.this | resource |
| aws_vpc_endpoint_subnet_association.this | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_base_name"></a> [base\_name](#input\_base\_name) | The base name for the resources. | `string` | `"mynetwork"` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | The policy document for the VPC endpoint. | `string` | `"{}"` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | The name of the AWS service for the VPC endpoint (e.g., com.amazonaws.us-west-2.s3). | `string` | n/a | yes |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Map of subnet IDs (may be unknown at plan time) with arbitrary keys (must be known at plan time). | `map(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC where the endpoint will be created. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | The ID of the security group created for the VPC endpoint. |
| <a name="output_vpc_endpoint_id"></a> [vpc\_endpoint\_id](#output\_vpc\_endpoint\_id) | The ID of the VPC endpoint created. |
<!-- END_TF_DOCS -->
