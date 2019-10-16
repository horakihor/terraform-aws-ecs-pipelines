# Global
variable "environment" {
  default = "dev"
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
variable "vpc_cidr_block" {
 type = "map"
 default   = {
   "dev"   = "172.21.0.0/16"
   "test"  = "172.22.0.0/16"
   "stage" = "172.23.0.0/16"
   "prod"  = "172.24.0.0/16"
 }
}
