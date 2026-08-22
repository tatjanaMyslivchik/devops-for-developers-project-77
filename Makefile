# Генерация terraform.tfvars из vault.yml
tfvars:
	./scripts/generate-tfvars.sh

# Terraform
tf-init:
	$(MAKE) -C terraform init

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

ansible-setup:
	$(MAKE) -C ansible setup

ansible-app:
	$(MAKE) -C ansible deploy-app

ansible-monitoring:
	$(MAKE) -C ansible monitoring

# DNS
update-dns:
	$(MAKE) -C terraform update-dns

setup: tfvars
	$(MAKE) -C terraform init
	$(MAKE) -C ansible galaxy-install

test:
	$(MAKE) -C terraform validate
	$(MAKE) -C ansible syntax-check