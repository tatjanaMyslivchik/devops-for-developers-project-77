### Hexlet tests and linter status:
[![Actions Status](https://github.com/tatjanaMyslivchik/devops-for-developers-project-77/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/tatjanaMyslivchik/devops-for-developers-project-77/actions)

## Инфраструктура (Terraform)

### Предварительные требования

- Установленный Terraform (>= 1.0)
- Ansible >= 2.10
- Yandex Cloud CLI
- Сервисный аккаунт с правами `editor`

### Настройка переменных

### Автоматическая генерация `terraform.tfvars`

Для удобства используется скрипт `scripts/generate-tfvars.sh`, который:

- Расшифровывает `ansible/group_vars/all/vault.yml`
- Извлекает переменные с префиксом `terraform_`
- Генерирует файл `terraform/terraform.tfvars`

```bash
# Запуск генерации
make tfvars

# Или напрямую
./scripts/generate-tfvars.sh
```

Необходимо создать файл с секретами `ansible/group_vars/all/vault.yml`, в котором олжны быть переменные с префиксом terraform_:
```terraform_yc_token: "токен"
terraform_yc_cloud_id: "cloud_id"
terraform_yc_folder_id: "folder_id"
terraform_db_password: "пароль"
```

Необходимо 'кспортировать `AWS_ACCESS_KEY_ID` и `AWS_SECRET_ACCESS_KEY`


## Команды

### Инициализация Terraform
```bash
make tf-init
```

### План изменений
```bash
make tf-plan
```

### Создание инфраструктуры
```bash
make tf-apply
```

### Удаление инфраструктуры
```bash
make tf-destroy
```

### Установка зависимостей Ansible
```bash 
make ansible-deps
```

### Деплой приложения
```bash 
make ansible-deploy
```

## Ссылка на приложение

🔗 **Приложение доступно по адресу:** [https://mt-blog-project-74.online](https://mt-blog-project-74.online)