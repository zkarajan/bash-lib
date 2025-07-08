# Bash Library - Рекомендуемая структура проекта

## 📁 Структура директорий

```
bash-lib/
├── src/                          # Основной код библиотеки
│   ├── core/                     # Базовые функции
│   │   ├── logging.sh           # Функции логирования
│   │   ├── colors.sh            # Цветной вывод
│   │   ├── validation.sh        # Валидация данных
│   │   └── utils.sh             # Общие утилиты
│   ├── io/                      # Работа с файлами и вводом/выводом
│   │   ├── file_ops.sh          # Операции с файлами
│   │   ├── json.sh              # Работа с JSON
│   │   └── csv.sh               # Работа с CSV
│   ├── system/                  # Системные функции
│   │   ├── process.sh           # Управление процессами
│   │   ├── network.sh           # Сетевые функции
│   │   └── os.sh                # OS-специфичные функции
│   ├── development/             # Функции для разработки
│   │   ├── git.sh               # Git утилиты
│   │   ├── docker.sh            # Docker утилиты
│   │   └── testing.sh           # Тестирование
│   └── database/                # Работа с БД
│       ├── postgresql.sh        # PostgreSQL
│       └── mysql.sh             # MySQL
├── examples/                     # Примеры использования
│   ├── basic_usage.sh
│   ├── advanced_usage.sh
│   └── real_world_examples/
├── tests/                        # Тесты
│   ├── unit/
│   └── integration/
├── docs/                         # Документация
│   ├── api_reference.md
│   ├── getting_started.md
│   └── best_practices.md
├── scripts/                      # Готовые скрипты
│   ├── install.sh               # Установка библиотеки
│   └── uninstall.sh             # Удаление
├── .bashrc.example              # Пример настройки .bashrc
├── bash-lib.sh                  # Главный файл для импорта
└── README.md
```

## 🎯 Ключевые принципы

### 1. **Модульность**
- Каждый файл содержит логически связанные функции
- Функции можно импортировать по отдельности
- Минимальные зависимости между модулями

### 2. **Переиспользуемость**
- Функции должны быть универсальными
- Параметризация через аргументы
- Возврат значений через stdout или exit codes

### 3. **Совместимость**
- Поддержка bash 4.0+
- Кросс-платформенность (Linux, macOS)
- Graceful degradation для старых версий

### 4. **Документация**
- Подробные комментарии в коде
- Примеры использования
- API документация

## 📋 Приоритетные модули для разработки

### Phase 1: Основы
- [ ] `core/logging.sh` - Логирование
- [ ] `core/colors.sh` - Цветной вывод
- [ ] `core/validation.sh` - Валидация
- [ ] `io/file_ops.sh` - Работа с файлами

### Phase 2: Системные функции
- [ ] `system/process.sh` - Процессы
- [ ] `system/network.sh` - Сеть
- [ ] `development/git.sh` - Git утилиты

### Phase 3: Специализированные модули
- [ ] `io/json.sh` - JSON обработка
- [ ] `database/postgresql.sh` - PostgreSQL
- [ ] `development/docker.sh` - Docker

## 🔧 Технические требования

- **Лицензия**: MIT
- **Минимальная версия bash**: 4.0
- **Тестирование**: BATS (Bash Automated Testing System)
- **Документация**: Markdown + inline comments
- **Установка**: Через git clone или package manager 