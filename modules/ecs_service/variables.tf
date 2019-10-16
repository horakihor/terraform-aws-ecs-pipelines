variable "container_image" { }

variable "container_host_port" { }

variable "container_port" { }

variable "container_name" { }

variable "service_name" { }

variable "log_group" { }

variable "log_region" { }

variable "family" { }

variable "ecs_tast_execution" { }

variable "task_desired_count" { }

variable "ecs_cluster" { }

variable "ecs_cluster_name" { }

variable "security_groups_ids" {
  type = "list"
}

variable "subnets_ids" {
  type = "list"
}

# ALB

variable "alb_arn" { }

variable "vpc_id" { }

variable "target_group_protocol" {
  default = "HTTP"
}

variable "target_group_target_type" {
  default = "ip"
}

variable "target_group_healthy_threshold" {
  default = "3"
}

variable "target_group_health_interval" {
  default = "30"
}

variable "target_group_health_matcher" {
  default = "200"
}

variable "target_group_health_timeout" {
  default = "3"
}

variable "target_group_unhealthy_threshold" {
  default = "2"
}

variable "target_group_health_check_path" {}

variable "tags" {
  default = {
    created_by = "Terraform"
  }
}
