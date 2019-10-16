output "ecs_service" {
	value = "${aws_security_group.ecs_service.id}"
}

output "alb_security_group" {
	value = "${aws_security_group.alb.id}"
}
