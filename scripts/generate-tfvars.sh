# Путь к зашифрованному vault файлу
VAULT_FILE="ansible/group_vars/all/vault.yml"
TFVARS_FILE="terraform/terraform.tfvars"

# Временный файл для расшифровки
TEMP_FILE=$(mktemp)

# Расшифровать vault файл
ansible-vault decrypt "$VAULT_FILE" --output "$TEMP_FILE" 2>/dev/null

if [ $? -ne 0 ]; then
  echo "Ошибка: Не удалось расшифровать $VAULT_FILE"
  echo "Пожалуйста, введите пароль vault"
  ansible-vault decrypt "$VAULT_FILE" --output "$TEMP_FILE"
fi

# Извлечь переменные, начинающиеся с terraform_ и записать в tfvars
echo "# Автоматически сгенерировано из vault.yml" > "$TFVARS_FILE"
grep -E '^terraform_' "$TEMP_FILE" | sed 's/terraform_//' >> "$TFVARS_FILE"

# Удалить временный файл
rm -f "$TEMP_FILE"

echo "✅ Сгенерирован $TFVARS_FILE"