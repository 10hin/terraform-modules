variable "base_name" {
  type        = string
  description = "The base name for the resources."
  default     = "mynetwork"
}

variable "availability_zone_count" {
  type        = number
  description = "The number of availability zones to use."
  default     = 3
}

variable "cidr_block" {
  type        = string
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "instance_tenancy" {
  type        = string
  description = "The instance tenancy for the VPC."
  default     = "default"
}

variable "enable_dns_support" {
  type        = bool
  description = "Whether to enable DNS support in the VPC."
  default     = true
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Whether to enable DNS hostnames in the VPC."
  default     = true
}

variable "enable_network_address_usage_metrics" {
  type        = bool
  description = "Whether to enable network address usage metrics in the VPC."
  default     = true
}

variable "enable_resource_name_dns_a_record_on_launch" {
  type        = bool
  description = "Whether to enable resource name DNS A record on launch."
  default     = true
}

variable "private_dns_hostname_type_on_launch" {
  type        = string
  description = "The private DNS hostname type on launch."
  default     = "ip-name"
}

variable "nat_gateway_allocation" {
  type        = string
  description = "Type of NAT Gateway allocation. (\"single\" or \"ha\")"
  default     = "single"
}
