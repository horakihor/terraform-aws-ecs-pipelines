variable "peer_vpc_id" { }

variable "vpc_id" { }

variable "peer_route_tables" {
  type = "list"
}

variable "vpc_route_tables" {
  type = "list"
}

variable "tags" {
  default = {
    created_by = "Terraform"
  }
}
