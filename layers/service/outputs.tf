output "web_alb_dns" {
	value = "${data.terraform_remote_state.network.web_alb_dns}"
}
