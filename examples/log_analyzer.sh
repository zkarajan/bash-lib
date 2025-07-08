#!/usr/bin/env bash
# Log Analyzer Script
# Demonstrates log file analysis and reporting

# Load bash library
source <(curl -fsSL https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh)

print_header "Log Analyzer v1.0"

# Configuration
LOG_LEVELS=("ERROR" "WARN" "INFO" "DEBUG")
SEVERITY_COLORS=("$RED" "$YELLOW" "$BLUE" "$CYAN")

# Function to analyze log file
analyze_log() {
    local log_file="$1"
    
    if ! validation::file_exists "$log_file"; then
        colors::error "Log file not found: $log_file"
        return 1
    fi
    
    if ! validation::is_readable "$log_file"; then
        colors::error "Log file is not readable: $log_file"
        return 1
    fi
    
    colors::info "Analyzing log file: $log_file"
    
    # Get file size
    local file_size=$(get_file_size "$log_file")
    colors::info "File size: $file_size"
    
    # Count total lines
    local total_lines=$(wc -l < "$log_file")
    colors::info "Total lines: $total_lines"
    
    print_separator
    
    # Analyze by log level
    colors::info "Log Level Analysis:"
    
    local level_counts=()
    local i=0
    
    for level in "${LOG_LEVELS[@]}"; do
        local count=$(grep -i "\\b$level\\b" "$log_file" | wc -l)
        level_counts+=("$count")
        
        local color="${SEVERITY_COLORS[$i]}"
        echo -e "${color}$level: $count${NC}"
        
        ((i++))
    done
    
    print_separator
    
    # Show top error messages
    colors::info "Top 5 Error Messages:"
    grep -i "\\bERROR\\b" "$log_file" | sort | uniq -c | sort -nr | head -5 | while read -r count message; do
        colors::error "  $count: $message"
    done
    
    print_separator
    
    # Show recent activity (last 10 lines)
    colors::info "Recent Activity (last 10 lines):"
    tail -10 "$log_file" | while read -r line; do
        if [[ "$line" =~ ERROR ]]; then
            colors::error "  $line"
        elif [[ "$line" =~ WARN ]]; then
            colors::warning "  $line"
        elif [[ "$line" =~ INFO ]]; then
            colors::info "  $line"
        else
            echo "  $line"
        fi
    done
    
    print_separator
    
    # Calculate statistics
    local error_count="${level_counts[0]}"
    local warn_count="${level_counts[1]}"
    local info_count="${level_counts[2]}"
    local debug_count="${level_counts[3]}"
    
    colors::info "Statistics:"
    colors::error "  Error rate: $((error_count * 100 / total_lines))%"
    colors::warning "  Warning rate: $((warn_count * 100 / total_lines))%"
    colors::info "  Info rate: $((info_count * 100 / total_lines))%"
    colors::debug "  Debug rate: $((debug_count * 100 / total_lines))%"
}

# Function to search for patterns
search_patterns() {
    local log_file="$1"
    shift
    local patterns=("$@")
    
    if ! validation::file_exists "$log_file"; then
        colors::error "Log file not found: $log_file"
        return 1
    fi
    
    colors::info "Searching for patterns in: $log_file"
    
    for pattern in "${patterns[@]}"; do
        colors::info "Searching for: $pattern"
        
        local matches=$(grep -i "$pattern" "$log_file" | wc -l)
        if [[ $matches -gt 0 ]]; then
            colors::success "Found $matches matches"
            
            # Show first 3 matches
            grep -i "$pattern" "$log_file" | head -3 | while read -r line; do
                colors::debug "  $line"
            done
        else
            colors::warning "No matches found"
        fi
        
        echo
    done
}

# Function to monitor log file in real-time
monitor_log() {
    local log_file="$1"
    local duration="${2:-60}"
    
    if ! validation::file_exists "$log_file"; then
        colors::error "Log file not found: $log_file"
        return 1
    fi
    
    colors::info "Monitoring log file: $log_file (for $duration seconds)"
    colors::info "Press Ctrl+C to stop monitoring"
    
    # Monitor with color coding
    tail -f "$log_file" | while read -r line; do
        if [[ "$line" =~ ERROR ]]; then
            colors::error "$line"
        elif [[ "$line" =~ WARN ]]; then
            colors::warning "$line"
        elif [[ "$line" =~ INFO ]]; then
            colors::info "$line"
        elif [[ "$line" =~ DEBUG ]]; then
            colors::debug "$line"
        else
            echo "$line"
        fi
    done &
    
    local monitor_pid=$!
    
    # Stop monitoring after duration
    sleep "$duration"
    kill "$monitor_pid" 2>/dev/null
    
    colors::success "Monitoring completed"
}

# Function to generate report
generate_report() {
    local log_file="$1"
    local report_file="${2:-log_report_$(get_timestamp).txt}"
    
    if ! validation::file_exists "$log_file"; then
        colors::error "Log file not found: $log_file"
        return 1
    fi
    
    colors::info "Generating report: $report_file"
    
    {
        echo "Log Analysis Report"
        echo "=================="
        echo "File: $log_file"
        echo "Generated: $(date)"
        echo "File size: $(get_file_size "$log_file")"
        echo "Total lines: $(wc -l < "$log_file")"
        echo
        echo "Log Level Summary:"
        for level in "${LOG_LEVELS[@]}"; do
            local count=$(grep -i "\\b$level\\b" "$log_file" | wc -l)
            echo "  $level: $count"
        done
        echo
        echo "Top 10 Error Messages:"
        grep -i "\\bERROR\\b" "$log_file" | sort | uniq -c | sort -nr | head -10
    } > "$report_file"
    
    colors::success "Report generated: $report_file"
    colors::info "Report size: $(get_file_size "$report_file")"
}

# Main logic
if [[ $# -eq 0 ]]; then
    colors::error "Usage: $0 <log_file> [analyze|search|monitor|report] [options...]"
    colors::info "Examples:"
    colors::info "  $0 /var/log/syslog analyze"
    colors::info "  $0 app.log search 'error' 'timeout'"
    colors::info "  $0 /var/log/nginx/access.log monitor 30"
    colors::info "  $0 app.log report custom_report.txt"
    exit 1
fi

log_file="$1"
action="${2:-analyze}"

case "$action" in
    "analyze")
        analyze_log "$log_file"
        ;;
    "search")
        shift 2
        if [[ $# -eq 0 ]]; then
            colors::error "No search patterns provided"
            exit 1
        fi
        search_patterns "$log_file" "$@"
        ;;
    "monitor")
        duration="${3:-60}"
        monitor_log "$log_file" "$duration"
        ;;
    "report")
        report_file="${3:-}"
        generate_report "$log_file" "$report_file"
        ;;
    *)
        colors::error "Invalid action: $action"
        colors::info "Valid actions: analyze, search, monitor, report"
        exit 1
        ;;
esac

colors::success "Log analysis completed!" 