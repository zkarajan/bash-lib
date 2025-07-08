#!/usr/bin/env bash
# System Monitor Script
# Demonstrates system information gathering and monitoring

# Load bash library
source <(curl -fsSL https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh)

print_header "System Monitor v1.0"

# Check if running as root
if [[ $EUID -eq 0 ]]; then
    colors::warning "Running as root - some information may be limited"
fi

# Get system information
get_system_info

print_separator

# Check internet connectivity
colors::info "Checking internet connectivity..."
if check_internet; then
    colors::success "Internet connection: OK"
    external_ip=$(get_external_ip)
    colors::info "External IP: $external_ip"
else
    colors::error "Internet connection: FAILED"
fi

print_separator

# Disk usage
colors::info "Disk Usage:"
df -h | grep -E '^/dev/' | while read -r line; do
    device=$(echo "$line" | awk '{print $1}')
    size=$(echo "$line" | awk '{print $2}')
    used=$(echo "$line" | awk '{print $3}')
    available=$(echo "$line" | awk '{print $4}')
    mount=$(echo "$line" | awk '{print $6}')
    
    colors::info "  $device ($mount): $used/$size used, $available available"
done

print_separator

# Memory usage
colors::info "Memory Usage:"
free -h | grep -E '^Mem:' | while read -r line; do
    total=$(echo "$line" | awk '{print $2}')
    used=$(echo "$line" | awk '{print $3}')
    free=$(echo "$line" | awk '{print $4}')
    
    colors::info "  Total: $total, Used: $used, Free: $free"
done

print_separator

# Process count
process_count=$(ps aux | wc -l)
colors::info "Running processes: $process_count"

# Top processes by CPU
colors::info "Top 5 processes by CPU usage:"
ps aux --sort=-%cpu | head -6 | tail -5 | while read -r line; do
    user=$(echo "$line" | awk '{print $1}')
    pid=$(echo "$line" | awk '{print $2}')
    cpu=$(echo "$line" | awk '{print $3}')
    command=$(echo "$line" | awk '{for(i=11;i<=NF;i++) printf "%s ", $i; print ""}')
    
    colors::debug "  $user ($pid): $cpu% - $command"
done

colors::success "System monitoring completed!" 