#!/usr/bin/env bash
# Quick Demo Script
# Simple demonstration of bash-lib features

# Load bash library
source <(curl -fsSL https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh)

print_header "Bash Library Quick Demo"

# Show library version
colors::info "Library version: $(bash_lib::version)"

print_separator

# Demonstrate colors
colors::success "This is a success message"
colors::error "This is an error message"
colors::warning "This is a warning message"
colors::info "This is an info message"
colors::debug "This is a debug message"
colors::highlight "This is highlighted text"

print_separator

# Demonstrate logging
logging::info "Starting demo script"
logging::debug "Debug information here"
logging::warn "Warning message"
logging::error "Error message (but script continues)"

print_separator

# Demonstrate validation
colors::info "Validation Examples:"

email="user@example.com"
if validation::is_email "$email"; then
    colors::success "✓ Email is valid: $email"
else
    colors::error "✗ Email is invalid: $email"
fi

number="123"
if validation::is_integer "$number"; then
    colors::success "✓ Number is valid: $number"
else
    colors::error "✗ Number is invalid: $number"
fi

port="8080"
if validation::is_port "$port"; then
    colors::success "✓ Port is valid: $port"
else
    colors::error "✗ Port is invalid: $port"
fi

print_separator

# Demonstrate system functions
colors::info "System Information:"
get_system_info

print_separator

# Demonstrate progress bar
colors::info "Progress Bar Demo:"
for i in {1..10}; do
    colors::progress_bar "$i" "10" "30" "Demo"
    sleep 0.2
done
echo

print_separator

# Demonstrate confirmation
if confirm "Do you want to continue?"; then
    colors::success "User confirmed!"
else
    colors::info "User cancelled"
fi

print_separator

# Demonstrate file operations
colors::info "File Operations:"
temp_file="/tmp/demo_$(get_timestamp).txt"
echo "Demo content" > "$temp_file"

if validation::file_exists "$temp_file"; then
    colors::success "✓ File created: $temp_file"
    colors::info "File size: $(get_file_size "$temp_file")"
    
    # Clean up
    safe_remove "$temp_file"
    colors::info "File cleaned up"
fi

print_separator

# Demonstrate internet check
colors::info "Internet Connectivity:"
if check_internet; then
    colors::success "✓ Internet connection available"
    external_ip=$(get_external_ip)
    colors::info "External IP: $external_ip"
else
    colors::error "✗ No internet connection"
fi

print_separator

# Final message
colors::success "Demo completed successfully!"
logging::info "Demo script finished" 