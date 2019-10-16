variable "vpc_cidr_block" { }

variable "vpc_name" { }

variable "availability_zones_count" {
  default = "2"
}

variable "private_subnets" {
  default = "2"
}

variable "public_subnets" {
  default = "2"
}

variable "data_subnets" {
  default = "2"
}

variable "tags" {
  default = {
    created_by = "Terraform"
  }
}
