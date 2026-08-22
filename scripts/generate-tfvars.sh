VAULT_FILE="ansible/group_vars/all/vault.yml"
TFVARS_FILE="terraform/terraform.tfvars"
TEMP_FILE=$(mktemp)

# Расшифровка
ansible-vault decrypt "$VAULT_FILE" --output "$TEMP_FILE" 2>/dev/null
if [ $? -ne 0 ]; then
  echo "Ошибка: Не удалось расшифровать $VAULT_FILE"
  echo "Пожалуйста, введите пароль vault"
  ansible-vault decrypt "$VAULT_FILE" --output "$TEMP_FILE"
fi

# Генерация tfvars
echo "# Автоматически сгенерировано из vault.yml" > "$TFVARS_FILE"

grep -E '^terraform_' "$TEMP_FILE" | while IFS= read -r line; do
  # Удаляем префикс terraform_
  clean="${line#terraform_}"
  # Заменяем двоеточие на знак равенства
  clean=$(echo "$clean" | sed 's/:/ = /')
  # Убираем лишние пробелы
  clean="$(echo "$clean" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
  echo "$clean" >> "$TFVARS_FILE"
done

rm -f "$TEMP_FILE"
echo "✅ Сгенерирован $TFVARS_FILE"