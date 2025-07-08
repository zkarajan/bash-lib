# Начало работы с Bash Library

## 🚀 Быстрый старт

### 1. Установка

#### Автоматическая установка (рекомендуется)
```bash
# Клонировать репозиторий
git clone https://github.com/mrvi0/bash-lib.git
cd bash-lib

# Установить библиотеку
sudo ./scripts/install.sh

# Активировать в текущей сессии
source ~/.bashrc
```

#### Ручная установка
```bash
# Создать директории
sudo mkdir -p /usr/local/lib/bash-lib
sudo mkdir -p /usr/local/bin

# Скопировать файлы
sudo cp -r src /usr/local/lib/bash-lib/
sudo cp bash-lib.sh /usr/local/lib/bash-lib/

# Создать симлинк
sudo ln -sf /usr/local/lib/bash-lib/bash-lib.sh /usr/local/bin/bash-lib

# Добавить в .bashrc
echo 'source /usr/local/lib/bash-lib/bash-lib.sh' >> ~/.bashrc
source ~/.bashrc
```

### 2. Проверка установки

```bash
# Проверить версию
bash-lib --version

# Показать информацию о библиотеке
bash-lib --info

# Запустить примеры
./examples/basic_usage.sh

# Запустить тесты
./tests/unit/test_core.sh
```

## 📝 Первый скрипт

Создайте файл `my_script.sh`:

```bash
#!/usr/bin/env bash
# Мой первый скрипт с bash-lib

# Подключить библиотеку (standalone версия)
source <(curl -fsSL https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh)

# Настроить логирование
logging::set_level info
logging::set_file "/tmp/my_script.log"

# Основная логика
logging::info "Скрипт запущен"

# Валидация аргументов
if [[ $# -eq 0 ]]; then
    colors::error "Необходимо указать email"
    logging::error "Email не указан"
    exit 1
fi

email="$1"

# Валидация email
if ! validation::is_email "$email"; then
    colors::error "Неверный формат email: $email"
    logging::error "Валидация email не прошла: $email"
    exit 1
fi

colors::success "Email валиден: $email"
logging::info "Обработка email: $email"

# Имитация обработки
for i in {1..5}; do
    colors::progress_bar "$i" "5" "30" "Обработка"
    sleep 0.5
done

colors::success "Скрипт завершен успешно"
logging::info "Скрипт завершен"
```

Сделайте скрипт исполняемым и запустите:

```bash
chmod +x my_script.sh
./my_script.sh user@example.com
```

## 🎯 Основные функции

### Цветной вывод
```bash
colors::success "Успешная операция"
colors::error "Ошибка"
colors::warning "Предупреждение"
colors::info "Информация"
colors::debug "Отладочная информация"
colors::highlight "Выделенный текст"
```

### Логирование
```bash
# Установить уровень логирования
logging::set_level debug  # debug, info, warn, error, fatal

# Логирование
logging::info "Информационное сообщение"
logging::debug "Отладочная информация"
logging::warn "Предупреждение"
logging::error "Ошибка"
logging::fatal "Критическая ошибка (с выходом)"

# Логирование в файл
logging::set_file "/var/log/myapp.log"
```

### Валидация
```bash
# Проверка email
validation::is_email "user@example.com"

# Проверка чисел
validation::is_integer "123"
validation::is_positive_integer "456"
validation::is_in_range "50" "1" "100"

# Проверка порта
validation::is_port "8080"

# Проверка файлов
validation::file_exists "/path/to/file"
validation::is_readable "/path/to/file"

# Комбинированная проверка
validation::all "test@example.com" validation::is_email validation::is_not_empty
```

## 🔧 Настройка

### Переменные окружения
```bash
# Уровень логирования
export LOG_LEVEL=debug

# Файл логов
export LOG_FILE="/var/log/myapp.log"

# Формат временной метки
export LOG_TIMESTAMP_FORMAT="%Y-%m-%d %H:%M:%S"
```

### В .bashrc
```bash
# Bash Library Configuration
export BASH_LIB_DIR="/usr/local/lib/bash-lib"
source "$BASH_LIB_DIR/bash-lib.sh"

# Настройки по умолчанию
export LOG_LEVEL=info
```

## 🧪 Тестирование

### Запуск тестов
```bash
# Все тесты
./tests/unit/test_core.sh

# Примеры
./examples/basic_usage.sh
```

### Создание собственных тестов
```bash
#!/usr/bin/env bash
# test_my_function.sh

source "$(dirname "$0")/../../bash-lib.sh"

# Тест функции
test_my_function() {
    local result=$(my_function "test")
    if [[ "$result" == "expected" ]]; then
        colors::success "Test passed"
        return 0
    else
        colors::error "Test failed"
        return 1
    fi
}

# Запуск теста
test_my_function
```

## 📚 Следующие шаги

1. **Изучите примеры** в директории `examples/`
2. **Прочитайте документацию** в директории `docs/`
3. **Посмотрите исходный код** в директории `src/`
4. **Создайте свои модули** по образцу существующих
5. **Добавьте тесты** для ваших функций

## 🆘 Получение помощи

- **Документация**: `docs/`
- **Примеры**: `examples/`
- **Исходный код**: `src/`
- **Тесты**: `tests/`
- **Issues**: [GitHub Issues](https://github.com/mrvi0/bash-lib/issues)

## 🔄 Обновление

```bash
# Обновить библиотеку
cd bash-lib
git pull origin main

# Переустановить
sudo ./scripts/install.sh
```

## 🌍 Поддержка языков

- 🇺🇸 [English](../getting_started.md)
- 🇷🇺 [Русский](getting_started.md) (текущий) 