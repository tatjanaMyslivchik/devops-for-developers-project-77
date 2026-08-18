# Terraform
tf-init:
	$(MAKE) -C terraform init

tf-plan:
	$(MAKE) -C terraform plan -var-file=terraform.tfvars

tf-apply:
	$(MAKE) -C terraform apply -var-file=terraform.tfvars

tf-destroy:
	$(MAKE) -C terraform destroy -var-file=terraform.tfvars

# Ansible
ansible-deps:
	$(MAKE) -C ansible galaxy-install

ansible-deploy:
	$(MAKE) -C ansible deploy