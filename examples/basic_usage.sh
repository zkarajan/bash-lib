#!/usr/bin/env bash
# Basic Usage Example for Bash Library
# This script demonstrates how to use the core modules

# Source the bash library
source "$(dirname "$0")/../bash-lib.sh"

# Set log level to debug for this example
logging::set_level debug

echo "=== Bash Library Basic Usage Example ==="
echo

# Show library information
echo "Library Info:"
bash_lib::info
echo

# List available modules
echo "Available Modules:"
bash_lib::list_modules
echo

# Colors example
echo "=== Colors Example ==="
colors::success "This is a success message"
colors::error "This is an error message"
colors::warning "This is a warning message"
colors::info "This is an info message"
colors::debug "This is a debug message"
colors::highlight "This is highlighted text"
echo

# Logging example
echo "=== Logging Example ==="
logging::info "Starting the example script"
logging::debug "Debug information: script is running"
logging::warn "Warning: this is just an example"
logging::error "Error: this is a simulated error"
echo

# Validation example
echo "=== Validation Example ==="

# Email validation
email="user@example.com"
if validation::is_email "$email"; then
    colors::success "✓ '$email' is a valid email"
else
    colors::error "✗ '$email' is not a valid email"
fi

# Integer validation
number="123"
if validation::is_integer "$number"; then
    colors::success "✓ '$number' is a valid integer"
else
    colors::error "✗ '$number' is not a valid integer"
fi

# Range validation
value="50"
if validation::is_in_range "$value" "1" "100"; then
    colors::success "✓ '$value' is in range 1-100"
else
    colors::error "✗ '$value' is not in range 1-100"
fi

# Port validation
port="8080"
if validation::is_port "$port"; then
    colors::success "✓ '$port' is a valid port number"
else
    colors::error "✗ '$port' is not a valid port number"
fi

# File existence validation
script_file="$0"
if validation::file_exists "$script_file"; then
    colors::success "✓ File exists: $script_file"
else
    colors::error "✗ File does not exist: $script_file"
fi

echo

# Progress bar example
echo "=== Progress Bar Example ==="
for i in {1..10}; do
    colors::progress_bar "$i" "10" "30" "Processing"
    sleep 0.1
done
echo

# Combined example
echo "=== Combined Example ==="
logging::info "Processing user input"

# Simulate user input
user_input="test@example.com"

# Validate input
if validation::is_email "$user_input"; then
    colors::success "Valid email provided: $user_input"
    logging::info "Email validation passed"
else
    colors::error "Invalid email provided: $user_input"
    logging::error "Email validation failed"
    exit 1
fi

# Check if it's a common domain
common_domains=("gmail.com" "yahoo.com" "hotmail.com" "example.com")
if validation::is_in_list "$user_input" "${common_domains[@]}"; then
    colors::info "Email is from a common domain"
else
    colors::warning "Email is from an uncommon domain"
fi

echo
logging::info "Example completed successfully"
colors::success "All examples completed!" 