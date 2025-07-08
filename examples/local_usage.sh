#!/usr/bin/env bash
# Пример с проверкой локального файла

# Функция для загрузки библиотеки с приоритетом локального файла
load_bash_lib() {
    local local_file="./bash-lib-standalone.sh"
    local remote_url="https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh"
    
    # Сначала попробовать локальный файл
    if [[ -f "$local_file" ]]; then
        echo "Загружаем локальную версию библиотеки..."
        source "$local_file"
    else
        echo "Локальный файл не найден, загружаем с GitHub..."
        source <(curl -fsSL "$remote_url")
    fi
}

# Загрузить библиотеку
load_bash_lib

# Теперь можно использовать все функции
print_header "Скрипт с локальным файлом"
logging::info "Библиотека загружена"
colors::success "Готово к работе!" 