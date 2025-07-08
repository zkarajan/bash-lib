#!/bin/bash
# Название скрипта: script_name.sh
# Описание: Краткое описание что делает скрипт
# Автор: Ваше имя
# Дата создания: $(date '+%Y-%m-%d')

# Автоматически загружаем утилиты
if [[ -z "$__BASH_UTILS_IMPORTED" ]]; then
    # Локальный импорт (если скрипт в том же репозитории)
    if [[ -f "$(dirname "$0")/../../utils/helpers/colors.sh" ]]; then
        source "$(dirname "$0")/../../utils/helpers/colors.sh"
    else
        # Удаленный импорт (когда репозиторий будет опубликован)
        source <(curl -fsSL https://raw.githubusercontent.com/yourname/bash-lib/main/utils/helpers/colors.sh)
    fi
fi

# Настройки скрипта
set -euo pipefail  # Строгий режим

# Константы
SCRIPT_NAME=$(basename "$0")
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
VERSION="1.0.0"

# Переменные по умолчанию
DEFAULT_OPTION="default_value"
VERBOSE=false
DRY_RUN=false

# Функция для показа справки
show_help() {
    cat << EOF
Использование: $SCRIPT_NAME [ОПЦИИ]

Описание:
    Краткое описание что делает скрипт

Опции:
    -h, --help          Показать эту справку
    -v, --verbose       Подробный вывод
    -d, --dry-run       Режим тестирования (не выполнять действия)
    -o, --option VALUE  Установить опцию (по умолчанию: $DEFAULT_OPTION)
    -V, --version       Показать версию

Примеры:
    $SCRIPT_NAME                    # Базовое использование
    $SCRIPT_NAME -v -o custom_value # С подробным выводом и кастомной опцией
    $SCRIPT_NAME --dry-run          # Тестовый режим

EOF
}

# Функция для показа версии
show_version() {
    echo "$SCRIPT_NAME версия $VERSION"
}

# Функция для парсинга аргументов
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -d|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -o|--option)
                if [[ -z "$2" || "$2" =~ ^- ]]; then
                    log_error "Опция -o требует значение"
                    exit 1
                fi
                DEFAULT_OPTION="$2"
                shift 2
                ;;
            -V|--version)
                show_version
                exit 0
                ;;
            -*)
                log_error "Неизвестная опция: $1"
                show_help
                exit 1
                ;;
            *)
                # Позиционные аргументы
                break
                ;;
        esac
    done
}

# Функция для валидации входных данных
validate_input() {
    log_debug "Валидация входных данных..."
    
    # Проверяем необходимые условия
    if [[ ! -d "$SCRIPT_DIR" ]]; then
        log_error "Директория скрипта не найдена: $SCRIPT_DIR"
        exit 1
    fi
    
    # Дополнительные проверки...
    
    log_debug "Валидация завершена успешно"
}

# Функция для инициализации
initialize() {
    log_info "Инициализация скрипта..."
    
    # Создаем временные директории если нужно
    local temp_dir="/tmp/$SCRIPT_NAME"
    create_dir "$temp_dir"
    
    # Дополнительная инициализация...
    
    log_success "Инициализация завершена"
}

# Основная функция
main() {
    local start_time=$(date +%s)
    
    print_header "Запуск $SCRIPT_NAME v$VERSION"
    
    # Парсим аргументы
    parse_arguments "$@"
    
    # Показываем информацию о системе в verbose режиме
    if [[ "$VERBOSE" == true ]]; then
        get_system_info
        print_separator
    fi
    
    # Валидируем входные данные
    validate_input
    
    # Инициализируем
    initialize
    
    # Основная логика скрипта
    log_info "Выполнение основной логики..."
    
    if [[ "$DRY_RUN" == true ]]; then
        log_warn "Режим тестирования - действия не выполняются"
        log_info "Была бы установлена опция: $DEFAULT_OPTION"
    else
        # Здесь основная логика скрипта
        log_info "Опция установлена: $DEFAULT_OPTION"
        
        # Пример использования функций
        show_progress 1 3
        sleep 1
        show_progress 2 3
        sleep 1
        show_progress 3 3
        
        log_success "Основная логика завершена"
    fi
    
    # Логируем время выполнения
    log_execution_time $start_time
    
    print_header "Скрипт завершен успешно"
}

# Запуск основной функции только если скрипт вызван напрямую
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi 