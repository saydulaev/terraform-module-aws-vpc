variable "vpcs" {
  type = object({
    name                 = string
    cidr_block           = string
    enable_dns_hostnames = bool
    enable_dns_support   = bool
    tags                 = map(any)
    subnets              = any
  })
}
