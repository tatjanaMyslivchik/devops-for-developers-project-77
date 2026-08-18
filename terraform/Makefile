init:
	terraform init

plan:
	terraform plan -var-file=terraform.tfvars

apply:
	terraform apply -var-file=terraform.tfvars

destroy:
	terraform destroy -var-file=terraform.tfvars

validate:
	terraform validate

update-dns:
	terraform apply -target=yandex_dns_recordset.blog -target=yandex_dns_recordset.blog_www