##################################
#  Create Security Group for ALB #
##################################

resource "aws_security_group" "alb" {
  name        = "${var.environment}-alb"
  description = "${var.environment}-alb"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags          = "${merge(map("Name", "${var.environment}-alb-sg"), var.tags)}"
}
