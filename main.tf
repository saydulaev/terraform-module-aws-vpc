locals {
  // Fill in subnet object with additional attributes.
  _subnets = flatten(
    [for subnet in keys(var.subnets) :
      [for idx, cidr in var.subnets[subnet].cidrs :
        merge(
          {
            assign_ipv6_address_on_creation                = try(var.subnets[subnet].assign_ipv6_address_on_creation, false)
            enable_resource_name_dns_aaaa_record_on_launch = try(var.subnets[subnet].enable_resource_name_dns_aaaa_record_on_launch, false)
            enable_resource_name_dns_a_record_on_launch    = try(var.subnets[subnet].enable_resource_name_dns_a_record_on_launch, false)
            customer_owned_ipv4_pool                       = alltrue([try(var.subnets[subnet].outpost_arn, null), try(var.subnets[subnet].map_customer_owned_ip_on_launch, null)]) ? try(var.subnets[subnet].customer_owned_ipv4_pool, null) : null
            map_public_ip_on_launch                        = try(var.subnets[subnet].map_public_ip_on_launch, false)
            map_customer_owned_ip_on_launch                = alltrue([try(var.subnets[subnet].customer_owned_ipv4_pool, null), try(var.subnets[subnet].outpost_arn, null)]) ? try(var.subnets[subnet].map_customer_owned_ip_on_launch, null) : null
            outpost_arn                                    = alltrue([try(var.subnets[subnet].customer_owned_ipv4_pool, null), try(var.subnets[subnet].map_customer_owned_ip_on_launch, null)]) ? try(var.subnets[subnet].outpost_arn, null) : null
            enable_dns64                                   = try(var.subnets[subnet].enable_dns64, false)
            ipv6_native                                    = try(var.subnets[subnet].ipv6_native, false)
            private_dns_hostname_type_on_launch            = try(var.subnets[subnet].private_dns_hostname_type_on_launch, "ip-name")
            cidrs                                          = try(var.subnets[subnet].cidrs, [])
            create_nat_gw                                  = try(var.subnets[subnet].create_nat_gw, false)
            create_network_acl                             = try(var.subnets[subnet].create_network_acl, false)
            create_route_table_for_each_subnet             = try(var.subnets[subnet].create_route_table_for_each_subnet, false)
            create_route_table_for_subnet_group            = try(var.subnets[subnet].create_route_table_for_subnet_group, false)
            allow_nat_egress_internet                      = try(var.subnets[subnet].allow_nat_egress_internet, false)
            attach_transit_gateway                         = try(var.subnets[subnet].attach_transit_gateway, false)
            network_acl_id                                 = try(var.subnets[subnet].network_acl_id, null)
            // route_table_id                                 = try(var.subnets[subnet].route_table_id, null)
            nacl_rules = try(var.subnets[subnet].nacl_rules, [])
            cidrs      = var.subnets[subnet].cidrs
            route = {
              gateway_id                = try(var.subnets[subnet].route_gateway_id, null)
              nat_gateway_id            = try(var.subnets[subnet].route_nat_gateway_id, null)
              carrier_gateway_id        = try(var.subnets[subnet].route_carrier_gateway_id, null)
              local_gateway_id          = try(var.subnets[subnet].route_local_gateway_id, null)
              network_interface_id      = try(var.subnets[subnet].route_network_interface_id, null)
              vpc_endpoint_id           = try(var.subnets[subnet].route_vpc_endpoint_id, null)
              vpc_peering_connection_id = try(var.subnets[subnet].route_vpc_peering_connection_id, null)
              core_network_arn          = try(var.subnets[subnet].route_core_network_arn, null)
            }
            tags = try(var.subnets[subnet].tags, {})
          },
          { "name" = lower(format(
            "%s-%s-%s", var.name, replace(subnet, "_", "-"), idx))
            "cidr_block"        = cidr,
            "acl_group"         = format("%s-%s", var.name, subnet),
            "subnet_group"      = subnet,
            "route_table"       = format("%s-%s-%s", lower(var.name), replace(subnet, "_", "-"), idx)
            "availability_zone" = coalescelist(length(try(var.subnets[subnet].azs, [])) == length(try(var.subnets[subnet].cidrs, [])) ? var.subnets[subnet].azs : [], data.aws_availability_zones.available.names)[idx],
            "network_tier"      = try(var.subnets[subnet].map_public_ip_on_launch, false) ? "Public" : "Private",
          },
        )
      ]
    ]
  )

  subnets = { for s in local._subnets : s.cidr_block => s }

  // List of subnet that shoul be attached to Transit Gateway.
  subnets_attached_to_tg = compact([for s in local._subnets : try(s.attach_transit_gateway, false) ? s.cidr_block : ""])

  // Build list of ACL rule objects. 
  nacl_rules = flatten(
    [for subnet in keys(var.subnets) :
      [for idx, acl in var.subnets[subnet].nacl_rules : merge(acl,
        {
          "name"     = lower("${var.name}-${subnet}-${idx}"),
          "acl_name" = lower("${var.name}-${subnet}")
        })
      ] if try(var.subnets[subnet].create_network_acl, false) && length(try(var.subnets[subnet].nacl_rules, [])) > 0
    ]
  )

  // Find out all subnet where Nat Gateway will be installed.
  nat_gateway_public_subnets = { for subnet in local.subnets : subnet.availability_zone => subnet.cidr_block... if alltrue([subnet.map_public_ip_on_launch == true, subnet.create_nat_gw == true]) }

  // Find all subnets that should be use a nat-gateway for egress internet access through a nat-gateway.
  allow_egress_internet_subnets = distinct(compact([for subnet in local.subnets : alltrue(
    [
      try(subnet.map_public_ip_on_launch, false) == false,
      try(subnet.allow_nat_egress_internet, false) == true
  ]) ? subnet.cidr_block : ""]))
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "this" {
  cidr_block                           = var.cidr_block
  instance_tenancy                     = var.instance_tenancy
  ipv4_ipam_pool_id                    = var.ipv4_ipam_pool_id
  ipv4_netmask_length                  = var.ipv4_netmask_length
  ipv6_cidr_block                      = var.ipv6_cidr_block
  ipv6_ipam_pool_id                    = var.ipv6_ipam_pool_id
  ipv6_netmask_length                  = var.ipv6_netmask_length
  ipv6_cidr_block_network_border_group = var.ipv6_cidr_block_network_border_group
  assign_generated_ipv6_cidr_block     = var.assign_generated_ipv6_cidr_block
  enable_dns_support                   = var.enable_dns_support
  enable_dns_hostnames                 = var.enable_dns_hostnames

  tags = (merge(var.tags,
    tomap({ "Name" = var.name,
  "ManagedBy" = "Terraform" })))
}

# Subnets
resource "aws_subnet" "this" {
  for_each = local.subnets

  vpc_id                                         = aws_vpc.this.id
  cidr_block                                     = each.value.cidr_block
  availability_zone                              = each.value.availability_zone
  enable_resource_name_dns_a_record_on_launch    = each.value.enable_resource_name_dns_a_record_on_launch
  enable_resource_name_dns_aaaa_record_on_launch = each.value.enable_resource_name_dns_aaaa_record_on_launch
  map_customer_owned_ip_on_launch                = each.value.map_customer_owned_ip_on_launch
  assign_ipv6_address_on_creation                = each.value.assign_ipv6_address_on_creation
  customer_owned_ipv4_pool                       = each.value.customer_owned_ipv4_pool
  outpost_arn                                    = each.value.outpost_arn
  ipv6_native                                    = each.value.ipv6_native
  enable_dns64                                   = each.value.enable_dns64
  map_public_ip_on_launch                        = each.value.map_public_ip_on_launch
  private_dns_hostname_type_on_launch            = each.value.private_dns_hostname_type_on_launch

  tags = (merge(var.tags, each.value.tags,
    tomap({ "Name"             = each.value.name,
      "ManagedBy"              = "Terraform",
      "NetworkGroup"           = each.value.subnet_group,
      "DefaultRouteTable"      = each.value.route_table,
      "Tier"                   = each.value.network_tier,
      "AvailabilityZone"       = each.value.availability_zone,
      "TransitGatewayEndpoint" = each.value.attach_transit_gateway
    }),
  ))

  depends_on = [
    aws_vpc.this,
  ]

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }

  timeouts {
    create = "10m"
    delete = "20m"
  }
}

# Internet-gateway
resource "aws_internet_gateway" "this" {
  count  = var.create_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.this.id
  tags = (merge(var.tags,
    tomap({ "Name" = "${lower(var.name)}-igw",
  "ManagedBy" = "Terraform" })))

  depends_on = [
    aws_vpc.this
  ]

  timeouts {
    create = "20m"
    update = "20m"
    delete = "20m"
  }
}

resource "aws_default_route_table" "this" {
  count = var.create_default_route_table ? 1 : 0

  default_route_table_id = aws_vpc.this.default_route_table_id
  route                  = []

  tags = (merge(var.tags,
    tomap({ "Name" = "${lower(var.name)}-default",
  "ManagedBy" = "Terraform" })))

  depends_on = [
    aws_vpc.this
  ]
}

resource "aws_default_network_acl" "this" {
  count = var.create_default_network_acl ? 1 : 0

  default_network_acl_id = aws_vpc.this.default_network_acl_id
  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }
  tags = (merge(var.tags,
    tomap({ "Name" = "${lower(var.name)}-default-acl",
  "ManagedBy" = "Terraform" })))
  lifecycle {
    ignore_changes = [subnet_ids]
  }

  depends_on = [
    aws_vpc.this
  ]
}

resource "aws_default_security_group" "this" {
  count = var.create_default_security_group ? 1 : 0

  vpc_id = aws_vpc.this.id
  ingress {
    protocol  = -1
    self      = true
    from_port = 0
    to_port   = 0
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = (merge(var.tags,
    tomap({ "Name" = "${lower(var.name)}-default",
  "ManagedBy" = "Terraform" })))

  depends_on = [
    aws_vpc.this
  ]
}

# Elastic IP address.
resource "aws_eip" "this" {
  for_each = { for k, v in local.subnets : v.cidr_block => v if v.map_public_ip_on_launch && v.create_nat_gw }

  vpc = true
  tags = (merge(var.tags,
    tomap({
      "Name"         = each.value.name,
      "NetworkGroup" = each.value.subnet_group,
      "ManagedBy"    = "Terraform"
    }))
  )

  depends_on = [
    aws_vpc.this
  ]
}

resource "aws_nat_gateway" "this" {
  for_each = { for k, v in local.subnets : v.cidr_block => v if v.map_public_ip_on_launch && v.create_nat_gw }

  connectivity_type = each.value.map_public_ip_on_launch && each.value.create_nat_gw ? "public" : "private"
  subnet_id         = aws_subnet.this[each.value.cidr_block].id
  allocation_id     = each.value.map_public_ip_on_launch && each.value.create_nat_gw ? aws_eip.this[each.value.cidr_block].id : null
  tags = (merge(var.tags,
    tomap({ "Name"        = each.value.name,
      "Pluto:CostCenter"  = "Networking",
      "Pluto:Application" = "NatGateway",
      "Tier"              = each.value.network_tier,
      "AvailabilityZone"  = each.value.availability_zone,
  "ManagedBy" = "Terraform" })))

  depends_on = [
    aws_subnet.this,
    aws_eip.this
  ]
}

# NACLs
resource "aws_network_acl" "this" {
  for_each = toset(distinct(compact([for subnet in local.subnets : subnet.create_network_acl ? subnet.acl_group : ""])))

  vpc_id = aws_vpc.this.id

  tags = (merge(var.tags,
    tomap({ "Name" = each.value,
  "ManagedBy" = "Terraform" })))

  depends_on = [
    aws_vpc.this,
    aws_subnet.this
  ]
}

resource "aws_network_acl_rule" "this" {
  for_each = { for acl in local.nacl_rules : acl.name => acl }

  network_acl_id = aws_network_acl.this[each.value.acl_name].id
  rule_number    = each.value.rule_number
  egress         = each.value.egress
  protocol       = each.value.protocol
  rule_action    = each.value.rule_action
  cidr_block     = each.value.cidr_block
  from_port      = each.value.from_port
  to_port        = each.value.to_port
  icmp_type      = try(each.value.icmp_type, null)
  icmp_code      = try(each.value.icmp_code, null)

  depends_on = [
    aws_network_acl.this
  ]
}

resource "aws_network_acl_association" "this" {
  for_each       = { for subnet in local.subnets : subnet.cidr_block => subnet if try(subnet.create_network_acl, false) && (length(try(subnet.nacl_rules, [])) > 0 || subnet.network_acl_id != null) }
  network_acl_id = coalesce(aws_network_acl.this[each.value.acl_group].id, each.value.network_acl_id)
  subnet_id      = aws_subnet.this[each.value.cidr_block].id

  depends_on = [
    aws_subnet.this,
    aws_network_acl.this
  ]
}

# Route table
locals {
  subnet_rts = { for subnet in local.subnets : subnet.cidr_block => subnet if subnet.create_route_table_for_each_subnet }
}
resource "aws_route_table" "subnet" {
  for_each = local.subnet_rts

  vpc_id = aws_vpc.this.id

  tags = (merge(var.tags,
    tomap({
      "Name"          = each.value.name,
      "ManagedBy"     = "Terraform",
      "SubnetGroupRT" = "false"
    })
  ))

  depends_on = [
    aws_nat_gateway.this,
  ]

  timeouts {
    create = "5m"
    update = "5m"
    delete = "5m"
  }
}

locals {
  subnet_group_rts = distinct([for subnet in local.subnets : subnet.subnet_group if subnet.create_route_table_for_subnet_group == true])

  subnet_group_rt_cidrs = length(local.subnet_group_rts) > 0 ? flatten([for subnet in local.subnet_group_rts : var.subnets[subnet].cidrs]) : []
}

resource "aws_route_table" "subnet_group" {
  for_each = length(local.subnet_group_rts) > 0 ? toset(local.subnet_group_rts) : []

  vpc_id = aws_vpc.this.id

  tags = (merge(var.tags,
    tomap({
      "Name"          = "${var.name}-${each.key}",
      "ManagedBy"     = "Terraform",
      "SubnetGroupRT" = "true"
    })
  ))

  depends_on = [
    aws_nat_gateway.this,
  ]

  timeouts {
    create = "5m"
    update = "5m"
    delete = "5m"
  }
}

resource "aws_route" "gateway_route" {
  for_each = { for subnet in local.subnets : subnet.cidr_block => subnet if alltrue([subnet.create_route_table_for_each_subnet, subnet.map_public_ip_on_launch, var.create_internet_gateway]) }

  route_table_id         = aws_route_table.subnet[each.value.cidr_block].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = coalesce(one(aws_internet_gateway.this[*].id), each.value.route.gateway_id)

  depends_on = [
    aws_internet_gateway.this,
    aws_route_table.subnet,
  ]
}


locals {
  internet_gateway_route_group = length(local.subnet_group_rts) > 0 ? {
    for subnet_group in local.subnet_group_rts : subnet_group => var.subnets[subnet_group] if alltrue(
    [var.subnets[subnet_group].map_public_ip_on_launch, var.create_internet_gateway])
  } : {}
}

resource "aws_route" "gateway_route_group" {
  for_each = length(keys(local.internet_gateway_route_group)) > 0 ? local.internet_gateway_route_group : {}

  route_table_id         = aws_route_table.subnet_group[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = coalesce(one(aws_internet_gateway.this[*].id), try(each.value.route_gateway_id, ""))

  depends_on = [
    aws_internet_gateway.this,
    aws_route_table.subnet_group,
  ]
}

resource "aws_route" "nat_route" {
  for_each = { for subnet in local.subnets : subnet.cidr_block => subnet if subnet.create_route_table_for_each_subnet && contains(local.allow_egress_internet_subnets, subnet.cidr_block) }

  route_table_id         = aws_route_table.subnet[each.value.cidr_block].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = coalesce(aws_nat_gateway.this[element(local.nat_gateway_public_subnets[each.value.availability_zone], 0)].id, each.value.route.nat_gateway_id)

  depends_on = [
    aws_route_table.subnet,
    aws_nat_gateway.this
  ]
}

locals {
  nat_gateway_route_group = {
    for subnet_group in local.subnet_group_rts : subnet_group => var.subnets[subnet_group] if alltrue(
      [try(var.subnets[subnet_group].map_public_ip_on_launch, false) == false, try(var.subnets[subnet_group].allow_nat_egress_internet, false) == true]
    )
  }
}

resource "aws_route" "nat_route_group" {
  for_each = length(keys(local.nat_gateway_route_group)) > 0 ? local.nat_gateway_route_group : {}

  route_table_id         = aws_route_table.subnet_group[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = coalesce(aws_nat_gateway.this[element(local.nat_gateway_public_subnets["us-east-1a"], 0)].id, try(var.subnets[each.key].route_nat_gateway_id, ""))

  depends_on = [
    aws_route_table.subnet_group,
    aws_nat_gateway.this
  ]
}

locals {
  route_table_association = { for subnet in local.subnets : subnet.cidr_block => subnet if alltrue(
    [
      subnet.create_route_table_for_each_subnet == true,
      subnet.create_route_table_for_subnet_group == false,
    ]
  ) }
}

resource "aws_route_table_association" "this" {
  for_each = local.route_table_association

  subnet_id      = aws_subnet.this[each.value.cidr_block].id
  route_table_id = aws_route_table.subnet[each.value.cidr_block].id
  depends_on = [
    aws_subnet.this,
    aws_route_table.subnet,
  ]
}

locals {
  route_table_group_association = { for subnet in local.subnets : subnet.cidr_block => subnet if alltrue(
    [
      subnet.create_route_table_for_each_subnet == false,
      subnet.create_route_table_for_subnet_group == true,
      contains(local.subnet_group_rt_cidrs, subnet.cidr_block)
    ])
  }
}

resource "aws_route_table_association" "this_group" {
  for_each = local.route_table_group_association

  subnet_id      = aws_subnet.this[each.value.cidr_block].id
  route_table_id = aws_route_table.subnet_group[each.value.subnet_group].id

  depends_on = [
    aws_subnet.this,
    aws_route_table.subnet_group,
  ]
}
