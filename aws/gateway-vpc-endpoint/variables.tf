variable "base_name" {
  type        = string
  description = "The base name for the resources."
  default     = "mynetwork"
}

variable "service_name" {
  type        = string
  description = "The name of the AWS service for the VPC endpoint (e.g., com.amazonaws.us-west-2.s3)."
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the endpoint will be created."
}

variable "route_table_ids" {
  type        = map(string)
  description = "Map of route table IDs (may be unknown at plan time) with arbitrary keys (must be known at plan time)."
}

variable "policy" {
  type        = string
  description = "The policy document for the VPC endpoint."
  default     = "{}"
}
