#######################
# Create VPC Peering  #
#######################

resource "aws_vpc_peering_connection" "peer" {
  peer_vpc_id   = "${var.peer_vpc_id}"
  vpc_id        = "${var.vpc_id}"
  auto_accept   = true
  tags          = "${merge(map("Name", "${var.peer_vpc_id}-${var.vpc_id}"), var.tags)}"
}
