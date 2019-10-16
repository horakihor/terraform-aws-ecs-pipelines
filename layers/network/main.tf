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

##############
# Create VPC #
##############

module "vpc" {
  source         = "../../modules/vpc"
  vpc_name       = "${var.environment}"
  vpc_cidr_block = "${lookup(var.vpc_cidr_block, var.environment)}"
  providers      = { aws = "aws.prod"}
}

##########################
# Create Security Groups #
##########################

module "security_groups" {
  source      = "../../modules/security_groups"
  vpc_id      = "${module.vpc.vpc_id}"
  environment = "${var.environment}"
  providers   = { aws = "aws.prod"}
}

##############
# Create ALB #
##############

module "alb" {
  source          = "../../modules/alb"
  alb_name        = "${var.environment}"
  subnets_ids     = ["${split(",", "${module.vpc.public_subnets_ids}")}"]
  security_groups = ["${module.security_groups.alb_security_group}"]
  providers       = { aws = "aws.prod"}
}
