######################
#  Create ECS Server #
######################

resource "aws_ecs_cluster" "ecs" {
  name = "${var.cluster_name}"
}

########################
# Cloudwatch Log Group #
########################

resource "aws_cloudwatch_log_group" "ecs" {
  name = "${var.cluster_name}"
}
