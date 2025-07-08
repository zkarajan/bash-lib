#!/usr/bin/env bash
# Универсальный способ загрузки библиотеки

# Функция для универсальной загрузки bash-lib
load_bash_lib() {
    local remote_url="https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh"
    local cache_dir="$HOME/.cache/bash-lib"
    local cache_file="$cache_dir/bash-lib-standalone.sh"
    local local_file="./bash-lib-standalone.sh"
    
    # Проверить, не загружена ли уже библиотека
    if [[ -n "$__BASH_LIB_IMPORTED" ]]; then
        return 0
    fi
    
    # Способ 1: Локальный файл в текущей директории
    if [[ -f "$local_file" ]]; then
        echo "Загружаем локальную версию библиотеки..."
        source "$local_file"
        return 0
    fi
    
    # Способ 2: Кэшированная версия (если не устарела)
    if [[ -f "$cache_file" ]] && [[ $(($(date +%s) - $(stat -c %Y "$cache_file"))) -lt 86400 ]]; then
        echo "Загружаем библиотеку из кэша..."
        source "$cache_file"
        return 0
    fi
    
    # Способ 3: Скачать и кэшировать
    echo "Загружаем библиотеку с GitHub..."
    mkdir -p "$cache_dir"
    if curl -fsSL "$remote_url" -o "$cache_file"; then
        source "$cache_file"
        return 0
    fi
    
    # Способ 4: Прямая загрузка без кэширования
    echo "Прямая загрузка библиотеки..."
    source <(curl -fsSL "$remote_url")
}

# Загрузить библиотеку
load_bash_lib

# Теперь можно использовать все функции
print_header "Универсальный скрипт"
logging::info "Библиотека загружена универсальным способом"
colors::success "Готово к работе!" 