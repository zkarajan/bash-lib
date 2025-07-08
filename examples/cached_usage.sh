#!/usr/bin/env bash
# Example with local library caching

# Function to load library with caching
load_bash_lib() {
    local cache_dir="$HOME/.cache/bash-lib"
    local cache_file="$cache_dir/bash-lib-standalone.sh"
    local remote_url="https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh"
    
    # Create cache directory if it doesn't exist
    mkdir -p "$cache_dir"
    
    # Check if cache exists and is not outdated (24 hours)
    if [[ -f "$cache_file" ]] && [[ $(($(date +%s) - $(stat -c %Y "$cache_file"))) -lt 86400 ]]; then
        echo "Loading library from cache..."
        source "$cache_file"
    else
        echo "Loading library from GitHub..."
        if curl -fsSL "$remote_url" -o "$cache_file"; then
            source "$cache_file"
        else
            echo "Error loading library"
            exit 1
        fi
    fi
}

# Load library
load_bash_lib

# Now you can use all functions
print_header "Script with caching"
logging::info "Library loaded from cache"
colors::success "Ready to work!" 