#!/usr/bin/env bash
# Example with local file check

# Function to load library with local file priority
load_bash_lib() {
    local local_file="./bash-lib-standalone.sh"
    local remote_url="https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh"
    
    # First try local file
    if [[ -f "$local_file" ]]; then
        echo "Loading local version of library..."
        source "$local_file"
    else
        echo "Local file not found, loading from GitHub..."
        source <(curl -fsSL "$remote_url")
    fi
}

# Load library
load_bash_lib

# Now you can use all functions
print_header "Script with local file"
logging::info "Library loaded"
colors::success "Ready to work!" 