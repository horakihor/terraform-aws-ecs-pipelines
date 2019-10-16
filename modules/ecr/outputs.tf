output "ecr_repository_url" {
	value = "${aws_ecr_repository.ecs.repository_url}"
}
