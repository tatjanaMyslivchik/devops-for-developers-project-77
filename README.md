### Hexlet tests and linter status:
[![Actions Status](https://github.com/tatjanaMyslivchik/devops-for-developers-project-77/actions/workflows/hexlet-check.yml/badge.svg)](https://github.com/tatjanaMyslivchik/devops-for-developers-project-77/actions)

## Инфраструктура (Terraform)

### Предварительные требования

- Установленный Terraform (>= 1.0)
- Ansible >= 2.10
- Yandex Cloud CLI
- Сервисный аккаунт с правами `editor`

### Настройка переменных

Необходимо создать файл `terraform/terraform.tfvars`:

```hcl
yc_token     = "вOAuth_токен"
yc_cloud_id  = "cloud_id"
yc_folder_id = "folder_id"
yc_zone      = "zone"
db_password  = "пароль БД"
datadog_api_key = "Datadog API key"
datadog_app_key = "Datadog APP key"
```

Необходимо создать файл с секретами `ansible/group_vars/all/vault.yml`

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