#################
# Code Pipeline #
#################

resource "aws_s3_bucket" "codepipeline" {
  bucket        = "${var.environment}-${var.ecs_service_name}-codepipeline"
  acl           = "private"
  force_destroy = "true"
}

resource "aws_kms_key" "codepipeline" {
  description  = "${var.environment}-${var.ecs_service_name}-kms-key"
}

resource "aws_codepipeline" "codepipeline" {
  name     = "${var.environment}-${var.ecs_service_name}-pipeline"
  role_arn = "${aws_iam_role.codepipeline_service.arn}"

  artifact_store {
    location = "${aws_s3_bucket.codepipeline.bucket}"
    type     = "S3"

    encryption_key {
      id   = "${aws_kms_key.codepipeline.arn}"
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["SourceArtifact"]

      configuration {
        Owner                = "${var.app_code_repo_owner}"
        Repo                 = "${var.app_code_repo_name}"
        Branch               = "${var.app_code_repo_branch}"
        PollForSourceChanges = "true"
        OAuthToken           = "${var.app_code_repo_oauthtoken}"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["SourceArtifact"]
      output_artifacts = ["imagedefinitions"]

      configuration {
        ProjectName = "${aws_codebuild_project.codebuild.name}"
      }
    }
  }

  stage {
    name = "Production"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ECS"
      input_artifacts = ["imagedefinitions"]
      version         = "1"

      configuration {
        ClusterName = "${var.ecs_cluster_name}"
        ServiceName = "${var.environment}-${var.ecs_service_name}"
        FileName    = "imagedefinitions.json"
      }
    }
  }
}
