#!/bin/bash
# Пример использования утилит bash-lib

# Автоматически загружаем утилиты
if [[ -z "$__BASH_UTILS_IMPORTED" ]]; then
    # Локальный импорт (если скрипт в том же репозитории)
    if [[ -f "$(dirname "$0")/../helpers/base.sh" ]]; then
        source "$(dirname "$0")/../helpers/base.sh"
    else
        # Удаленный импорт (github main)
        if curl -fsSL https://raw.githubusercontent.com/mrvi0/bash-lib/main/utils/helpers/base.sh -o /tmp/base.sh; then
            source /tmp/base.sh
        else
            # Fallback на gist
            curl -fsSL https://gist.githubusercontent.com/mrvi0/4a6b598691b90885c440c876d79f4ef7/raw/a84f4dd5cdde3364043e210e1bad8d50a68a1000/base.sh -o /tmp/base.sh && source /tmp/base.sh
        fi
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