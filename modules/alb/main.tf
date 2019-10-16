#############################
# Application Load Balancer #
#############################

resource "aws_alb" "alb" {
  name               = "${var.alb_name}"
  internal           = "${var.internal_load_balancer}"
  load_balancer_type = "${var.load_balancer_type}"
  subnets            = ["${var.subnets_ids}"]
  security_groups    = ["${var.security_groups}"]
  tags               = "${var.tags}"
}
