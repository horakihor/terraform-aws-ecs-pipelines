variable "vpc_id" { }

variable "environment" { }

variable "tags" {
  default = {
    created_by = "Terraform"
  }
}
