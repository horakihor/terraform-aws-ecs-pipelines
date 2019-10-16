output "prod_web_alb_dns" {
	value = "${module.alb_prod.alb_dns}"
}
output "prod_vpc_id" {
	value = "${module.vpc_prod.vpc_id}"
}
output "prod_private_subnets_ids" {
	value = "${module.vpc_prod.private_subnets_ids}"
}
output "prod_ecs_service_security_groups_id" {
	value = "${module.security_groups_prod.ecs_service}"
}
output "prod_alb_arn" {
	value = "${module.alb_prod.alb_arn}"
}
