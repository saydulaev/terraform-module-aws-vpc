vpc = {
  name                 = "test"
  cidr_block           = "172.35.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Environment = "Prod"
  }
}

subnets = {
  "runners" = {
    enable_resource_name_dns_a_record_on_launch = true
    private_dns_hostname_type_on_launch         = "ip-name"
    list                                        = ["172.35.0.0/24", "172.35.1.0/24", "172.35.2.0/24"]
    tags                                        = {}
    create_nat_gw                               = false
    allow_egress_internet                       = true
    nacl_rules = [
      { rule_number = 200, egress = false, protocol = "tcp", rule_action = "allow", from_port = 443, to_port = 443, cidr_block = "172.35.0.0/16" },
      { rule_number = 201, egress = false, protocol = "tcp", rule_action = "allow", from_port = 80, to_port = 80, cidr_block = "172.35.0.0/16" },
      { rule_number = 202, egress = false, protocol = "tcp", rule_action = "allow", from_port = 8443, to_port = 8443, cidr_block = "172.35.0.0/16" },
      { rule_number = 203, egress = false, protocol = "tcp", rule_action = "allow", from_port = 8080, to_port = 8080, cidr_block = "172.35.0.0/16" },
      { rule_number = 204, egress = true, protocol = "-1", rule_action = "allow", from_port = 0, to_port = 65535, cidr_block = "172.35.0.0/16" },
      { rule_number = 205, egress = true, protocol = "-1", rule_action = "allow", from_port = 0, to_port = 65535, cidr_block = "0.0.0.0/0" },
    ]
  },
  "application" = {
    private_dns_hostname_type_on_launch = "ip-name"
    list                                = ["172.35.135.0/24", "172.35.136.0/24", "172.35.137.0/24"]
    tags                                = {}
    create_nat_gw                       = false
    allow_egress_internet               = true
    nacl_rules = [
      { rule_number = 200, egress = false, protocol = "tcp", rule_action = "allow", from_port = 443, to_port = 443, cidr_block = "172.35.0.0/16" },
      { rule_number = 201, egress = false, protocol = "tcp", rule_action = "allow", from_port = 80, to_port = 80, cidr_block = "172.35.0.0/16" },
      { rule_number = 202, egress = false, protocol = "tcp", rule_action = "allow", from_port = 8443, to_port = 8443, cidr_block = "172.35.0.0/16" },
      { rule_number = 203, egress = false, protocol = "tcp", rule_action = "allow", from_port = 8080, to_port = 8080, cidr_block = "172.35.0.0/16" },
    ]
  },
  "dmz" = {
    enable_resource_name_dns_a_record_on_launch = true
    map_public_ip_on_launch                     = true
    private_dns_hostname_type_on_launch         = "ip-name"
    list                                        = ["172.35.3.0/24", "172.35.4.0/24", "172.35.5.0/24"]
    tags                                        = {}
    create_nat_gw                               = true
    allow_egress_internet                       = false
    nacl_rules = [
      { rule_number = 200, egress = false, protocol = "-1", rule_action = "allow", from_port = 0, to_port = 65535, cidr_block = "172.35.0.0/16" },
      { rule_number = 201, egress = false, protocol = "-1", rule_action = "allow", from_port = 0, to_port = 65535, cidr_block = "0.0.0.0/0" },
      { rule_number = 202, egress = true, protocol = "-1", rule_action = "allow", from_port = 0, to_port = 65535, cidr_block = "172.35.0.0/16" },
      { rule_number = 203, egress = true, protocol = "-1", rule_action = "allow", from_port = 0, to_port = 65535, cidr_block = "0.0.0.0/0" },
    ]
  },
}
