#!/usr/bin/env bash
# Bash Library - Standalone Version
__BASH_LIB_VERSION="1.0.0"

bash_lib::version() {
    echo "$__BASH_LIB_VERSION"
}
# Все функции в одном файле для простого подключения
# Использование: source <(curl -fsSL https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh)

# Защита от повторного импорта
[[ -n "$__BASH_LIB_IMPORTED" ]] && return
__BASH_LIB_IMPORTED=1

# =============================================================================
# ЦВЕТА
# =============================================================================

# Color codes
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly WHITE='\033[1;37m'
readonly NC='\033[0m' # No Color

# Bold colors
readonly BOLD_RED='\033[1;31m'
readonly BOLD_GREEN='\033[1;32m'
readonly BOLD_YELLOW='\033[1;33m'
readonly BOLD_BLUE='\033[1;34m'
readonly BOLD_PURPLE='\033[1;35m'
readonly BOLD_CYAN='\033[1;36m'

# Background colors
readonly BG_RED='\033[41m'
readonly BG_GREEN='\033[42m'
readonly BG_YELLOW='\033[43m'
readonly BG_BLUE='\033[44m'
readonly BG_PURPLE='\033[45m'
readonly BG_CYAN='\033[46m'

# Check if colors are supported
colors::is_supported() {
    [[ -t 1 ]] && [[ -n "$TERM" ]] && [[ "$TERM" != "dumb" ]]
}

# Print colored text
colors::print() {
    local color="$1"
    local text="$2"
    
    if colors::is_supported; then
        echo -e "${color}${text}${NC}"
    else
        echo "$text"
    fi
}

# Success message (green)
colors::success() {
    colors::print "$GREEN" "$1"
}

# Error message (red)
colors::error() {
    colors::print "$RED" "$1"
}

# Warning message (yellow)
colors::warning() {
    colors::print "$YELLOW" "$1"
}

# Info message (blue)
colors::info() {
    colors::print "$BLUE" "$1"
}

# Debug message (cyan)
colors::debug() {
    colors::print "$CYAN" "$1"
}

# Highlight text (bold)
colors::highlight() {
    colors::print "$WHITE" "$1"
}

# Print with background
colors::print_bg() {
    local bg_color="$1"
    local text="$2"
    
    if colors::is_supported; then
        echo -e "${bg_color}${text}${NC}"
    else
        echo "$text"
    fi
}

# Print colored text without newline
colors::print_n() {
    local color="$1"
    local text="$2"
    
    if colors::is_supported; then
        echo -ne "${color}${text}${NC}"
    else
        echo -n "$text"
    fi
}

# Progress bar
colors::progress_bar() {
    local current="$1"
    local total="$2"
    local width="${3:-50}"
    local label="${4:-Progress}"
    
    local percentage=$((current * 100 / total))
    local filled=$((width * current / total))
    local empty=$((width - filled))
    
    local bar=""
    for ((i=0; i<filled; i++)); do
        bar+="█"
    done
    for ((i=0; i<empty; i++)); do
        bar+="░"
    done
    
    colors::print_n "$CYAN" "\r${label}: [${bar}] ${percentage}%"
    
    if [[ "$current" -eq "$total" ]]; then
        echo
    fi
}

# =============================================================================
# ЛОГИРОВАНИЕ
# =============================================================================

# Log levels
readonly LOG_LEVEL_DEBUG=0
readonly LOG_LEVEL_INFO=1
readonly LOG_LEVEL_WARN=2
readonly LOG_LEVEL_ERROR=3
readonly LOG_LEVEL_FATAL=4

# Default log level
LOG_LEVEL=${LOG_LEVEL:-$LOG_LEVEL_INFO}

# Log file (optional)
LOG_FILE=${LOG_FILE:-}

# Timestamp format
LOG_TIMESTAMP_FORMAT=${LOG_TIMESTAMP_FORMAT:-"%Y-%m-%d %H:%M:%S"}

# Get current timestamp
logging::timestamp() {
    date "+${LOG_TIMESTAMP_FORMAT}"
}

# Get log level name
logging::level_name() {
    local level="$1"
    case "$level" in
        $LOG_LEVEL_DEBUG) echo "DEBUG" ;;
        $LOG_LEVEL_INFO)  echo "INFO"  ;;
        $LOG_LEVEL_WARN)  echo "WARN"  ;;
        $LOG_LEVEL_ERROR) echo "ERROR" ;;
        $LOG_LEVEL_FATAL) echo "FATAL" ;;
        *)               echo "UNKNOWN" ;;
    esac
}

# Get log level color
logging::level_color() {
    local level="$1"
    case "$level" in
        $LOG_LEVEL_DEBUG) echo "$CYAN" ;;
        $LOG_LEVEL_INFO)  echo "$BLUE" ;;
        $LOG_LEVEL_WARN)  echo "$YELLOW" ;;
        $LOG_LEVEL_ERROR) echo "$RED" ;;
        $LOG_LEVEL_FATAL) echo "$BOLD_RED" ;;
        *)               echo "$NC" ;;
    esac
}

# Write log message
logging::write() {
    local level="$1"
    local message="$2"
    local timestamp=$(logging::timestamp)
    local level_name=$(logging::level_name "$level")
    local log_entry="[${timestamp}] [${level_name}] ${message}"
    
    # Check if we should log this level
    if [[ "$level" -ge "$LOG_LEVEL" ]]; then
        # Write to stderr with colors
        if colors::is_supported; then
            local color=$(logging::level_color "$level")
            echo -e "${color}${log_entry}${NC}" >&2
        else
            echo "$log_entry" >&2
        fi
        
        # Write to log file if specified
        if [[ -n "$LOG_FILE" ]]; then
            echo "$log_entry" >> "$LOG_FILE"
        fi
    fi
}

# Debug log
logging::debug() {
    logging::write $LOG_LEVEL_DEBUG "$1"
}

# Info log
logging::info() {
    logging::write $LOG_LEVEL_INFO "$1"
}

# Warning log
logging::warn() {
    logging::write $LOG_LEVEL_WARN "$1"
}

# Error log
logging::error() {
    logging::write $LOG_LEVEL_ERROR "$1"
}

# Fatal log (and exit)
logging::fatal() {
    logging::write $LOG_LEVEL_FATAL "$1"
    exit 1
}

# Set log level
logging::set_level() {
    local level="$1"
    case "$level" in
        debug|DEBUG) LOG_LEVEL=$LOG_LEVEL_DEBUG ;;
        info|INFO)   LOG_LEVEL=$LOG_LEVEL_INFO  ;;
        warn|WARN)   LOG_LEVEL=$LOG_LEVEL_WARN  ;;
        error|ERROR) LOG_LEVEL=$LOG_LEVEL_ERROR ;;
        fatal|FATAL) LOG_LEVEL=$LOG_LEVEL_FATAL ;;
        *)          logging::error "Invalid log level: $level" ;;
    esac
}

# Set log file
logging::set_file() {
    LOG_FILE="$1"
    # Create directory if it doesn't exist
    local dir=$(dirname "$LOG_FILE")
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
    fi
}

# =============================================================================
# ВАЛИДАЦИЯ
# =============================================================================

# Validation result constants
readonly VALIDATION_SUCCESS=0
readonly VALIDATION_ERROR=1

# Email validation regex
readonly EMAIL_REGEX='^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'

# URL validation regex
readonly URL_REGEX='^https?://[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}(/.*)?$'

# IPv4 validation regex
readonly IPV4_REGEX='^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'

# Check if string is empty
validation::is_empty() {
    local value="$1"
    [[ -z "$value" ]]
}

# Check if string is not empty
validation::is_not_empty() {
    local value="$1"
    [[ -n "$value" ]]
}

# Check if string contains only alphanumeric characters
validation::is_alphanumeric() {
    local value="$1"
    [[ "$value" =~ ^[a-zA-Z0-9]+$ ]]
}

# Check if string contains only alphabetic characters
validation::is_alphabetic() {
    local value="$1"
    [[ "$value" =~ ^[a-zA-Z]+$ ]]
}

# Check if string contains only numeric characters
validation::is_numeric() {
    local value="$1"
    [[ "$value" =~ ^[0-9]+$ ]]
}

# Check if value is a valid integer
validation::is_integer() {
    local value="$1"
    [[ "$value" =~ ^-?[0-9]+$ ]]
}

# Check if value is a valid positive integer
validation::is_positive_integer() {
    local value="$1"
    [[ "$value" =~ ^[0-9]+$ ]] && [[ "$value" -gt 0 ]]
}

# Check if value is a valid non-negative integer
validation::is_non_negative_integer() {
    local value="$1"
    [[ "$value" =~ ^[0-9]+$ ]]
}

# Check if value is a valid float
validation::is_float() {
    local value="$1"
    [[ "$value" =~ ^-?[0-9]+\.?[0-9]*$ ]] || [[ "$value" =~ ^-?[0-9]*\.?[0-9]+$ ]]
}

# Check if value is a valid positive float
validation::is_positive_float() {
    local value="$1"
    validation::is_float "$value" && (( $(echo "$value > 0" | bc -l) ))
}

# Check if value is a valid email address
validation::is_email() {
    local email="$1"
    [[ "$email" =~ $EMAIL_REGEX ]]
}

# Check if value is a valid URL
validation::is_url() {
    local url="$1"
    [[ "$url" =~ $URL_REGEX ]]
}

# Check if value is a valid IPv4 address
validation::is_ipv4() {
    local ip="$1"
    [[ "$ip" =~ $IPV4_REGEX ]]
}

# Check if value is a valid port number (1-65535)
validation::is_port() {
    local port="$1"
    validation::is_integer "$port" && [[ "$port" -ge 1 ]] && [[ "$port" -le 65535 ]]
}

# Check if value is a valid filename
validation::is_filename() {
    local filename="$1"
    [[ "$filename" =~ ^[a-zA-Z0-9._-]+$ ]] && [[ "$filename" != "." ]] && [[ "$filename" != ".." ]]
}

# Check if value is a valid directory name
validation::is_dirname() {
    local dirname="$1"
    [[ "$dirname" =~ ^[a-zA-Z0-9._-]+$ ]] && [[ "$dirname" != "." ]] && [[ "$dirname" != ".." ]]
}

# Check if value is a valid path
validation::is_path() {
    local path="$1"
    [[ "$path" =~ ^[a-zA-Z0-9._/-]+$ ]]
}

# Check if value is in range (inclusive)
validation::is_in_range() {
    local value="$1"
    local min="$2"
    local max="$3"
    
    validation::is_numeric "$value" && validation::is_numeric "$min" && validation::is_numeric "$max" && \
    [[ "$value" -ge "$min" ]] && [[ "$value" -le "$max" ]]
}

# Check if value matches regex pattern
validation::matches_pattern() {
    local value="$1"
    local pattern="$2"
    [[ "$value" =~ $pattern ]]
}

# Check if value has minimum length
validation::has_min_length() {
    local value="$1"
    local min_length="$2"
    [[ ${#value} -ge "$min_length" ]]
}

# Check if value has maximum length
validation::has_max_length() {
    local value="$1"
    local max_length="$2"
    [[ ${#value} -le "$max_length" ]]
}

# Check if value has exact length
validation::has_exact_length() {
    local value="$1"
    local length="$2"
    [[ ${#value} -eq "$length" ]]
}

# Check if value is in list
validation::is_in_list() {
    local value="$1"
    shift
    local list=("$@")
    
    for item in "${list[@]}"; do
        if [[ "$value" == "$item" ]]; then
            return $VALIDATION_SUCCESS
        fi
    done
    return $VALIDATION_ERROR
}

# Check if file exists
validation::file_exists() {
    local file="$1"
    [[ -f "$file" ]]
}

# Check if directory exists
validation::dir_exists() {
    local dir="$1"
    [[ -d "$dir" ]]
}

# Check if file is readable
validation::is_readable() {
    local file="$1"
    [[ -r "$file" ]]
}

# Check if file is writable
validation::is_writable() {
    local file="$1"
    [[ -w "$file" ]]
}

# Check if file is executable
validation::is_executable() {
    local file="$1"
    [[ -x "$file" ]]
}

# Validate with custom function
validation::custom() {
    local value="$1"
    local validator_func="$2"
    
    if declare -F "$validator_func" >/dev/null; then
        "$validator_func" "$value"
    else
        return $VALIDATION_ERROR
    fi
}

# Validate multiple conditions (AND)
validation::all() {
    local value="$1"
    shift
    local validators=("$@")
    
    for validator in "${validators[@]}"; do
        if ! "$validator" "$value"; then
            return $VALIDATION_ERROR
        fi
    done
    return $VALIDATION_SUCCESS
}

# Validate multiple conditions (OR)
validation::any() {
    local value="$1"
    shift
    local validators=("$@")
    
    for validator in "${validators[@]}"; do
        if "$validator" "$value"; then
            return $VALIDATION_SUCCESS
        fi
    done
    return $VALIDATION_ERROR
}

# Validate and return error message
validation::validate_with_message() {
    local value="$1"
    local validator="$2"
    local error_message="$3"
    
    if ! "$validator" "$value"; then
        echo "$error_message"
        return $VALIDATION_ERROR
    fi
    return $VALIDATION_SUCCESS
}

# =============================================================================
# ДОПОЛНИТЕЛЬНЫЕ УТИЛИТЫ
# =============================================================================

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
        colors::error "Этот скрипт должен быть запущен с правами root"
        exit 1
    fi
}

# Функция для создания директории с проверкой
create_dir() {
    local dir="$1"
    if [[ ! -d "$dir" ]]; then
        mkdir -p "$dir"
        logging::info "Создана директория: $dir"
    else
        logging::debug "Директория уже существует: $dir"
    fi
}

# Функция для безопасного удаления файла
safe_remove() {
    local file="$1"
    if [[ -f "$file" ]]; then
        rm -f "$file"
        logging::info "Удален файл: $file"
    else
        logging::debug "Файл не найден: $file"
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
    logging::info "Информация о системе:"
    echo -e "${CYAN}ОС:${NC} $(uname -s)"
    echo -e "${CYAN}Версия:${NC} $(uname -r)"
    echo -e "${CYAN}Архитектура:${NC} $(uname -m)"
    echo -e "${CYAN}Хост:${NC} $(hostname)"
    echo -e "${CYAN}Пользователь:${NC} $(whoami)"
}

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
    logging::info "Время выполнения: $(format_duration $duration)"
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
    logging::info "Логирование включено: $log_file"
}

# =============================================================================
# СОВМЕСТИМОСТЬ СО СТАРЫМИ ФУНКЦИЯМИ
# =============================================================================

# Совместимость с твоими старыми функциями
log_info() { logging::info "$1"; }
log_warn() { logging::warn "$1"; }
log_error() { logging::error "$1"; }
log_debug() { logging::debug "$1"; }
log_success() { colors::success "$1"; }
log_fail() { colors::error "$1"; }

# Совместимость с проверками
file_exists() { validation::file_exists "$1"; }
dir_exists() { validation::dir_exists "$1"; }

# =============================================================================
# ИНИЦИАЛИЗАЦИЯ
# =============================================================================

# Экспортируем переменную для проверки импорта
export __BASH_LIB_IMPORTED=1

# Логируем загрузку библиотеки
logging::debug "Bash Library Standalone загружена"

# CLI интерфейс (если скрипт запущен напрямую)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    case "${1:-}" in
        --version|-v)
            echo "bash-lib version $__BASH_LIB_VERSION"
            exit 0
            ;;
        --info|-i)
            echo "Bash Library v$__BASH_LIB_VERSION"
            echo "Standalone version with all core functions"
            echo "Available modules: colors, logging, validation, system utilities"
            echo "Usage: source <(curl -fsSL https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh)"
            exit 0
            ;;
        --help|-h)
            echo "Bash Library - Standalone Version"
            echo
            echo "Usage:"
            echo "  source <(curl -fsSL https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh)"
            echo
            echo "Options:"
            echo "  --version, -v    Show version"
            echo "  --info, -i       Show library information"
            echo "  --help, -h       Show this help"
            echo
            echo "Examples:"
            echo "  # Load library"
            echo "  source <(curl -fsSL https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh)"
            echo
            echo "  # Use functions"
            echo "  colors::success 'Hello World'"
            echo "  logging::info 'Script started'"
            echo "  validation::is_email 'user@example.com'"
            exit 0
            ;;
        *)
            echo "Bash Library - Standalone Version"
            echo "Use --help for usage information"
            exit 0
            ;;
    esac
fi 