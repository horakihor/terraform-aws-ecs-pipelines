#############
# IAM Roles #
#############

# Amazon CodePipeline Service IAM Role

data "aws_iam_policy_document" "codepipeline_service_policy" {
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]
  }
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "s3:CreateBucket",
      "s3:DeleteObject",
      "s3:Get*",
      "s3:List*",
      "s3:Put*",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
      "iam:PassRole"
    ]
  }
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "ecs:DescribeServices",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTasks",
      "ecs:ListTasks",
      "ecs:RegisterTaskDefinition",
      "ecs:UpdateService",
      "ecs:*",
      "ecr:*"
    ]
  }
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
     "logs:CreateLogGroup",
     "logs:DescribeLogGroups",
     "logs:CreateLogStream",
     "logs:FilterLogEvents",
     "logs:PutLogEvents"
    ]
  }
}

resource "aws_iam_policy" "codepipeline_service" {
  name        = "${var.environment}-${var.ecs_service_name}-codepipeline-service-policy"
  description = "${var.environment}-${var.ecs_service_name}-codepipeline-service-policy"
  policy = "${data.aws_iam_policy_document.codepipeline_service_policy.json}"
}

data "aws_iam_policy_document" "codepipeline_service_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codepipeline_service" {
  name               = "${var.environment}-${var.ecs_service_name}-codepipeline-service-role"
  assume_role_policy = "${data.aws_iam_policy_document.codepipeline_service_role.json}"
}

resource "aws_iam_role_policy_attachment" "codepipeline_service_scheduler" {
  role       = "${aws_iam_role.codepipeline_service.name}"
  policy_arn = "${aws_iam_policy.codepipeline_service.arn}"
}



# Amazon CodeBuild Service IAM Role

data "aws_iam_policy_document" "codebuild_policy" {
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecs:RunTask",
    ]
  }
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
      "ec2:CreateNetworkInterfacePermission",
    ]
  }
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:List*",
      "s3:PutObject",
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
  }
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
     "logs:CreateLogGroup",
     "logs:CreateLogStream",
     "logs:DescribeLogGroups",
     "logs:FilterLogEvents",
     "logs:PutLogEvents"
    ]
  }
}

resource "aws_iam_policy" "codebuild" {
  name        = "${var.environment}-${var.ecs_service_name}-codebuild-policy"
  description = "${var.environment}-${var.ecs_service_name}-codebuild-policy"
  policy      = "${data.aws_iam_policy_document.codebuild_policy.json}"
}

data "aws_iam_policy_document" "codebuild_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codebuild" {
  name               = "${var.environment}-${var.ecs_service_name}-codebuild-role"
  assume_role_policy = "${data.aws_iam_policy_document.codebuild_role.json}"
}

resource "aws_iam_role_policy_attachment" "codebuild" {
  role       = "${aws_iam_role.codebuild.name}"
  policy_arn = "${aws_iam_policy.codebuild.arn}"
}
