#!/usr/bin/env bash
# Простой пример использования bash-lib
# Подключение библиотеки одной строкой

# Подключить всю библиотеку
source <(curl -fsSL https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh)

echo "=== Простой пример bash-lib ==="
echo

# Показать заголовок
print_header "Мой скрипт"

# Логирование
logging::info "Скрипт запущен"
logging::debug "Отладочная информация"

# Цветной вывод
colors::success "Успешная операция!"
colors::warning "Предупреждение"
colors::info "Информационное сообщение"

# Валидация
email="test@example.com"
if validation::is_email "$email"; then
    colors::success "✓ Email валиден: $email"
else
    colors::error "✗ Неверный email: $email"
fi

# Проверка аргументов
if [[ $# -eq 0 ]]; then
    colors::error "Необходимо указать имя файла"
    exit 1
fi

filename="$1"

# Проверка файла
if validation::file_exists "$filename"; then
    colors::success "✓ Файл существует: $filename"
    size=$(get_file_size "$filename")
    colors::info "Размер файла: $size"
else
    colors::warning "✗ Файл не найден: $filename"
fi

# Подтверждение действия
if confirm "Продолжить выполнение?"; then
    colors::success "Пользователь подтвердил действие"
else
    colors::info "Пользователь отменил действие"
fi

# Прогресс-бар
echo "Обработка..."
for i in {1..5}; do
    colors::progress_bar "$i" "5" "30" "Обработка"
    sleep 0.5
done

# Системная информация
if confirm "Показать информацию о системе?" "n"; then
    get_system_info
fi

# Проверка интернета
if check_internet; then
    colors::success "Интернет доступен"
    ip=$(get_external_ip)
    colors::info "Внешний IP: $ip"
else
    colors::warning "Интернет недоступен"
fi

print_header "Скрипт завершен"
colors::success "Все операции выполнены успешно!" 