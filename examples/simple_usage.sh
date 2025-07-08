#!/usr/bin/env bash
# Simple bash-lib usage example
# One-line library connection

# Load the entire library
source <(curl -fsSL https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh)

print_header "Simple bash-lib Example"

# Show header
print_header "My Script"

# Logging
logging::info "Script started"
logging::debug "Debug information"

# Colored output
colors::success "Operation successful!"
colors::warning "Warning message"
colors::info "Information message"

# Validation
email="test@example.com"
if validation::is_email "$email"; then
    colors::success "✓ Email is valid: $email"
else
    colors::error "✗ Invalid email: $email"
fi

# Check arguments
if [[ $# -eq 0 ]]; then
    colors::error "Filename required"
    exit 1
fi

filename="$1"

# Check file
if validation::file_exists "$filename"; then
    colors::success "✓ File exists: $filename"
    size=$(get_file_size "$filename")
    colors::info "File size: $size"
else
    colors::warning "✗ File not found: $filename"
fi

# Confirm action
if confirm "Continue execution?"; then
    colors::success "User confirmed action"
else
    colors::info "User cancelled action"
fi

# Progress bar
echo "Processing..."
for i in {1..5}; do
    colors::progress_bar "$i" "5" "30" "Processing"
    sleep 0.5
done

# System information
if confirm "Show system information?" "n"; then
    get_system_info
fi

# Internet check
if check_internet; then
    colors::success "Internet is available"
    ip=$(get_external_ip)
    colors::info "External IP: $ip"
else
    colors::warning "Internet is unavailable"
fi

print_header "Script completed"
colors::success "All operations completed successfully!" 