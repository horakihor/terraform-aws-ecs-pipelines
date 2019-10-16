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
variable "network_state_bucket_name" {}

variable "network_state_bucket_region" {}

variable "environment" {
  default = "dev"
}
variable "network_environment" {
  default = "dev"
}
