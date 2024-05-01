module "vpc" {
  source               = "git::ssh://git@github.com:saydulaev/terraform-module-aws-vpc.git?ref=main"
  name                 = var.vpcs.name
  cidr_block           = var.vpcs.cidr_block
  enable_dns_hostnames = var.vpcs.enable_dns_hostnames
  enable_dns_support   = var.vpcs.enable_dns_support
  tags = {
    "Environment" : "Prod"
  }
  subnets = var.vpcs.subnets
}
