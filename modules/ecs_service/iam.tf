#############
# IAM Roles #
#############

# Service Auto Scaling IAM Role

data "aws_iam_policy_document" "autoscaling_execution_policy" {
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "application-autoscaling:*",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:PutMetricAlarm"
    ]
  }
}

resource "aws_iam_policy" "autoscaling_execution" {
  name        = "${var.ecs_cluster_name}-${var.service_name}-autoscaling-execution-policy"
  description = "${var.ecs_cluster_name}-${var.service_name}-autoscaling-execution-policy"
  policy      = "${data.aws_iam_policy_document.autoscaling_execution_policy.json}"
}

data "aws_iam_policy_document" "autoscaling_execution_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "autoscaling_execution" {
  name               = "${var.ecs_cluster_name}-${var.service_name}-autoscaling-execution-role"
  assume_role_policy = "${data.aws_iam_policy_document.autoscaling_execution_role.json}"
}

resource "aws_iam_role_policy_attachment" "autoscaling_execution" {
  role       = "${aws_iam_role.autoscaling_execution.name}"
  policy_arn = "${aws_iam_policy.autoscaling_execution.arn}"
}
