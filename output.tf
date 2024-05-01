output "attributes" {
  description = "All VPC attributes."
  value       = aws_vpc.this
}

output "vpc_arn" {
  description = "Amazon Resource Name (ARN) of VPC"
  value       = aws_vpc.this.arn
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_instance_tenancy" {
  description = "Tenancy of instances spin up within VPC."
  value       = aws_vpc.this.instance_tenancy
}

output "vpc_enable_dns_support" {
  description = "Whether or not the VPC has DNS support"
  value       = aws_vpc.this.enable_dns_support
}

output "vpc_enable_dns_hostnames" {
  description = " Whether or not the VPC has DNS hostname support"
  value       = aws_vpc.this.enable_dns_hostnames
}

output "vpc_main_route_table_id" {
  description = "The ID of the main route table associated with this VPC."
  value       = aws_vpc.this.main_route_table_id
}

output "vpc_default_network_acl_id" {
  description = "The ID of the network ACL created by default on VPC creation"
  value       = aws_vpc.this.default_network_acl_id
}

output "vpc_default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = aws_vpc.this.default_security_group_id
}

output "vpc_default_route_table_id" {
  description = "The ID of the route table created by default on VPC creation"
  value       = aws_vpc.this.default_route_table_id
}

output "vpc_owner_id" {
  description = "The ID of the AWS account that owns the VPC."
  value       = aws_vpc.this.owner_id
}

output "vpc_tags_all" {
  description = "A map of tags assigned to the resource"
  value       = aws_vpc.this.tags_all
}

##### Subnet
output "subnets" {
  description = "All subnets with all attributes."
  value       = values(aws_subnet.this)[*]
}

output "subnet_groups" {
  description = "All subnets with all attributes."
  value = [for subnet in local.subnets : merge(
    aws_subnet.this[subnet.cidr_block],
    {
      subnet_group = subnet.subnet_group
    }
  )]
}

output "route_table_groups" {
  description = "Route tables from subnet groups."
  value = [for subnet in local.subnets : merge(
    aws_route_table.subnet[subnet.cidr_block],
    {
      subnet_group = subnet.subnet_group
    }) if alltrue([subnet.create_route_table_for_each_subnet == true, subnet.create_route_table_for_subnet_group == false])
  ]
}

output "transit_gateway_attached_subnet_ids" {
  description = "Subnets wich has an attribute 'attach_transit_gateway' set to true."
  value       = compact([for k, v in aws_subnet.this : lookup(v.tags_all, "TransitGatewayEndpoint", false) ? v.id : ""])
}

output "subnet_id" {
  description = "Subnet ID."
  value       = values(aws_subnet.this)[*].id
}

output "subnet_arn" {
  description = "Subnet ARN."
  value       = values(aws_subnet.this)[*].arn
}

output "subnet_owner_id" {
  description = "Subnet owner ID."
  value       = values(aws_subnet.this)[*].owner_id
}

output "subnet_tags" {
  description = "Subnet all tags."
  value       = values(aws_subnet.this)[*].tags_all
}

##### Default Security group
output "default_security_group" {
  description = "All attributes of default SG."
  value       = one(aws_default_security_group.this[*])
}

output "default_security_group_id" {
  description = "ID of the security group."
  value       = one(aws_default_security_group.this[*].id)
}

output "default_security_group_arn" {
  description = "ARN of the security group."
  value       = one(aws_default_security_group.this[*].arn)
}

output "default_security_group_description" {
  description = "Description of the security group."
  value       = one(aws_default_security_group.this[*].description)
}

output "default_security_group_name" {
  description = "Name of the security group."
  value       = one(aws_default_security_group.this[*].name)
}

output "default_security_group_owner_id" {
  description = "Owner ID."
  value       = one(aws_default_security_group.this[*].owner_id)
}

output "default_security_group_tags_all" {
  description = "A map of tags assigned to the resource."
  value       = one(aws_default_security_group.this[*].tags_all)
}

##### Internet gateway
output "internet_gateway" {
  description = "All Internet gateway attributes."
  value       = one(aws_internet_gateway.this[*])
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway."
  value       = one(aws_internet_gateway.this[*].id)
}

output "internet_gateway_arn" {
  description = "The ARN of the Internet Gateway."
  value       = one(aws_internet_gateway.this[*].arn)
}

output "internet_gateway_owner_id" {
  description = "The ID of the AWS account that owns the internet gateway."
  value       = one(aws_internet_gateway.this[*].owner_id)
}

output "internet_gateway_tags_all" {
  description = "A map of tags assigned to the resource."
  value       = one(aws_internet_gateway.this[*].tags_all)
}

##### EIP
output "eips" {
  value = values(aws_eip.this)[*]
}

output "eip_allocation_id" {
  value       = values(aws_eip.this)[*].allocation_id
  description = <<EOF
    ID that AWS assigns to represent the allocation of 
    the Elastic IP address for use with instances in a VPC.
    EOF
}

output "eip_association_id" {
  value       = values(aws_eip.this)[*].association_id
  description = "ID representing the association of the address with an instance in a VPC."
}

output "eip_carrier_ip" {
  value       = values(aws_eip.this)[*].carrier_ip
  description = "Carrier IP address."
}

output "eip_customer_owned_ip" {
  value       = values(aws_eip.this)[*].customer_owned_ip
  description = "Customer owned IP."
}

output "eip_domain" {
  value       = values(aws_eip.this)[*].domain
  description = "Indicates if this EIP is for use in VPC (vpc) or EC2 Classic (standard)."
}

output "eip_private_dns" {
  value       = values(aws_eip.this)[*].private_dns
  description = "The Private DNS associated with the Elastic IP address (if in VPC)."
}

output "eip_id" {
  value       = values(aws_eip.this)[*].id
  description = "Contains the EIP allocation ID."
}

output "eip_private_ip" {
  value       = values(aws_eip.this)[*].private_ip
  description = "Contains the private IP address (if in VPC)."
}

output "eip_public_dns" {
  value       = values(aws_eip.this)[*].public_dns
  description = "Public DNS associated with the Elastic IP address."
}

output "eip_public_ip" {
  value       = values(aws_eip.this)[*].public_ip
  description = "Contains the public IP address."
}

output "eip_tags_all" {
  value       = values(aws_eip.this)[*].tags_all
  description = "A map of tags assigned to the resource."
}

##### NAT gateway public
output "nat_gateways" {
  description = "All nat gateway full output"
  value       = values(aws_nat_gateway.this)[*]
}

##### Routing
output "route_tables" {
  description = "All route table attributes."
  value = concat(
    values(aws_route_table.subnet)[*],
  values(aws_route_table.subnet_group)[*])
}

output "default_route_table_id" {
  description = "VPC default route table ID."
  value       = one(aws_default_route_table.this[*].id)
}

output "route_table_id" {
  description = "The ID of the routing table."
  value = concat(
    values(aws_route_table.subnet)[*].id,
  values(aws_route_table.subnet_group)[*].id)
}

output "route_table_arn" {
  description = "The ARN of the route table."
  value = concat(
    values(aws_route_table.subnet)[*].arn,
  values(aws_route_table.subnet_group)[*].arn)
}

output "route_table_owner_id" {
  description = "The ID of the AWS account that owns the route table."
  value = concat(
    values(aws_route_table.subnet)[*].owner_id,
  values(aws_route_table.subnet_group)[*].owner_id)
}

output "route_table_tags_all" {
  description = " A map of tags assigned to the resource."
  value       = values(aws_route_table.subnet)[*].tags_all
}

output "routes" {
  description = "All route tables"
  value = concat(
    values(aws_route.gateway_route)[*],
    values(aws_route.nat_route)[*],
    values(aws_route.gateway_route_group)[*],
  values(aws_route.nat_route_group)[*])
}

output "route_table_association" {
  description = "All route table association all attributes."
  value = concat(
    values(aws_route_table_association.this)[*],
  values(aws_route_table_association.this_group)[*])
}

##### ACL
output "default_network_acl" {
  description = "All default Network ACL attributes."
  value       = one(aws_default_network_acl.this[*])
}

output "default_network_acl_id" {
  description = "ID of the Default Network ACL."
  value       = one(aws_default_network_acl.this[*].id)
}

output "default_network_acl_arn" {
  description = "ARN of the Default Network ACL."
  value       = one(aws_default_network_acl.this[*].arn)
}

output "default_network_acl_owner_id" {
  description = "ID of the AWS account that owns the Default Network ACL."
  value       = one(aws_default_network_acl.this[*].owner_id)
}

output "default_network_acl_tags_all" {
  description = "A map of tags assigned to the resource."
  value       = one(aws_default_network_acl.this[*].tags_all)
}

output "default_network_acl_vpc_id" {
  description = "ID of the associated VPC."
  value       = one(aws_default_network_acl.this[*].vpc_id)
}

output "network_acl" {
  description = "Network acl's all attributes."
  value       = values(aws_network_acl.this)[*]
}

output "network_acl_id" {
  description = "The ID of the network ACL."
  value       = values(aws_network_acl.this)[*].id
}

output "network_acl_arn" {
  description = "The ARN of the network ACL."
  value       = values(aws_network_acl.this)[*].arn
}

output "network_acl_owner_id" {
  description = "The ID of the AWS account that owns the network ACL."
  value       = values(aws_network_acl.this)[*].owner_id
}

output "network_acl_tags_all" {
  description = "A map of tags assigned to the resource."
  value       = values(aws_network_acl.this)[*].tags_all
}

output "network_acl_association_id" {
  description = "The ID of the network ACL association."
  value       = values(aws_network_acl_association.this)[*].id
}

output "network_acl_rule_id" {
  description = "The ID of the network ACL Rule."
  value       = values(aws_network_acl_rule.this)[*].id
}

###### Debug module
output "locals_debug" {
  description = <<EOT
    For debug purposes lookup from parent module to
    child locals.
    `terraform console`
    module.aws_vpc_infra.locals["allow_egress_internet_subnets"]
    EOT
  value = var.enable_module_debug_console ? {
    _subnets                      = local._subnets
    subnets                       = local.subnets
    allow_egress_internet_subnets = local.allow_egress_internet_subnets
    nat_gateway_public_subnets    = local.nat_gateway_public_subnets
    nacl_rules                    = local.nacl_rules
    subnets_attached_to_tg        = local.subnets_attached_to_tg
    ipv6_ipam_pool_id_null        = null
    ipv6_ipam_pool_id             = "some_ipam_pool_id"
  } : null
}

output "local_allow_egress_internet_subnets" {
  value = local.allow_egress_internet_subnets
}