#!/usr/bin/env bash
# Universal library loading method

# Function for universal bash-lib loading
load_bash_lib() {
    local remote_url="https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh"
    local cache_dir="$HOME/.cache/bash-lib"
    local cache_file="$cache_dir/bash-lib-standalone.sh"
    local local_file="./bash-lib-standalone.sh"
    
    # Check if library is already loaded
    if [[ -n "$__BASH_LIB_IMPORTED" ]]; then
        return 0
    fi
    
    # Method 1: Local file in current directory
    if [[ -f "$local_file" ]]; then
        echo "Loading local version of library..."
        source "$local_file"
        return 0
    fi
    
    # Method 2: Cached version (if not outdated)
    if [[ -f "$cache_file" ]] && [[ $(($(date +%s) - $(stat -c %Y "$cache_file"))) -lt 86400 ]]; then
        echo "Loading library from cache..."
        source "$cache_file"
        return 0
    fi
    
    # Method 3: Download and cache
    echo "Loading library from GitHub..."
    mkdir -p "$cache_dir"
    if curl -fsSL "$remote_url" -o "$cache_file"; then
        source "$cache_file"
        return 0
    fi
    
    # Method 4: Direct loading without caching
    echo "Direct library loading..."
    source <(curl -fsSL "$remote_url")
}

# Load library
load_bash_lib

# Now you can use all functions
print_header "Universal Script"
logging::info "Library loaded using universal method"
colors::success "Ready to work!" 