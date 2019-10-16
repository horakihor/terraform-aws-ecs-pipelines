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

module "vpc_prod" {
  source         = "../../modules/vpc"
  vpc_name       = "${lookup(var.environment, var.terraform_env)}"
  vpc_cidr_block = "${lookup(var.prod_vpc_cidr_block, var.terraform_env)}"
  providers      = { aws = "aws.prod"}
}

##########################
# Create Security Groups #
##########################

module "security_groups_prod" {
  source      = "../../modules/security_groups"
  vpc_id      = "${module.vpc_prod.vpc_id}"
  environment = "${lookup(var.environment, var.terraform_env)}"
  providers   = { aws = "aws.prod"}
}

##############
# Create ALB #
##############

module "alb_prod" {
  source          = "../../modules/alb"
  alb_name        = "prod"
  subnets_ids     = ["${split(",", "${module.vpc_prod.public_subnets_ids}")}"]
  security_groups = ["${module.security_groups_prod.alb_security_group}"]
  providers       = { aws = "aws.prod"}
}

###################
# Create Test VPC #
###################

#module "vpc_test" {
#  source         = "../modules/vpc"
#  vpc_name       = "test"
#  vpc_cidr_block = "172.22.0.0/16"
#  providers      = { aws = "aws.prod"}
#}

#########################
# Create Management VPC #
#########################

#module "vpc_management" {
#  source         = "../modules/vpc"
#  vpc_name       = "management"
#  vpc_cidr_block = "172.23.0.0/16"
#  providers      = { aws = "aws.prod"}
#}

##################################################
# Create Peering between Management and Test VPC #
##################################################

#module "management_peer_prod" {
#  source                  = "../modules/vpc_peering"
#  peer_vpc_id             = "${module.vpc_prod.vpc_id}"
#  vpc_id                  = "${module.vpc_management.vpc_id}"
#  peer_route_tables       = ["${split(",", "${module.vpc_prod.private_subnet_route_table_ids}")}"]
#  vpc_route_tables        = ["${split(",", "${module.vpc_management.private_subnet_route_table_ids}")}"]
#  providers               = { aws = "aws.prod"}
#}
