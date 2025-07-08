#!/usr/bin/env bash
# Пример с локальным кэшированием библиотеки

# Функция для загрузки библиотеки с кэшированием
load_bash_lib() {
    local cache_dir="$HOME/.cache/bash-lib"
    local cache_file="$cache_dir/bash-lib-standalone.sh"
    local remote_url="https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh"
    
    # Создать директорию кэша если не существует
    mkdir -p "$cache_dir"
    
    # Проверить, есть ли кэш и он не устарел (24 часа)
    if [[ -f "$cache_file" ]] && [[ $(($(date +%s) - $(stat -c %Y "$cache_file"))) -lt 86400 ]]; then
        echo "Загружаем библиотеку из кэша..."
        source "$cache_file"
    else
        echo "Загружаем библиотеку с GitHub..."
        if curl -fsSL "$remote_url" -o "$cache_file"; then
            source "$cache_file"
        else
            echo "Ошибка загрузки библиотеки"
            exit 1
        fi
    fi
}

# Загрузить библиотеку
load_bash_lib

# Теперь можно использовать все функции
print_header "Скрипт с кэшированием"
logging::info "Библиотека загружена из кэша"
colors::success "Готово к работе!" 