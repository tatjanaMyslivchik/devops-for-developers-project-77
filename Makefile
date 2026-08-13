# Terraform
tf-init:
	cd terraform && terraform init

tf-plan:
	cd terraform && terraform plan -var-file=terraform.tfvars

tf-apply:
	cd terraform && terraform apply -var-file=terraform.tfvars

tf-destroy:
	cd terraform && terraform destroy -var-file=terraform.tfvars

# Ansible
ansible-deps:
	cd ansible && ansible-galaxy install -r requirements.yml

ansible-deploy:
	cd ansible && ansible-playbook -i inventory.ini playbook.yml --ask-vault-pass	

update-dns:
	terraform -chdir=terraform apply -target=yandex_dns_recordset.blog -target=yandex_dns_recordset.blog_www