init:
	terraform init

upgrade:
	terraform init -upgrade

apply:
	terraform apply

destroy:
	terraform destroy

list:
	terraform state list

phony: init apply destroy list