output "web_alb_dns" {
	value = "${module.alb.alb_dns}"
}
output "vpc_id" {
	value = "${module.vpc.vpc_id}"
}
output "private_subnets_ids" {
	value = "${module.vpc.private_subnets_ids}"
}
output "ecs_service_security_groups_id" {
	value = "${module.security_groups.ecs_service}"
}
output "alb_arn" {
	value = "${module.alb.alb_arn}"
}
