variable "alb_name" { }

variable "internal_load_balancer" {
  default = false
}

variable "load_balancer_type" {
  default = "application"
}

variable "subnets_ids" {
  type = "list"
}

variable "security_groups" {
  type = "list"
}

variable "tags" {
  default = {
    created_by = "Terraform"
  }
}
