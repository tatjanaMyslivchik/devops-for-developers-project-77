galaxy-install:
	ansible-galaxy install -r requirements.yml

deploy:
	ansible-playbook -i inventory.ini playbook.yml --ask-vault-pass

syntax-check:
	ansible-playbook -i inventory.ini playbook.yml --syntax-check