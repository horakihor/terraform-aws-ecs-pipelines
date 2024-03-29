##############
# Create VPC #
##############

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr_block}"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = "${merge(map("Name", "${var.vpc_name}"), var.tags)}"
}
