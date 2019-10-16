##################
# Create Subnets #
##################

# Select random availability_zones
data "aws_availability_zones" "all" {}

resource "random_shuffle" "availability_zone" {
  input        = ["${data.aws_availability_zones.all.names}"]
  result_count = "${var.availability_zones_count}"
}

resource "aws_subnet" "private_subnets" {
  count                   = "${var.private_subnets}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet("${var.vpc_cidr_block}", 8, "${count.index+1}")}"
  availability_zone       = "${element(random_shuffle.availability_zone.result, "${count.index}")}"
  map_public_ip_on_launch = false
  tags                    = "${merge(map("Name", "${var.vpc_name}-private-${count.index+1}"), var.tags)}"
}

resource "aws_subnet" "public_subnets" {
  count                   = "${var.public_subnets}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet("${var.vpc_cidr_block}", 8, "${count.index + var.private_subnets + 1}")}"
  availability_zone       = "${element(random_shuffle.availability_zone.result, "${count.index}")}"
  map_public_ip_on_launch = false
  tags                    = "${merge(map("Name", "${var.vpc_name}-public-${count.index+1}"), var.tags)}"
}

resource "aws_subnet" "data_subnets" {
  count                   = "${var.data_subnets}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${cidrsubnet("${var.vpc_cidr_block}", 8, "${count.index + var.private_subnets + var.public_subnets + 1}")}"
  availability_zone       = "${element(random_shuffle.availability_zone.result, "${count.index}")}"
  map_public_ip_on_launch = false
  tags                    = "${merge(map("Name", "${var.vpc_name}-data-${count.index+1}"), var.tags)}"
}
