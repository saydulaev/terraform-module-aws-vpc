<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.33.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 3.3.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.33.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_default_network_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_network_acl) | resource |
| [aws_default_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_route_table) | resource |
| [aws_default_security_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_security_group) | resource |
| [aws_eip.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_network_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl) | resource |
| [aws_network_acl_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_association) | resource |
| [aws_network_acl_rule.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule) | resource |
| [aws_route.gateway_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.gateway_route_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.nat_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.nat_route_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.subnet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.this_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assign_generated_ipv6_cidr_block"></a> [assign\_generated\_ipv6\_cidr\_block](#input\_assign\_generated\_ipv6\_cidr\_block) | Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC.<br>    You cannot specify the range of IP addresses, or the size of the CIDR block.<br>    Conflicts with ipv6\_ipam\_pool\_id. | `bool` | `null` | no |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | The IPv4 CIDR block for the VPC. | `string` | `null` | no |
| <a name="input_create_default_network_acl"></a> [create\_default\_network\_acl](#input\_create\_default\_network\_acl) | Create VPC default network ACL. | `bool` | `true` | no |
| <a name="input_create_default_route_table"></a> [create\_default\_route\_table](#input\_create\_default\_route\_table) | Create VPC default route table. | `bool` | `true` | no |
| <a name="input_create_default_security_group"></a> [create\_default\_security\_group](#input\_create\_default\_security\_group) | Create VPC default security group. | `bool` | `true` | no |
| <a name="input_create_internet_gateway"></a> [create\_internet\_gateway](#input\_create\_internet\_gateway) | Create Internet Gateway on VPC. | `bool` | `true` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | A boolean flag to enable/disable DNS hostnames in the VPC. | `bool` | `false` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | A boolean flag to enable/disable DNS support in the VPC. | `bool` | `true` | no |
| <a name="input_enable_module_debug_console"></a> [enable\_module\_debug\_console](#input\_enable\_module\_debug\_console) | Enable this variable allows to show module local vars from root module when use `terraform console` like this module.<<module\_name>>.locals | `bool` | `true` | no |
| <a name="input_instance_tenancy"></a> [instance\_tenancy](#input\_instance\_tenancy) | A tenancy option for instances launched into the VPC. | `string` | `"default"` | no |
| <a name="input_ipv4_ipam_pool_id"></a> [ipv4\_ipam\_pool\_id](#input\_ipv4\_ipam\_pool\_id) | The ID of an IPv4 IPAM pool you want to use for allocating this VPC's CIDR. | `number` | `null` | no |
| <a name="input_ipv4_netmask_length"></a> [ipv4\_netmask\_length](#input\_ipv4\_netmask\_length) | The netmask length of the IPv4 CIDR you want to allocate to this VPC.<br>    Requires specifying a ipv4\_ipam\_pool\_id. | `number` | `null` | no |
| <a name="input_ipv6_cidr_block"></a> [ipv6\_cidr\_block](#input\_ipv6\_cidr\_block) | IPv6 CIDR block to request from an IPAM Pool.<br>    Can be set explicitly or derived from IPAM using ipv6\_netmask\_length. | `string` | `null` | no |
| <a name="input_ipv6_cidr_block_network_border_group"></a> [ipv6\_cidr\_block\_network\_border\_group](#input\_ipv6\_cidr\_block\_network\_border\_group) | By default when an IPv6 CIDR is assigned to a VPC a default <br>    ipv6\_cidr\_block\_network\_border\_group will be set to the region of the VPC.<br>    This can be changed to restrict advertisement of public addresses to <br>    specific Network Border Groups such as LocalZones. | `string` | `null` | no |
| <a name="input_ipv6_ipam_pool_id"></a> [ipv6\_ipam\_pool\_id](#input\_ipv6\_ipam\_pool\_id) | IPAM Pool ID for a IPv6 pool. Conflicts with assign\_generated\_ipv6\_cidr\_block. | `number` | `null` | no |
| <a name="input_ipv6_netmask_length"></a> [ipv6\_netmask\_length](#input\_ipv6\_netmask\_length) | Netmask length to request from IPAM Pool.<br>    Conflicts with ipv6\_cidr\_block. <br>    This can be omitted if IPAM pool as a allocation\_default\_netmask\_length set.<br>    Valid values: 56. | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | VPC name | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnets it is an associative array, where each key there is<br>    a name of subnets group and value looks like as an object type below. | <pre>map(object({<br>    cidrs                                          = list(string)                // The IPv4 CIDR blocks for the subnets.<br>    azs                                            = optional(list(string))      // Availability zones where new subnet will be created. Number of zones have to be the same number as cidrs.<br>    enable_resource_name_dns_a_record_on_launch    = optional(bool, false)       //  Indicates whether to respond to DNS queries for instance hostnames with DNS A records.<br>    enable_resource_name_dns_aaaa_record_on_launch = optional(bool, false)       // Indicates whether to respond to DNS queries for instance hostnames with DNS AAAA records. <br>    assign_ipv6_address_on_creation                = optional(bool, false)       // Specify true to indicate that network interfaces created in the specified subnet should be assigned an IPv6 address.<br>    map_customer_owned_ip_on_launch                = optional(bool)              // Specify true to indicate that network interfaces created in the subnet should be assigned a customer owned IP address. The customer_owned_ipv4_pool and outpost_arn arguments must be specified when set to true.<br>    map_public_ip_on_launch                        = optional(bool, false)       // Specify true to indicate that instances launched into the subnet should be assigned a public IP address.<br>    customer_owned_ipv4_pool                       = optional(string)            // The customer owned IPv4 address pool. Typically used with the map_customer_owned_ip_on_launch argument. The outpost_arn argument must be specified when configured.<br>    outpost_arn                                    = optional(string)            // The Amazon Resource Name (ARN) of the Outpost.<br>    ipv6_native                                    = optional(bool, false)       // Indicates whether to create an IPv6-only subnet.<br>    private_dns_hostname_type_on_launch            = optional(string, "ip-name") // The type of hostnames to assign to instances in the subnet at launch. For IPv6-only subnets, an instance DNS name must be based on the instance ID. For dual-stack and IPv4-only subnets, you can specify whether DNS names use the instance IPv4 address or the instance ID. Valid values: ip-name, resource-name.<br>    enable_dns64                                   = optional(bool, false)       // Indicates whether DNS queries made to the Amazon-provided DNS Resolver in this subnet should return synthetic IPv6 addresses for IPv4-only destinations.<br>    create_nat_gw                                  = optional(bool, false)       // Define if create aws_nat_gateway entity in subnet or not. This behaviour depends on subnet parameter 'map_public_ip_on_launch' if it is true then will be deployed a public nat gateway, if it is false then will be deployed a private nat gateway.<br>    create_network_acl                             = optional(bool, false)       // Create a Network ACL for subnet group or not.<br>    create_route_table_for_each_subnet             = optional(bool, false)       // Will be created a Route Table for each subnet.<br>    create_route_table_for_subnet_group            = optional(bool, false)       // Create a one Route Table for all subnets in subnet group.<br>    allow_nat_egress_internet                      = optional(bool, false)       // Define if subnet allows to has access to egress internet traffic (through the public nat gateway). If nat gateway resource there is on the same AZ it will be used as target to route traffic '0.0.0.0/0'.<br>    attach_transit_gateway                         = optional(bool, false)       // Optional additional attribute, that will help to define which subnets woulb de attached to Transit Gateway.<br>    network_acl_id                                 = optional(string)            // Attach each subnet in subnet group to this Network ACL.<br>    route_table_id                                 = optional(string)            // Attach each subnet in subnet group to this Route Table<br>    nacl_rules = optional(list(object({                                          // Consists of element of resource 'aws_network_acl_rule'. https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/network_acl_rule<br>      rule_number = number<br>      egress      = bool<br>      protocol    = string<br>      rule_action = string<br>      from_port   = number<br>      to_port     = number<br>      cidr_block  = string<br>    })), [])<br>    route_gateway_id                = optional(string) // Add route to Gateway ID in subnet default route table.<br>    route_nat_gateway_id            = optional(string) // Add route to Nat Gateway ID in subnet default route table.<br>    route_carrier_gateway_id        = optional(string) // Add route to Carrier gateway ID in subnet default route table.<br>    route_local_gateway_id          = optional(string) // Add route to Local gateway ID in subnet default route table.<br>    route_network_interface_id      = optional(string) // Add route to Network Interface ID in subnet default route table.<br>    route_vpc_endpoint_id           = optional(string) // Add route to VPC Endpoint ID in subnet default route table.<br>    route_vpc_peering_connection_id = optional(string) // Add route to VPC Peering connection ID in subnet default route table.<br>    route_core_network_arn          = optional(string) // Add route to Core Network ARN in subnet default route table.<br>    tags                            = optional(map(string))<br>  }))</pre> | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resource. | `map(any)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_attributes"></a> [attributes](#output\_attributes) | All VPC attributes. |
| <a name="output_default_network_acl"></a> [default\_network\_acl](#output\_default\_network\_acl) | All default Network ACL attributes. |
| <a name="output_default_network_acl_arn"></a> [default\_network\_acl\_arn](#output\_default\_network\_acl\_arn) | ARN of the Default Network ACL. |
| <a name="output_default_network_acl_id"></a> [default\_network\_acl\_id](#output\_default\_network\_acl\_id) | ID of the Default Network ACL. |
| <a name="output_default_network_acl_owner_id"></a> [default\_network\_acl\_owner\_id](#output\_default\_network\_acl\_owner\_id) | ID of the AWS account that owns the Default Network ACL. |
| <a name="output_default_network_acl_tags_all"></a> [default\_network\_acl\_tags\_all](#output\_default\_network\_acl\_tags\_all) | A map of tags assigned to the resource. |
| <a name="output_default_network_acl_vpc_id"></a> [default\_network\_acl\_vpc\_id](#output\_default\_network\_acl\_vpc\_id) | ID of the associated VPC. |
| <a name="output_default_route_table_id"></a> [default\_route\_table\_id](#output\_default\_route\_table\_id) | VPC default route table ID. |
| <a name="output_default_security_group"></a> [default\_security\_group](#output\_default\_security\_group) | All attributes of default SG. |
| <a name="output_default_security_group_arn"></a> [default\_security\_group\_arn](#output\_default\_security\_group\_arn) | ARN of the security group. |
| <a name="output_default_security_group_description"></a> [default\_security\_group\_description](#output\_default\_security\_group\_description) | Description of the security group. |
| <a name="output_default_security_group_id"></a> [default\_security\_group\_id](#output\_default\_security\_group\_id) | ID of the security group. |
| <a name="output_default_security_group_name"></a> [default\_security\_group\_name](#output\_default\_security\_group\_name) | Name of the security group. |
| <a name="output_default_security_group_owner_id"></a> [default\_security\_group\_owner\_id](#output\_default\_security\_group\_owner\_id) | Owner ID. |
| <a name="output_default_security_group_tags_all"></a> [default\_security\_group\_tags\_all](#output\_default\_security\_group\_tags\_all) | A map of tags assigned to the resource. |
| <a name="output_eip_allocation_id"></a> [eip\_allocation\_id](#output\_eip\_allocation\_id) | ID that AWS assigns to represent the allocation of <br>    the Elastic IP address for use with instances in a VPC. |
| <a name="output_eip_association_id"></a> [eip\_association\_id](#output\_eip\_association\_id) | ID representing the association of the address with an instance in a VPC. |
| <a name="output_eip_carrier_ip"></a> [eip\_carrier\_ip](#output\_eip\_carrier\_ip) | Carrier IP address. |
| <a name="output_eip_customer_owned_ip"></a> [eip\_customer\_owned\_ip](#output\_eip\_customer\_owned\_ip) | Customer owned IP. |
| <a name="output_eip_domain"></a> [eip\_domain](#output\_eip\_domain) | Indicates if this EIP is for use in VPC (vpc) or EC2 Classic (standard). |
| <a name="output_eip_id"></a> [eip\_id](#output\_eip\_id) | Contains the EIP allocation ID. |
| <a name="output_eip_private_dns"></a> [eip\_private\_dns](#output\_eip\_private\_dns) | The Private DNS associated with the Elastic IP address (if in VPC). |
| <a name="output_eip_private_ip"></a> [eip\_private\_ip](#output\_eip\_private\_ip) | Contains the private IP address (if in VPC). |
| <a name="output_eip_public_dns"></a> [eip\_public\_dns](#output\_eip\_public\_dns) | Public DNS associated with the Elastic IP address. |
| <a name="output_eip_public_ip"></a> [eip\_public\_ip](#output\_eip\_public\_ip) | Contains the public IP address. |
| <a name="output_eip_tags_all"></a> [eip\_tags\_all](#output\_eip\_tags\_all) | A map of tags assigned to the resource. |
| <a name="output_eips"></a> [eips](#output\_eips) | #### EIP |
| <a name="output_internet_gateway"></a> [internet\_gateway](#output\_internet\_gateway) | All Internet gateway attributes. |
| <a name="output_internet_gateway_arn"></a> [internet\_gateway\_arn](#output\_internet\_gateway\_arn) | The ARN of the Internet Gateway. |
| <a name="output_internet_gateway_id"></a> [internet\_gateway\_id](#output\_internet\_gateway\_id) | The ID of the Internet Gateway. |
| <a name="output_internet_gateway_owner_id"></a> [internet\_gateway\_owner\_id](#output\_internet\_gateway\_owner\_id) | The ID of the AWS account that owns the internet gateway. |
| <a name="output_internet_gateway_tags_all"></a> [internet\_gateway\_tags\_all](#output\_internet\_gateway\_tags\_all) | A map of tags assigned to the resource. |
| <a name="output_local_allow_egress_internet_subnets"></a> [local\_allow\_egress\_internet\_subnets](#output\_local\_allow\_egress\_internet\_subnets) | n/a |
| <a name="output_locals_debug"></a> [locals\_debug](#output\_locals\_debug) | For debug purposes lookup from parent module to<br>    child locals.<br>    `terraform console`<br>    module.aws\_vpc\_infra.locals["allow\_egress\_internet\_subnets"] |
| <a name="output_nat_gateways"></a> [nat\_gateways](#output\_nat\_gateways) | All nat gateway full output |
| <a name="output_network_acl"></a> [network\_acl](#output\_network\_acl) | Network acl's all attributes. |
| <a name="output_network_acl_arn"></a> [network\_acl\_arn](#output\_network\_acl\_arn) | The ARN of the network ACL. |
| <a name="output_network_acl_association_id"></a> [network\_acl\_association\_id](#output\_network\_acl\_association\_id) | The ID of the network ACL association. |
| <a name="output_network_acl_id"></a> [network\_acl\_id](#output\_network\_acl\_id) | The ID of the network ACL. |
| <a name="output_network_acl_owner_id"></a> [network\_acl\_owner\_id](#output\_network\_acl\_owner\_id) | The ID of the AWS account that owns the network ACL. |
| <a name="output_network_acl_rule_id"></a> [network\_acl\_rule\_id](#output\_network\_acl\_rule\_id) | The ID of the network ACL Rule. |
| <a name="output_network_acl_tags_all"></a> [network\_acl\_tags\_all](#output\_network\_acl\_tags\_all) | A map of tags assigned to the resource. |
| <a name="output_route_table_arn"></a> [route\_table\_arn](#output\_route\_table\_arn) | The ARN of the route table. |
| <a name="output_route_table_association"></a> [route\_table\_association](#output\_route\_table\_association) | All route table association all attributes. |
| <a name="output_route_table_groups"></a> [route\_table\_groups](#output\_route\_table\_groups) | Route tables from subnet groups. |
| <a name="output_route_table_id"></a> [route\_table\_id](#output\_route\_table\_id) | The ID of the routing table. |
| <a name="output_route_table_owner_id"></a> [route\_table\_owner\_id](#output\_route\_table\_owner\_id) | The ID of the AWS account that owns the route table. |
| <a name="output_route_table_tags_all"></a> [route\_table\_tags\_all](#output\_route\_table\_tags\_all) | A map of tags assigned to the resource. |
| <a name="output_route_tables"></a> [route\_tables](#output\_route\_tables) | All route table attributes. |
| <a name="output_routes"></a> [routes](#output\_routes) | All route tables |
| <a name="output_subnet_arn"></a> [subnet\_arn](#output\_subnet\_arn) | Subnet ARN. |
| <a name="output_subnet_groups"></a> [subnet\_groups](#output\_subnet\_groups) | All subnets with all attributes. |
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | Subnet ID. |
| <a name="output_subnet_owner_id"></a> [subnet\_owner\_id](#output\_subnet\_owner\_id) | Subnet owner ID. |
| <a name="output_subnet_tags"></a> [subnet\_tags](#output\_subnet\_tags) | Subnet all tags. |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | All subnets with all attributes. |
| <a name="output_transit_gateway_attached_subnet_ids"></a> [transit\_gateway\_attached\_subnet\_ids](#output\_transit\_gateway\_attached\_subnet\_ids) | Subnets wich has an attribute 'attach\_transit\_gateway' set to true. |
| <a name="output_vpc_arn"></a> [vpc\_arn](#output\_vpc\_arn) | Amazon Resource Name (ARN) of VPC |
| <a name="output_vpc_default_network_acl_id"></a> [vpc\_default\_network\_acl\_id](#output\_vpc\_default\_network\_acl\_id) | The ID of the network ACL created by default on VPC creation |
| <a name="output_vpc_default_route_table_id"></a> [vpc\_default\_route\_table\_id](#output\_vpc\_default\_route\_table\_id) | The ID of the route table created by default on VPC creation |
| <a name="output_vpc_default_security_group_id"></a> [vpc\_default\_security\_group\_id](#output\_vpc\_default\_security\_group\_id) | The ID of the security group created by default on VPC creation |
| <a name="output_vpc_enable_dns_hostnames"></a> [vpc\_enable\_dns\_hostnames](#output\_vpc\_enable\_dns\_hostnames) | Whether or not the VPC has DNS hostname support |
| <a name="output_vpc_enable_dns_support"></a> [vpc\_enable\_dns\_support](#output\_vpc\_enable\_dns\_support) | Whether or not the VPC has DNS support |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vpc_instance_tenancy"></a> [vpc\_instance\_tenancy](#output\_vpc\_instance\_tenancy) | Tenancy of instances spin up within VPC. |
| <a name="output_vpc_main_route_table_id"></a> [vpc\_main\_route\_table\_id](#output\_vpc\_main\_route\_table\_id) | The ID of the main route table associated with this VPC. |
| <a name="output_vpc_owner_id"></a> [vpc\_owner\_id](#output\_vpc\_owner\_id) | The ID of the AWS account that owns the VPC. |
| <a name="output_vpc_tags_all"></a> [vpc\_tags\_all](#output\_vpc\_tags\_all) | A map of tags assigned to the resource |
<!-- END_TF_DOCS -->