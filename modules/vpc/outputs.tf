output "vpc_id" {
	value = "${aws_vpc.vpc.id}"
}

output "private_subnets_ids" {
	value = "${join(",", aws_subnet.private_subnets.*.id)}"
}

output "public_subnets_ids" {
	value = "${join(",", aws_subnet.public_subnets.*.id)}"
}

output "data_subnets_ids" {
	value = "${join(",", aws_subnet.data_subnets.*.id)}"
}

output "private_subnet_route_table_ids" {
	value = "${join(",", aws_route_table.private_subnets.*.id)}"
}

output "public_subnet_route_table_ids" {
	value = "${join(",", aws_route_table.public_subnets.*.id)}"
}

output "data_subnet_route_table_ids" {
	value = "${join(",", aws_route_table.data_subnets.*.id)}"
}
