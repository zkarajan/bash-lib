# Bash Utils - Общие утилиты для bash скриптов

Набор общих функций и утилит для использования в bash скриптах.

## Быстрый старт

### Локальный импорт (в том же репозитории)

```bash
#!/bin/bash

# Автоматически загружаем утилиты
if [[ -z "$__BASH_UTILS_IMPORTED" ]]; then
    source "$(dirname "$0")/../../utils/helpers/colors.sh"
fi

log_info "Скрипт начался"
log_success "Успешно!"
```

### Удаленный импорт (когда репозиторий будет опубликован)

```bash
#!/bin/bash

# Автоматически загружаем утилиты
if [[ -z "$__BASH_UTILS_IMPORTED" ]]; then
    source <(curl -fsSL https://raw.githubusercontent.com/mrvi0/bash-lib/main/utils/helpers/colors.sh)
fi

log_info "Скрипт начался"
```

## Доступные функции

### Логирование

```bash
log_info "Информационное сообщение"
log_warn "Предупреждение"
log_error "Ошибка"
log_debug "Отладочная информация"
log_success "Успешное выполнение"
log_fail "Неудачное выполнение"
```

### Цвета

```bash
echo -e "${RED}Красный текст${NC}"
echo -e "${GREEN}Зеленый текст${NC}"
echo -e "${YELLOW}Желтый текст${NC}"
echo -e "${BLUE}Синий текст${NC}"
echo -e "${CYAN}Голубой текст${NC}"
echo -e "${MAGENTA}Пурпурный текст${NC}"
echo -e "${BOLD_RED}Жирный красный${NC}"
```

### Форматирование вывода

```bash
print_header "Заголовок скрипта"
print_separator "-" 50
```

### Подтверждения

```bash
if confirm "Продолжить?"; then
    echo "Пользователь подтвердил"
else
    echo "Пользователь отменил"
fi

# С дефолтным значением "нет"
if confirm "Удалить файл?" "n"; then
    rm file.txt
fi
```

### Проверки

```bash
# Проверка существования команды
if command_exists "docker"; then
    log_info "Docker установлен"
fi

# Проверка root прав
check_root

# Проверка файлов и директорий
if file_exists "/path/to/file"; then
    log_info "Файл существует"
fi

if dir_exists "/path/to/dir"; then
    log_info "Директория существует"
fi
```

### Файловые операции

```bash
# Создание директории
create_dir "/path/to/new/dir"

# Безопасное удаление файла
safe_remove "/path/to/file"

# Получение размера файла
size=$(get_file_size "/path/to/file")
log_info "Размер файла: $size"

# Получение свободного места
free_space=$(get_free_space "/")
log_info "Свободное место: $free_space"
```

### Системная информация

```bash
# Полная информация о системе
get_system_info

# Проверка интернета
if check_internet; then
    log_success "Интернет доступен"
fi

# Получение внешнего IP
ip=$(get_external_ip)
log_info "Внешний IP: $ip"
```

### Прогресс и ожидание

```bash
# Прогресс-бар
for i in {1..10}; do
    show_progress $i 10
    sleep 0.5
done

# Ожидание с спиннером
long_running_command &
pid=$!
wait_with_spinner "Выполняется команда..." $pid
```

### Время и логирование

```bash
# Начало скрипта
start_time=$(date +%s)

# ... выполнение скрипта ...

# Логирование времени выполнения
log_execution_time $start_time

# Создание временной метки
timestamp=$(get_timestamp)
log_info "Временная метка: $timestamp"

# Настройка логирования в файл
setup_logging "/var/log/my_script.log"
```

### Обработка ошибок

Автоматически включена при импорте утилит:

- `set -euo pipefail` - строгий режим
- Автоматическая обработка ошибок с выводом номера строки
- Очистка при выходе из скрипта

## Примеры использования

### Простой скрипт

```bash
#!/bin/bash

# Импорт утилит
if [[ -z "$__BASH_UTILS_IMPORTED" ]]; then
    source "$(dirname "$0")/../../utils/helpers/colors.sh"
fi

main() {
    print_header "Мой скрипт"
    
    log_info "Начинаю выполнение..."
    
    # Проверяем условия
    if ! command_exists "git"; then
        log_error "Git не установлен"
        exit 1
    fi
    
    # Выполняем действия
    if confirm "Создать резервную копию?"; then
        create_dir "/backup"
        log_success "Резервная копия создана"
    fi
    
    print_header "Скрипт завершен"
}

main "$@"
```

### Скрипт с аргументами

```bash
#!/bin/bash

# Импорт утилит
if [[ -z "$__BASH_UTILS_IMPORTED" ]]; then
    source "$(dirname "$0")/../../utils/helpers/colors.sh"
fi

# Парсинг аргументов
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            echo "Использование: $0 [-v]"
            exit 0
            ;;
        *)
            log_error "Неизвестная опция: $1"
            exit 1
            ;;
    esac
done

main() {
    if [[ "$VERBOSE" == true ]]; then
        get_system_info
    fi
    
    log_info "Выполнение скрипта..."
}

main "$@"
```

## Лучшие практики

1. **Всегда импортируйте утилиты в начале скрипта**
2. **Используйте функции логирования вместо echo**
3. **Проверяйте условия перед выполнением действий**
4. **Используйте confirm() для критических операций**
5. **Логируйте время выполнения для долгих скриптов**
6. **Используйте строгий режим (set -euo pipefail)**

## Зависимости

- Bash 4.0+
- curl (для удаленного импорта)
- ping (для проверки интернета)
- df, du (для работы с дисками)

## Лицензия

MIT License 