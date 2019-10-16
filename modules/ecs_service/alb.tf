resource "aws_alb_target_group" "alb" {
  name        = "${var.family}-${var.service_name}"
  port        = "${var.container_host_port}"
  protocol    = "${var.target_group_protocol}"
  vpc_id      = "${var.vpc_id}"
  target_type = "${var.target_group_target_type}"
  tags        = "${var.tags}"

  lifecycle {
    create_before_destroy = true
  }

  health_check {
    healthy_threshold   = "${var.target_group_healthy_threshold}"
    interval            = "${var.target_group_health_interval}"
    protocol            = "${var.target_group_protocol}"
    matcher             = "${var.target_group_health_matcher}"
    timeout             = "${var.target_group_health_timeout}"
    path                = "${var.target_group_health_check_path}"
    unhealthy_threshold = "${var.target_group_unhealthy_threshold}"
  }
}

resource "aws_alb_listener" "alb" {
  load_balancer_arn = "${var.alb_arn}"
  port              = "${var.container_host_port}"
  protocol          = "${var.target_group_protocol}"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb.arn}"
    type             = "forward"
  }
}
