#!/usr/bin/env bash
# Backup Manager Script
# Demonstrates backup operations with validation and logging

# Load bash library
source <(curl -fsSL https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh)

print_header "Backup Manager v1.0"

# Configuration
BACKUP_DIR="${BACKUP_DIR:-/tmp/backups}"
MAX_BACKUPS="${MAX_BACKUPS:-5}"

# Function to create backup
create_backup() {
    local source="$1"
    local timestamp=$(get_timestamp)
    local backup_name="backup_$(basename "$source")_$timestamp.tar.gz"
    local backup_path="$BACKUP_DIR/$backup_name"
    
    colors::info "Creating backup: $backup_name"
    
    # Create backup directory if it doesn't exist
    create_dir "$BACKUP_DIR"
    
    # Create backup
    if tar -czf "$backup_path" -C "$(dirname "$source")" "$(basename "$source")" 2>/dev/null; then
        colors::success "Backup created: $backup_path"
        logging::info "Backup created: $backup_path"
        return 0
    else
        colors::error "Failed to create backup: $backup_path"
        logging::error "Backup failed: $backup_path"
        return 1
    fi
}

# Function to list backups
list_backups() {
    colors::info "Available backups:"
    
    if ! validation::dir_exists "$BACKUP_DIR"; then
        colors::warning "Backup directory does not exist: $BACKUP_DIR"
        return 1
    fi
    
    local count=0
    while IFS= read -r -d '' file; do
        ((count++))
        local size=$(get_file_size "$file")
        local name=$(basename "$file")
        colors::info "  $count. $name ($size)"
    done < <(find "$BACKUP_DIR" -name "*.tar.gz" -print0 2>/dev/null | sort -z)
    
    if [[ $count -eq 0 ]]; then
        colors::warning "No backups found"
    fi
}

# Function to restore backup
restore_backup() {
    local backup_file="$1"
    local restore_dir="${2:-.}"
    
    if ! validation::file_exists "$backup_file"; then
        colors::error "Backup file not found: $backup_file"
        return 1
    fi
    
    if ! validation::dir_exists "$restore_dir"; then
        colors::error "Restore directory does not exist: $restore_dir"
        return 1
    fi
    
    colors::info "Restoring backup: $backup_file"
    colors::warning "This will overwrite existing files in: $restore_dir"
    
    if ! confirm "Continue with restore?" "n"; then
        colors::info "Restore cancelled"
        return 0
    fi
    
    if tar -xzf "$backup_file" -C "$restore_dir" 2>/dev/null; then
        colors::success "Backup restored successfully"
        logging::info "Backup restored: $backup_file to $restore_dir"
    else
        colors::error "Failed to restore backup"
        logging::error "Restore failed: $backup_file"
        return 1
    fi
}

# Function to cleanup old backups
cleanup_backups() {
    colors::info "Cleaning up old backups (keeping $MAX_BACKUPS latest)..."
    
    if ! validation::dir_exists "$BACKUP_DIR"; then
        colors::warning "Backup directory does not exist"
        return 0
    fi
    
    local backup_count=$(find "$BACKUP_DIR" -name "*.tar.gz" | wc -l)
    
    if [[ $backup_count -le $MAX_BACKUPS ]]; then
        colors::info "No cleanup needed ($backup_count backups, max: $MAX_BACKUPS)"
        return 0
    fi
    
    local to_delete=$((backup_count - MAX_BACKUPS))
    colors::info "Removing $to_delete old backups..."
    
    find "$BACKUP_DIR" -name "*.tar.gz" -printf '%T@ %p\n' | sort -n | head -n "$to_delete" | while read -r line; do
        local file=$(echo "$line" | cut -d' ' -f2-)
        if safe_remove "$file"; then
            colors::success "Removed: $(basename "$file")"
        fi
    done
}

# Function to show backup statistics
show_stats() {
    colors::info "Backup Statistics:"
    
    if ! validation::dir_exists "$BACKUP_DIR"; then
        colors::warning "Backup directory does not exist"
        return 1
    fi
    
    local total_backups=$(find "$BACKUP_DIR" -name "*.tar.gz" | wc -l)
    local total_size=$(find "$BACKUP_DIR" -name "*.tar.gz" -exec du -ch {} + | tail -1 | cut -f1)
    local free_space=$(get_free_space "$BACKUP_DIR")
    
    colors::info "  Total backups: $total_backups"
    colors::info "  Total size: $total_size"
    colors::info "  Free space: $free_space"
    colors::info "  Max backups: $MAX_BACKUPS"
}

# Main logic
case "${1:-}" in
    "create")
        if [[ $# -lt 2 ]]; then
            colors::error "Usage: $0 create <source_path>"
            exit 1
        fi
        create_backup "$2"
        cleanup_backups
        ;;
    "list")
        list_backups
        ;;
    "restore")
        if [[ $# -lt 2 ]]; then
            colors::error "Usage: $0 restore <backup_file> [restore_dir]"
            exit 1
        fi
        restore_backup "$2" "${3:-.}"
        ;;
    "cleanup")
        cleanup_backups
        ;;
    "stats")
        show_stats
        ;;
    *)
        colors::error "Usage: $0 {create|list|restore|cleanup|stats}"
        colors::info "Examples:"
        colors::info "  $0 create /path/to/source"
        colors::info "  $0 list"
        colors::info "  $0 restore backup_file.tar.gz /restore/path"
        colors::info "  $0 cleanup"
        colors::info "  $0 stats"
        exit 1
        ;;
esac

colors::success "Backup operation completed!" 