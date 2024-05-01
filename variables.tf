variable "name" {
  type        = string
  description = "VPC name"
}

variable "cidr_block" {
  type        = string
  description = "The IPv4 CIDR block for the VPC."
  default     = null
}

variable "instance_tenancy" {
  type        = string
  description = "A tenancy option for instances launched into the VPC."
  default     = "default"
}

variable "ipv4_ipam_pool_id" {
  type        = number
  description = "The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR."
  default     = null
}

variable "ipv4_netmask_length" {
  type        = number
  description = <<EOF
    The netmask length of the IPv4 CIDR you want to allocate to this VPC.
    Requires specifying a ipv4_ipam_pool_id.
    EOF
  default     = null
}

variable "ipv6_cidr_block" {
  type        = string
  description = <<EOF
    IPv6 CIDR block to request from an IPAM Pool.
    Can be set explicitly or derived from IPAM using ipv6_netmask_length.
    EOF
  default     = null
}

variable "ipv6_ipam_pool_id" {
  type        = number
  description = <<EOF
    IPAM Pool ID for a IPv6 pool. Conflicts with assign_generated_ipv6_cidr_block.
    EOF
  default     = null
}

variable "ipv6_netmask_length" {
  type        = number
  description = <<EOF
    Netmask length to request from IPAM Pool.
    Conflicts with ipv6_cidr_block. 
    This can be omitted if IPAM pool as a allocation_default_netmask_length set.
    Valid values: 56.
    EOF
  default     = null
}

variable "ipv6_cidr_block_network_border_group" {
  type        = string
  description = <<EOF
    By default when an IPv6 CIDR is assigned to a VPC a default 
    ipv6_cidr_block_network_border_group will be set to the region of the VPC.
    This can be changed to restrict advertisement of public addresses to 
    specific Network Border Groups such as LocalZones.
    EOF
  default     = null
}

variable "enable_dns_support" {
  type        = bool
  description = "A boolean flag to enable/disable DNS support in the VPC. "
  default     = true
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "A boolean flag to enable/disable DNS hostnames in the VPC."
  default     = false
}

variable "assign_generated_ipv6_cidr_block" {
  type        = bool
  description = <<EOF
    Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC.
    You cannot specify the range of IP addresses, or the size of the CIDR block.
    Conflicts with ipv6_ipam_pool_id.
    EOF
  default     = null
}

variable "create_internet_gateway" {
  description = "Create Internet Gateway on VPC."
  type        = bool
  default     = true
}

variable "create_default_route_table" {
  description = "Create VPC default route table."
  type        = bool
  default     = true
}

variable "create_default_network_acl" {
  description = "Create VPC default network ACL."
  type        = bool
  default     = true
}

variable "create_default_security_group" {
  description = "Create VPC default security group."
  type        = bool
  default     = true
}

variable "subnets" {
  description = <<EOF
    Subnets it is an associative array, where each key there is
    a name of subnets group and value looks like as an object type below.
    EOF
  type = map(object({
    cidrs                                          = list(string)                // The IPv4 CIDR blocks for the subnets.
    azs                                            = optional(list(string))      // Availability zones where new subnet will be created. Number of zones have to be the same number as cidrs.
    enable_resource_name_dns_a_record_on_launch    = optional(bool, false)       //  Indicates whether to respond to DNS queries for instance hostnames with DNS A records.
    enable_resource_name_dns_aaaa_record_on_launch = optional(bool, false)       // Indicates whether to respond to DNS queries for instance hostnames with DNS AAAA records. 
    assign_ipv6_address_on_creation                = optional(bool, false)       // Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address.
    map_customer_owned_ip_on_launch                = optional(bool)              // Specify true to indicate that network interfaces created in the subnet should be assigned a customer owned IP address. The customer_owned_ipv4_pool and outpost_arn arguments must be specified when set to true.
    map_public_ip_on_launch                        = optional(bool, false)       // Specify true to indicate that instances launched into the subnet should be assigned a public IP address.
    customer_owned_ipv4_pool                       = optional(string)            // The customer owned IPv4 address pool. Typically used with the map_customer_owned_ip_on_launch argument. The outpost_arn argument must be specified when configured.
    outpost_arn                                    = optional(string)            // The Amazon Resource Name (ARN) of the Outpost.
    ipv6_native                                    = optional(bool, false)       // Indicates whether to create an IPv6-only subnet.
    private_dns_hostname_type_on_launch            = optional(string, "ip-name") // The type of hostnames to assign to instances in the subnet at launch. For IPv6-only subnets, an instance DNS name must be based on the instance ID. For dual-stack and IPv4-only subnets, you can specify whether DNS names use the instance IPv4 address or the instance ID. Valid values: ip-name, resource-name.
    enable_dns64                                   = optional(bool, false)       // Indicates whether DNS queries made to the Amazon-provided DNS Resolver in this subnet should return synthetic IPv6 addresses for IPv4-only destinations.
    create_nat_gw                                  = optional(bool, false)       // Define if create aws_nat_gateway entity in subnet or not. This behaviour depends on subnet parameter 'map_public_ip_on_launch' if it is true then will be deployed a public nat gateway, if it is false then will be deployed a private nat gateway.
    create_network_acl                             = optional(bool, false)       // Create a Network ACL for subnet group or not.
    create_route_table_for_each_subnet             = optional(bool, false)       // Will be created a Route Table for each subnet.
    create_route_table_for_subnet_group            = optional(bool, false)       // Create a one Route Table for all subnets in subnet group.
    allow_nat_egress_internet                      = optional(bool, false)       // Define if subnet allows to has access to egress internet traffic (through the public nat gateway). If nat gateway resource there is on the same AZ it will be used as target to route traffic '0.0.0.0/0'.
    attach_transit_gateway                         = optional(bool, false)       // Optional additional attribute, that will help to define which subnets woulb de attached to Transit Gateway.
    network_acl_id                                 = optional(string)            // Attach each subnet in subnet group to this Network ACL.
    route_table_id                                 = optional(string)            // Attach each subnet in subnet group to this Route Table
    nacl_rules = optional(list(object({                                          // Consists of element of resource 'aws_network_acl_rule'. https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule
      rule_number = number
      egress      = bool
      protocol    = string
      rule_action = string
      from_port   = number
      to_port     = number
      cidr_block  = string
    })), [])
    route_gateway_id                = optional(string) // Add route to Gateway ID in subnet default route table.
    route_nat_gateway_id            = optional(string) // Add route to Nat Gateway ID in subnet default route table.
    route_carrier_gateway_id        = optional(string) // Add route to Carrier gateway ID in subnet default route table.
    route_local_gateway_id          = optional(string) // Add route to Local gateway ID in subnet default route table.
    route_network_interface_id      = optional(string) // Add route to Network Interface ID in subnet default route table.
    route_vpc_endpoint_id           = optional(string) // Add route to VPC Endpoint ID in subnet default route table.
    route_vpc_peering_connection_id = optional(string) // Add route to VPC Peering connection ID in subnet default route table.
    route_core_network_arn          = optional(string) // Add route to Core Network ARN in subnet default route table.
    tags                            = optional(map(string))
  }))
}

variable "tags" {
  type        = map(any)
  description = "A map of tags to assign to the resource."
}

variable "enable_module_debug_console" {
  description = "Enable this variable allows to show module local vars from root module when use `terraform console` like this module.<<module_name>>.locals"
  type        = bool
  default     = true
}
