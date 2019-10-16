.PHONY: network service

action?=plan
env?=dev

workspace:
	$(call blue, "Prepare ${env} workspace for $(MAKECMDGOALS) layer...")
	cd layers/$(MAKECMDGOALS) && terraform workspace select ${env} || terraform workspace new ${env}

init:
	$(call blue, "Init s3 backend for $(MAKECMDGOALS) layer...")
	cd layers/$(MAKECMDGOALS) && terraform init -backend-config=../../config/backend-$(MAKECMDGOALS).conf

network: init workspace
	$(call blue, "Start $(action) for network layer...")
	cd layers/network && terraform get -update=true
	cd layers/network && terraform $(action) -var-file=../../config/${env}.tfvars
	$(call blue, "Finished $(action) for network layer.")

service: init workspace
	$(call blue, "Start $(action) for service layer...")
	cd layers/service && terraform get -update=true
	cd layers/service && terraform $(action) -var-file=../../config/${env}.tfvars
	$(call blue, "Finished $(action) for service layer.")

define blue
	@tput setaf 6
	@echo $1
	@tput sgr0
endef
