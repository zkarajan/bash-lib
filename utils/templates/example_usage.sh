#!/bin/bash
# Пример использования утилит bash-lib

# Автоматически загружаем утилиты
if [[ -z "$__BASH_UTILS_IMPORTED" ]]; then
    # Локальный импорт (если скрипт в том же репозитории)
    if [[ -f "$(dirname "$0")/../helpers/colors.sh" ]]; then
        source "$(dirname "$0")/../helpers/colors.sh"
    else
        # Удаленный импорт (когда репозиторий будет опубликован)
        source <(curl -fsSL https://raw.githubusercontent.com/mrvi0/bash-lib/main/utils/helpers/colors.sh)
    fi
fi

# Простой пример скрипта
main() {
    print_header "Пример использования bash-lib утилит"
    
    log_info "Скрипт начался"
    
    # Показываем информацию о системе
    get_system_info
    
    print_separator
    
    # Проверяем подключение к интернету
    if check_internet; then
        log_success "Интернет доступен"
        log_info "Внешний IP: $(get_external_ip)"
    else
        log_warn "Интернет недоступен"
    fi
    
    print_separator
    
    # Показываем свободное место
    local free_space=$(get_free_space)
    log_info "Свободное место: $free_space"
    
    # Пример прогресс-бара
    log_info "Демонстрация прогресс-бара:"
    for i in {1..5}; do
        show_progress $i 5
        sleep 0.5
    done
    
    # Пример подтверждения
    if confirm "Продолжить выполнение?"; then
        log_success "Пользователь подтвердил действие"
    else
        log_warn "Пользователь отменил действие"
        exit 0
    fi
    
    # Пример создания директории
    create_dir "/tmp/bash-lib-example"
    
    # Пример безопасного удаления
    safe_remove "/tmp/bash-lib-example/test.txt"
    
    print_header "Пример завершен"
}

# Запускаем только если скрипт вызван напрямую
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi 