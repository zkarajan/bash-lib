#!/usr/bin/env bash
# Port Scanner Script
# Demonstrates port validation and network scanning

# Load bash library
source <(curl -fsSL https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh)

print_header "Port Scanner v1.0"

# Function to scan single port
scan_port() {
    local host="$1"
    local port="$2"
    
    # Validate port number
    if ! validation::is_port "$port"; then
        colors::error "Invalid port number: $port"
        return 1
    fi
    
    # Try to connect to port
    if timeout 3 bash -c "echo >/dev/tcp/$host/$port" 2>/dev/null; then
        colors::success "✓ Port $port is OPEN on $host"
        return 0
    else
        colors::error "✗ Port $port is CLOSED on $host"
        return 1
    fi
}

# Function to scan port range
scan_range() {
    local host="$1"
    local start_port="$2"
    local end_port="$3"
    
    # Validate port range
    if ! validation::is_port "$start_port" || ! validation::is_port "$end_port"; then
        colors::error "Invalid port range: $start_port-$end_port"
        return 1
    fi
    
    if [[ $start_port -gt $end_port ]]; then
        colors::error "Start port must be less than end port"
        return 1
    fi
    
    colors::info "Scanning ports $start_port-$end_port on $host..."
    
    local open_count=0
    local total_ports=$((end_port - start_port + 1))
    local current=0
    
    for port in $(seq "$start_port" "$end_port"); do
        ((current++))
        
        # Show progress
        colors::progress_bar "$current" "$total_ports" "40" "Scanning"
        
        if scan_port "$host" "$port" >/dev/null 2>&1; then
            ((open_count++))
        fi
    done
    
    echo
    print_separator
    colors::info "Scan Results:"
    colors::success "Open ports: $open_count"
    colors::info "Total scanned: $total_ports"
}

# Function to scan common ports
scan_common_ports() {
    local host="$1"
    local common_ports=(21 22 23 25 53 80 110 143 443 993 995 3306 5432 8080)
    
    colors::info "Scanning common ports on $host..."
    
    local open_count=0
    local total_ports=${#common_ports[@]}
    local current=0
    
    for port in "${common_ports[@]}"; do
        ((current++))
        
        # Show progress
        colors::progress_bar "$current" "$total_ports" "40" "Scanning"
        
        if scan_port "$host" "$port" >/dev/null 2>&1; then
            ((open_count++))
        fi
    done
    
    echo
    print_separator
    colors::info "Common Ports Scan Results:"
    colors::success "Open ports: $open_count"
    colors::info "Total scanned: $total_ports"
}

# Function to validate host
validate_host() {
    local host="$1"
    
    # Check if it's a valid IP or hostname
    if [[ "$host" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        # IP address format
        if validation::custom "$host" validation::is_ipv4; then
            return 0
        fi
    else
        # Hostname format
        if validation::is_not_empty "$host" && [[ "$host" =~ ^[a-zA-Z0-9.-]+$ ]]; then
            return 0
        fi
    fi
    
    return 1
}

# Main logic
if [[ $# -eq 0 ]]; then
    colors::error "Usage: $0 <host> [port|range|common]"
    colors::info "Examples:"
    colors::info "  $0 localhost 80"
    colors::info "  $0 192.168.1.1 1-100"
    colors::info "  $0 example.com common"
    exit 1
fi

host="$1"
port_arg="${2:-common}"

# Validate host
if ! validate_host "$host"; then
    colors::error "Invalid host: $host"
    exit 1
fi

# Check internet connectivity if scanning external host
if [[ "$host" != "localhost" && "$host" != "127.0.0.1" ]]; then
    if ! check_internet; then
        colors::warning "No internet connection detected"
        if ! confirm "Continue with local scan?"; then
            exit 1
        fi
    fi
fi

# Determine scan type
if [[ "$port_arg" == "common" ]]; then
    scan_common_ports "$host"
elif [[ "$port_arg" =~ ^[0-9]+$ ]]; then
    # Single port
    scan_port "$host" "$port_arg"
elif [[ "$port_arg" =~ ^[0-9]+-[0-9]+$ ]]; then
    # Port range
    start_port=$(echo "$port_arg" | cut -d'-' -f1)
    end_port=$(echo "$port_arg" | cut -d'-' -f2)
    scan_range "$host" "$start_port" "$end_port"
else
    colors::error "Invalid port specification: $port_arg"
    colors::info "Use: single port (80), range (1-100), or 'common'"
    exit 1
fi

colors::success "Port scanning completed!" 