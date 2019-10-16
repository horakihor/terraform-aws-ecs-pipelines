data "aws_vpc" "vpc" {
  id = "${var.vpc_id}"
}

data "aws_vpc" "peer" {
  id =  "${var.peer_vpc_id}"
}

resource "aws_route" "vpc" {
  count                     = "${length(var.vpc_route_tables)}"
  route_table_id            = "${element(var.vpc_route_tables, "${count.index}")}"
  destination_cidr_block    = "${data.aws_vpc.peer.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peer.id}"
}

resource "aws_route" "peer" {
  count                     = "${length(var.peer_route_tables)}"
  route_table_id            = "${element(var.peer_route_tables, "${count.index}")}"
  destination_cidr_block    = "${data.aws_vpc.vpc.cidr_block}"
  vpc_peering_connection_id = "${aws_vpc_peering_connection.peer.id}"
}
