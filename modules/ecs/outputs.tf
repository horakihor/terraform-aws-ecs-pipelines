output "ecs_cluster_id" {
	value = "${aws_ecs_cluster.ecs.id}"
}

output "ecs_cluster_name" {
	value = "${aws_ecs_cluster.ecs.name}"
}

output "cloudwatch_log_group_name" {
	value = "${aws_cloudwatch_log_group.ecs.name}"
}

output "ecs_tast_execution_arn" {
	value = "${aws_iam_role.ecs_tast_execution.arn}"
}
