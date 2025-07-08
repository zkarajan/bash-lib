#!/usr/bin/env bash
# Email Validator Script
# Demonstrates email validation and batch processing

# Load bash library
source <(curl -fsSL https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh)

print_header "Email Validator v1.0"

# Function to validate single email
validate_email() {
    local email="$1"
    
    if validation::is_email "$email"; then
        colors::success "✓ Valid: $email"
        return 0
    else
        colors::error "✗ Invalid: $email"
        return 1
    fi
}

# Function to validate emails from file
validate_from_file() {
    local file="$1"
    
    if ! validation::file_exists "$file"; then
        colors::error "File not found: $file"
        return 1
    fi
    
    colors::info "Validating emails from file: $file"
    
    local valid_count=0
    local invalid_count=0
    local total_count=0
    
    while IFS= read -r email; do
        # Skip empty lines and comments
        [[ -z "$email" || "$email" =~ ^[[:space:]]*# ]] && continue
        
        ((total_count++))
        
        if validate_email "$email"; then
            ((valid_count++))
        else
            ((invalid_count++))
        fi
    done < "$file"
    
    print_separator
    colors::info "Validation Summary:"
    colors::success "Valid emails: $valid_count"
    colors::error "Invalid emails: $invalid_count"
    colors::info "Total processed: $total_count"
}

# Function to validate emails from command line
validate_from_args() {
    colors::info "Validating emails from command line arguments..."
    
    local valid_count=0
    local invalid_count=0
    
    for email in "$@"; do
        if validate_email "$email"; then
            ((valid_count++))
        else
            ((invalid_count++))
        fi
    done
    
    print_separator
    colors::info "Validation Summary:"
    colors::success "Valid emails: $valid_count"
    colors::error "Invalid emails: $invalid_count"
    colors::info "Total processed: $((valid_count + invalid_count))"
}

# Main logic
if [[ $# -eq 0 ]]; then
    colors::error "Usage: $0 <email1> [email2] ... OR $0 -f <file>"
    colors::info "Examples:"
    colors::info "  $0 user@example.com admin@test.org"
    colors::info "  $0 -f emails.txt"
    exit 1
fi

# Check if file mode
if [[ "$1" == "-f" ]]; then
    if [[ $# -lt 2 ]]; then
        colors::error "File path required after -f"
        exit 1
    fi
    validate_from_file "$2"
else
    validate_from_args "$@"
fi

colors::success "Email validation completed!" 