#!/bin/bash
# colors.sh - Общие утилиты для bash скриптов
# Защита от повторного импорта
[[ -n "$__BASH_UTILS_IMPORTED" ]] && return
__BASH_UTILS_IMPORTED=1

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
BOLD_BLUE='\033[1;34m'
BOLD_MAGENTA='\033[1;35m'
BOLD_CYAN='\033[1;36m'
BOLD_WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Функции логирования
log_info() {
    echo -e "${GREEN}[INFO]${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*"
}

log_debug() {
    echo -e "${CYAN}[DEBUG]${NC} $*"
}

log_success() {
    echo -e "${BOLD_GREEN}[SUCCESS]${NC} $*"
}

log_fail() {
    echo -e "${BOLD_RED}[FAIL]${NC} $*"
}

# Функция для вывода заголовков
print_header() {
    local title="$1"
    local width=${2:-50}
    local char=${3:-"="}
    
    echo -e "${BOLD_CYAN}"
    printf "%*s\n" $(( (${#title} + width) / 2 )) "$title"
    printf "%*s\n" $width | tr ' ' "$char"
    echo -e "${NC}"
}

# Функция для вывода разделителей
print_separator() {
    local char=${1:-"-"}
    local width=${2:-50}
    printf "%*s\n" $width | tr ' ' "$char"
}

# Функция для подтверждения действий
confirm() {
    local message="${1:-Продолжить?}"
    local default="${2:-y}"
    
    if [[ "$default" == "y" ]]; then
        local prompt="$message [Y/n]: "
    else
        local prompt="$message [y/N]: "
    fi
    
    read -p "$prompt" -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]] || ([[ $REPLY == "" ]] && [[ "$default" == "y" ]]); then
        return 0
    else
        return 1
    fi
}

# Функция для проверки существования команды
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Функция для проверки root прав
check_root() {
    if [[ $EUID -ne 0 ]]; then
        log_error "Этот скрипт должен быть запущен с правами root"
        exit 1
    fi
}

# Функция для проверки существования файла
file_exists() {
    [[ -f "$1" ]]
}

# Функция для проверки существования директории
dir_exists() {
    [[ -d "$1" ]]
}

# Функция для создания директории с проверкой
create_dir() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        log_info "Создана директория: $dir"
    else
        log_debug "Директория уже существует: $dir"
    fi
}

# Функция для безопасного удаления файла
safe_remove() {
    local file="$1"
    if [[ -f "$file" ]]; then
        rm -f "$file"
        log_info "Удален файл: $file"
    else
        log_debug "Файл не найден: $file"
    fi
}

# Функция для получения размера файла в человекочитаемом формате
get_file_size() {
    local file="$1"
    if [[ -f "$file" ]]; then
        du -h "$file" | cut -f1
    else
        echo "0B"
    fi
}

# Функция для получения свободного места на диске
get_free_space() {
    local path="${1:-.}"
    df -h "$path" | awk 'NR==2 {print $4}'
}

# Функция для получения информации о системе
get_system_info() {
    log_info "Информация о системе:"
    echo -e "${CYAN}ОС:${NC} $(uname -s)"
    echo -e "${CYAN}Версия:${NC} $(uname -r)"
    echo -e "${CYAN}Архитектура:${NC} $(uname -m)"
    echo -e "${CYAN}Хост:${NC} $(hostname)"
    echo -e "${CYAN}Пользователь:${NC} $(whoami)"
}

# Функция для показа прогресса
show_progress() {
    local current="$1"
    local total="$2"
    local width=${3:-50}
    local percentage=$((current * 100 / total))
    local filled=$((width * current / total))
    local empty=$((width - filled))
    
    printf "\r["
    printf "%${filled}s" | tr ' ' '#'
    printf "%${empty}s" | tr ' ' '-'
    printf "] %d%%" $percentage
    
    if [[ "$current" -eq "$total" ]]; then
        echo
    fi
}

# Функция для ожидания с индикатором
wait_with_spinner() {
    local message="$1"
    local pid="$2"
    local delay=0.1
    local spinstr='|/-\'
    
    while kill -0 "$pid" 2>/dev/null; do
        local temp=${spinstr#?}
        printf "\r${CYAN}%s${NC} %c" "$message" "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
    done
    printf "\r${GREEN}%s${NC} ✓\n" "$message"
}

# Функция для обработки ошибок
handle_error() {
    local exit_code=$?
    local line_number=$1
    local script_name=${BASH_SOURCE[1]}
    
    log_error "Ошибка в $script_name на строке $line_number (код: $exit_code)"
    exit $exit_code
}

# Устанавливаем обработчик ошибок
trap 'handle_error $LINENO' ERR

# Функция для очистки при выходе
cleanup_on_exit() {
    local exit_code=$?
    log_debug "Скрипт завершен с кодом: $exit_code"
    exit $exit_code
}

# Устанавливаем обработчик выхода
trap cleanup_on_exit EXIT

# Функция для проверки подключения к интернету
check_internet() {
    if ping -c 1 8.8.8.8 >/dev/null 2>&1; then
        return 0
    else
        return 1
    fi
}

# Функция для получения внешнего IP
get_external_ip() {
    curl -s ifconfig.me 2>/dev/null || echo "Не удалось получить IP"
}

# Функция для форматирования времени выполнения
format_duration() {
    local seconds=$1
    local hours=$((seconds / 3600))
    local minutes=$(( (seconds % 3600) / 60 ))
    local secs=$((seconds % 60))
    
    if [[ $hours -gt 0 ]]; then
        printf "%02d:%02d:%02d" $hours $minutes $secs
    else
        printf "%02d:%02d" $minutes $secs
    fi
}

# Функция для логирования времени выполнения
log_execution_time() {
    local start_time=$1
    local end_time=$(date +%s)
    local duration=$((end_time - start_time))
    log_info "Время выполнения: $(format_duration $duration)"
}

# Функция для создания временной метки
get_timestamp() {
    date '+%Y%m%d_%H%M%S'
}

# Функция для создания лог-файла
setup_logging() {
    local log_file="${1:-/tmp/script_$(get_timestamp).log}"
    exec 1> >(tee -a "$log_file")
    exec 2> >(tee -a "$log_file" >&2)
    log_info "Логирование включено: $log_file"
}

# Экспортируем переменную для проверки импорта
export __BASH_UTILS_IMPORTED=1 