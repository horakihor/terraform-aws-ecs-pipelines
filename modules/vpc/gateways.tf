###########################
# Create Internet Gateway #
###########################

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags   = "${merge(map("Name", "${var.vpc_name}-igw"), var.tags)}"
}

#######################
# Create NAT Gateways #
#######################

resource "aws_eip" "nat" {
  count = "${var.public_subnets}"
  vpc   = true
  tags  = "${merge(map("Name", "${var.vpc_name}-nat-${count.index+1}"), var.tags)}"
}

resource "aws_nat_gateway" "nat" {
  count         = "${var.public_subnets}"
  allocation_id = "${element(aws_eip.nat.*.id, count.index)}"
  subnet_id     = "${element(aws_subnet.public_subnets.*.id, count.index)}"
  tags          = "${merge(map("Name", "${var.vpc_name}-nat-${count.index+1}"), var.tags)}"
}
