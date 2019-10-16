#########################
# Global Configurations #
#########################

terraform {
  required_version = ">=0.11.7"
  backend "s3" {}
}

provider "aws" {
  alias  = "prod"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "${var.region}"
}

##########################################
# Get Network Settings from Remote State #
##########################################

data "terraform_remote_state" "network" {
  backend   = "s3"
  workspace = "${var.environment}"
  config{
    bucket  = "${var.network_state_bucket_name}"
    key     = "states/network/terraform.tfstate"
    region  ="${var.network_state_bucket_region}"
  }
}

##############
# Create ECR #
##############

module "ecr" {
  source    = "../../modules/ecr"
  repo_name = "${var.environment}"
  providers = { aws = "aws.prod"}
}

##############
# Create ECS #
##############

module "ecs" {
  source       = "../../modules/ecs"
  cluster_name = "${var.environment}"
  providers    = { aws = "aws.prod"}
}

######################
# Create ECS Service #
######################

module "web_service" {
  source               = "../../modules/ecs_service"
  ecs_cluster          = "${module.ecs.ecs_cluster_id}"
  ecs_cluster_name     = "${module.ecs.ecs_cluster_name}"
  container_image      = "${module.ecr.ecr_repository_url}:latest"
  container_host_port  = "80"
  container_port       = "80"
  container_name       = "web"
  service_name         = "web"
  log_group            = "${module.ecs.cloudwatch_log_group_name}"
  log_region           = "${var.region}"
  family               = "${var.environment}"
  ecs_tast_execution   = "${module.ecs.ecs_tast_execution_arn}"
  task_desired_count   = "2"
  security_groups_ids  = ["${data.terraform_remote_state.network.ecs_service_security_groups_id}"]
  subnets_ids          = ["${split(",", "${data.terraform_remote_state.network.private_subnets_ids}")}"]
  target_group_health_check_path = "/health"
  alb_arn              = "${data.terraform_remote_state.network.alb_arn}"
  vpc_id               = "${data.terraform_remote_state.network.vpc_id}"
  providers            = { aws = "aws.prod"}
}

########################
# Create Code Pipeline #
########################

module "web_pipeline" {
  source                   = "../../modules/pipeline"
  ecr_repository           = "${module.ecr.ecr_repository_url}"
  ecr_repository_region    = "${var.region}"
  environment              = "${var.environment}"
  app_code_repo_name       = "python-test-app"
  app_code_repo_branch     = "master"
  app_code_repo_owner      = "horakihor"
  app_code_repo_oauthtoken = ""
  ecs_cluster_name         = "${module.ecs.ecs_cluster_name}"
  ecs_service_name         = "web"
  build_vpc_id             = "${data.terraform_remote_state.network.vpc_id}"
  build_subnets            = ["${split(",", "${data.terraform_remote_state.network.private_subnets_ids}")}"]
  build_security_group     = ["${data.terraform_remote_state.network.ecs_service_security_groups_id}"]
  providers                = { aws = "aws.prod"}
}
