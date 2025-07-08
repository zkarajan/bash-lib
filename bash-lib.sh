#!/usr/bin/env bash
# Bash Library - Main Import File
# Source this file to import all bash-lib modules

# Get the directory where this script is located
BASH_LIB_DIR="${BASH_SOURCE%/*}"

# Version information
BASH_LIB_VERSION="0.1.0"
BASH_LIB_AUTHOR="Vi"
BASH_LIB_DESCRIPTION="Bash Library - Collection of reusable bash functions and utilities"

# Import core modules
source "${BASH_LIB_DIR}/src/core/colors.sh"
source "${BASH_LIB_DIR}/src/core/logging.sh"
source "${BASH_LIB_DIR}/src/core/validation.sh"

# Initialize logging
logging::init

# Import IO modules (if they exist)
if [[ -f "${BASH_LIB_DIR}/src/io/file_ops.sh" ]]; then
    source "${BASH_LIB_DIR}/src/io/file_ops.sh"
fi

if [[ -f "${BASH_LIB_DIR}/src/io/json.sh" ]]; then
    source "${BASH_LIB_DIR}/src/io/json.sh"
fi

# Import system modules (if they exist)
if [[ -f "${BASH_LIB_DIR}/src/system/process.sh" ]]; then
    source "${BASH_LIB_DIR}/src/system/process.sh"
fi

if [[ -f "${BASH_LIB_DIR}/src/system/network.sh" ]]; then
    source "${BASH_LIB_DIR}/src/system/network.sh"
fi

if [[ -f "${BASH_LIB_DIR}/src/system/os.sh" ]]; then
    source "${BASH_LIB_DIR}/src/system/os.sh"
fi

# Import development modules (if they exist)
if [[ -f "${BASH_LIB_DIR}/src/development/git.sh" ]]; then
    source "${BASH_LIB_DIR}/src/development/git.sh"
fi

if [[ -f "${BASH_LIB_DIR}/src/development/docker.sh" ]]; then
    source "${BASH_LIB_DIR}/src/development/docker.sh"
fi

if [[ -f "${BASH_LIB_DIR}/src/development/testing.sh" ]]; then
    source "${BASH_LIB_DIR}/src/development/testing.sh"
fi

# Import database modules (if they exist)
if [[ -f "${BASH_LIB_DIR}/src/database/postgresql.sh" ]]; then
    source "${BASH_LIB_DIR}/src/database/postgresql.sh"
fi

if [[ -f "${BASH_LIB_DIR}/src/database/mysql.sh" ]]; then
    source "${BASH_LIB_DIR}/src/database/mysql.sh"
fi

# Library information functions
bash_lib::version() {
    echo "$BASH_LIB_VERSION"
}

bash_lib::info() {
    echo "Bash Library v${BASH_LIB_VERSION}"
    echo "Author: $BASH_LIB_AUTHOR"
    echo "Description: $BASH_LIB_DESCRIPTION"
    echo "Directory: $BASH_LIB_DIR"
}

bash_lib::list_modules() {
    echo "Available modules:"
    echo "  Core:"
    echo "    - colors (color output functions)"
    echo "    - logging (logging functions)"
    echo "    - validation (data validation functions)"
    
    if declare -F io::file_exists >/dev/null; then
        echo "  IO:"
        echo "    - file_ops (file operations)"
    fi
    
    if declare -F io::json_parse >/dev/null; then
        echo "    - json (JSON processing)"
    fi
    
    if declare -F system::process_exists >/dev/null; then
        echo "  System:"
        echo "    - process (process management)"
    fi
    
    if declare -F system::network_ping >/dev/null; then
        echo "    - network (network utilities)"
    fi
    
    if declare -F development::git_status >/dev/null; then
        echo "  Development:"
        echo "    - git (Git utilities)"
    fi
    
    if declare -F development::docker_status >/dev/null; then
        echo "    - docker (Docker utilities)"
    fi
    
    if declare -F database::postgresql_connect >/dev/null; then
        echo "  Database:"
        echo "    - postgresql (PostgreSQL utilities)"
    fi
    
    if declare -F database::mysql_connect >/dev/null; then
        echo "    - mysql (MySQL utilities)"
    fi
}

bash_lib::help() {
    echo "Bash Library - Usage"
    echo ""
    echo "To use bash-lib in your script:"
    echo "  source /path/to/bash-lib.sh"
    echo ""
    echo "Available commands:"
    echo "  bash_lib::version    - Show library version"
    echo "  bash_lib::info       - Show library information"
    echo "  bash_lib::list_modules - List available modules"
    echo "  bash_lib::help       - Show this help"
    echo ""
    echo "Example usage:"
    echo "  #!/usr/bin/env bash"
    echo "  source /path/to/bash-lib.sh"
    echo "  "
    echo "  logging::info 'Starting script'"
    echo "  colors::success 'Operation completed successfully'"
    echo "  if validation::is_email 'user@example.com'; then"
    echo "    echo 'Valid email'"
    echo "  fi"
}

# Log library loading
logging::debug "Bash Library v${BASH_LIB_VERSION} loaded from ${BASH_LIB_DIR}"

# Export library directory for other scripts
export BASH_LIB_DIR 