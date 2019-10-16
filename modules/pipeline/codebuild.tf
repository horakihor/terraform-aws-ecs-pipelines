##############
# Code Build #
##############

resource "aws_codebuild_project" "codebuild" {
  name          = "${var.environment}-${var.ecs_service_name}"
  description   = "${var.environment}-${var.ecs_service_name}"
  build_timeout = "5"
  service_role  = "${aws_iam_role.codebuild.arn}"

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/docker:17.09.0"
    privileged_mode = true
    type         = "LINUX_CONTAINER"

    environment_variable {
      "name"  = "ECR_REPOSITORY"
      "value" = "${var.ecr_repository}"
      "type"  = "PLAINTEXT"
    }

    environment_variable {
      "name"  = "AWS_REGION"
      "value" = "${var.ecr_repository_region}"
      "type"  = "PLAINTEXT"
    }

    environment_variable {
      "name"  = "SERVICE_NAME"
      "value" = "${var.ecs_service_name}"
      "type"  = "PLAINTEXT"
    }
  }

  source {
    type = "CODEPIPELINE"
  }

  vpc_config {
    vpc_id = "${var.build_vpc_id}"
    subnets = ["${var.build_subnets}"]
    security_group_ids = ["${var.build_security_group}"]
  }

  tags {
    Environment = "${var.environment}"
  }
}
