# Terraform
tf-init:
	$(MAKE) -C terraform init -backend=false -get-plugins=false

tf-plan:
	$(MAKE) -C terraform plan

tf-apply:
	$(MAKE) -C terraform apply

tf-destroy:
	$(MAKE) -C terraform destroy

# Ansible
ansible-deps:
	$(MAKE) -C ansible galaxy-install

ansible-deploy:
	$(MAKE) -C ansible deploy

# DNS
update-dns:
	$(MAKE) -C terraform update-dns