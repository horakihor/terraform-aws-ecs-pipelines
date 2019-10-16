#############
# IAM Roles #
#############

# Amazon ECS Service Scheduler IAM Role

data "aws_iam_policy_document" "ecs_service_scheduler_policy" {
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets"
    ]
  }
}

resource "aws_iam_policy" "ecs_service_scheduler" {
  name        = "${var.cluster_name}-ecs-service-scheduler-policy"
  description = "${var.cluster_name}-ecs-service-scheduler-policy"
  policy = "${data.aws_iam_policy_document.ecs_service_scheduler_policy.json}"
}

data "aws_iam_policy_document" "ecs_service_scheduler_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_service_scheduler" {
  name               = "${var.cluster_name}-ecs-service-scheduler-role"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_service_scheduler_role.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_service_scheduler" {
  role       = "${aws_iam_role.ecs_service_scheduler.name}"
  policy_arn = "${aws_iam_policy.ecs_service_scheduler.arn}"
}

# Amazon ECS Task Execution IAM Role

data "aws_iam_policy_document" "ecs_tast_execution_policy" {
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
  }
}

resource "aws_iam_policy" "ecs_tast_execution" {
  name        = "${var.cluster_name}-ecs-tast-execution-policy"
  description = "${var.cluster_name}-ecs-tast-execution-policy"
  policy      = "${data.aws_iam_policy_document.ecs_tast_execution_policy.json}"
}

data "aws_iam_policy_document" "ecs_tast_execution_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_tast_execution" {
  name               = "${var.cluster_name}-ecs-tast-execution-role"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_tast_execution_role.json}"
}

resource "aws_iam_role_policy_attachment" "ecs_tast_execution" {
  role       = "${aws_iam_role.ecs_tast_execution.name}"
  policy_arn = "${aws_iam_policy.ecs_tast_execution.arn}"
}
