###########################################
# Create Route Tables for Private Subnets #
###########################################

resource "aws_route_table" "private_subnets" {
  count  = "${var.private_subnets}"
  vpc_id = "${aws_vpc.vpc.id}"
  tags   = "${merge(map("Name", "${var.vpc_name}-private-${count.index+1}"), var.tags)}"
}

resource "aws_route_table_association" "private_subnets" {
  count          = "${var.private_subnets}"
  subnet_id      = "${element(aws_subnet.private_subnets.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.private_subnets.*.id, count.index)}"
}

resource "aws_route" "non_prod_nat" {
  count                  = "${var.private_subnets}"
  route_table_id         = "${element(aws_route_table.private_subnets.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.nat.*.id, count.index)}"
}

#########################################
# Create Route Table for Public Subnets #
#########################################

resource "aws_route_table" "public_subnets" {
  vpc_id = "${aws_vpc.vpc.id}"
  tags   = "${merge(map("Name", "${var.vpc_name}-public"), var.tags)}"
}

resource "aws_route_table_association" "public_subnets" {
  count          = "${var.public_subnets}"
  subnet_id      = "${element(aws_subnet.public_subnets.*.id, count.index)}"
  route_table_id = "${aws_route_table.public_subnets.id}"
}

resource "aws_route" "operational_public_internet" {
  route_table_id         = "${aws_route_table.public_subnets.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

######################################
# Create Route Table for data Subnets #
######################################

resource "aws_route_table" "data_subnets" {
  count  = "${var.data_subnets}"
  vpc_id = "${aws_vpc.vpc.id}"
  tags   = "${merge(map("Name", "${var.vpc_name}-data-${count.index+1}"), var.tags)}"
}

resource "aws_route_table_association" "data_subnets" {
  count          = "${var.data_subnets}"
  subnet_id      = "${element(aws_subnet.data_subnets.*.id, count.index)}"
  route_table_id = "${element(aws_route_table.data_subnets.*.id, count.index)}"
}

resource "aws_route" "prod_nat" {
  count                  = "${var.data_subnets}"
  route_table_id         = "${element(aws_route_table.data_subnets.*.id, count.index)}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${element(aws_nat_gateway.nat.*.id, count.index)}"
}
