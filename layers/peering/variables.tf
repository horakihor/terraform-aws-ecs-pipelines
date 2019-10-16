# Global
variable "terraform_env" {
  default = "dev"
}
variable "environment" {
 type = "map"
 default  = {
   "dev"  = "development"
   "prod" = "production"
 }
}
# Access info
variable "aws_access_key" {
  default = ""
}
variable "aws_secret_key" {
  default = ""
}
variable "region" {
  default = "eu-west-2"
}
# Prod VPC Options
variable "prod_vpc_name" {
 type = "map"
 default  = {
   "dev"  = "development"
   "prod" = "production"
 }
}
variable "prod_vpc_cidr_block" {
 type = "map"
 default  = {
   "dev"  = "172.21.0.0/16"
   "prod" = "172.31.0.0/16"
 }
}
