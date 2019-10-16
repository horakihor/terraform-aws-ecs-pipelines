###########################
#  Create Docker Registry #
###########################

resource "aws_ecr_repository" "ecs" {
  name = "${var.repo_name}"
}
