variable "ecr_repository" { }

variable "ecr_repository_region" { }

variable "environment" { }

variable "app_code_repo_owner" { }

variable "app_code_repo_name" { }

variable "app_code_repo_branch" { }

variable "app_code_repo_oauthtoken" { }

variable "ecs_cluster_name" { }

variable "ecs_service_name" { }

variable "build_vpc_id" { }

variable "build_subnets" {
  type = "list"
}

variable "build_security_group" {
  type = "list"
}
