galaxy-install:
	ansible-galaxy install -r requirements.yml

# Полный деплой
deploy:
	ansible-playbook -i inventory.ini playbook.yml --ask-vault-pass

# Только установка (без деплоя)
setup:
	ansible-playbook -i inventory.ini playbook.yml --tags setup --ask-vault-pass

# Только деплой приложения
deploy-app:
	ansible-playbook -i inventory.ini playbook.yml --tags deploy --ask-vault-pass

# Только мониторинг
monitoring:
	ansible-playbook -i inventory.ini playbook.yml --tags monitoring --ask-vault-pass

syntax-check:
	ansible-playbook -i inventory.ini playbook.yml --syntax-check