#
# The union of all private subnets used across any app load balancers.
#
# Our VPC supports up to 16 unique private subnet zones, each with 4096 total
# IPs, indexed in the 3rd octet's upper 4 bits, i.e. 0-15 shifted left 4 bits.
#
# NOTE: This is the map of current known zones to index value.
#       THIS MAP MUST BE USED ANYWHERE A PRIVATE_SUBNET IS DEFINED, TO AVOID
#       WASTING BITS BY DUPLICATING ZONE INDEXES.
#
#     Zone       | Index | 3rd Octet
#     -----------+-------+----------
#     us-east-1a |     0 |         0
#     us-east-1b |     1 |        16
#     us-east-1c |     2 |        32
#     us-east-1d |     3 |        48
#

locals {
  private_subnets = {
    us_e_1a = {
      cidr = "10.7.0.0/20", # Subnet index 0 (0 << 4)
      zone = "us-east-1a",
      name = "US East 1a private"
    },
    us_e_1b = {
      cidr = "10.7.16.0/20", # Subnet index 1 (1 << 4)
      zone = "us-east-1b",
      name = "US East 1b private"
    },
    us_e_1c = {
      cidr = "10.7.32.0/20", # Subnet index 2 (2 << 4)
      zone = "us-east-1c",
      name = "US East 1c private"
    }
  }
}
