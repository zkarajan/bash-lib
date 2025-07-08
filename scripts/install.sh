#!/usr/bin/env bash
# Bash Library - Installation Script
# Installs bash-lib to the system for global access

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default installation directory
DEFAULT_INSTALL_DIR="/usr/local/lib/bash-lib"
DEFAULT_BIN_DIR="/usr/local/bin"

# Installation directories
INSTALL_DIR="${BASH_LIB_INSTALL_DIR:-$DEFAULT_INSTALL_DIR}"
BIN_DIR="${BASH_LIB_BIN_DIR:-$DEFAULT_BIN_DIR}"

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        print_warning "Running as root. This is not recommended for security reasons."
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_error "Installation cancelled."
            exit 1
        fi
    fi
}

# Function to check dependencies
check_dependencies() {
    print_info "Checking dependencies..."
    
    local missing_deps=()
    
    # Check for required commands
    for cmd in bash git; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            missing_deps+=("$cmd")
        fi
    done
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_error "Missing dependencies: ${missing_deps[*]}"
        print_info "Please install the missing dependencies and try again."
        exit 1
    fi
    
    # Check bash version
    local bash_version=$(bash --version | head -n1 | grep -oE '[0-9]+\.[0-9]+' | head -n1)
    if [[ $(echo "$bash_version < 4.0" | bc -l 2>/dev/null || echo "1") == "1" ]]; then
        print_warning "Bash version $bash_version detected. Bash 4.0+ is recommended."
    fi
    
    print_success "Dependencies check passed"
}

# Function to create installation directories
create_directories() {
    print_info "Creating installation directories..."
    
    if [[ ! -d "$INSTALL_DIR" ]]; then
        mkdir -p "$INSTALL_DIR"
        print_success "Created directory: $INSTALL_DIR"
    fi
    
    if [[ ! -d "$BIN_DIR" ]]; then
        mkdir -p "$BIN_DIR"
        print_success "Created directory: $BIN_DIR"
    fi
}

# Function to copy files
copy_files() {
    print_info "Copying bash-lib files..."
    
    # Copy source files
    cp -r "$PROJECT_ROOT/src" "$INSTALL_DIR/"
    print_success "Copied source files"
    
    # Copy main library file
    cp "$PROJECT_ROOT/bash-lib.sh" "$INSTALL_DIR/"
    print_success "Copied main library file"
    
    # Copy examples
    if [[ -d "$PROJECT_ROOT/examples" ]]; then
        cp -r "$PROJECT_ROOT/examples" "$INSTALL_DIR/"
        print_success "Copied examples"
    fi
    
    # Copy documentation
    if [[ -d "$PROJECT_ROOT/docs" ]]; then
        cp -r "$PROJECT_ROOT/docs" "$INSTALL_DIR/"
        print_success "Copied documentation"
    fi
    
    # Copy README
    if [[ -f "$PROJECT_ROOT/README.md" ]]; then
        cp "$PROJECT_ROOT/README.md" "$INSTALL_DIR/"
        print_success "Copied README"
    fi
}

# Function to create symlinks
create_symlinks() {
    print_info "Creating symlinks..."
    
    # Create symlink for bash-lib command
    local bash_lib_bin="$BIN_DIR/bash-lib"
    if [[ -L "$bash_lib_bin" ]]; then
        rm "$bash_lib_bin"
    fi
    ln -sf "$INSTALL_DIR/bash-lib.sh" "$bash_lib_bin"
    chmod +x "$bash_lib_bin"
    print_success "Created symlink: $bash_lib_bin"
}

# Function to create .bashrc configuration
create_bashrc_config() {
    print_info "Creating .bashrc configuration..."
    
    local bashrc_file="$HOME/.bashrc"
    local config_line="export BASH_LIB_DIR=\"$INSTALL_DIR\""
    local source_line="source \"$INSTALL_DIR/bash-lib.sh\""
    
    # Check if configuration already exists
    if grep -q "BASH_LIB_DIR" "$bashrc_file" 2>/dev/null; then
        print_warning "Bash-lib configuration already exists in $bashrc_file"
        return
    fi
    
    # Add configuration to .bashrc
    echo "" >> "$bashrc_file"
    echo "# Bash Library Configuration" >> "$bashrc_file"
    echo "$config_line" >> "$bashrc_file"
    echo "$source_line" >> "$bashrc_file"
    
    print_success "Added configuration to $bashrc_file"
    print_info "Please run 'source ~/.bashrc' or restart your terminal to activate bash-lib"
}

# Function to test installation
test_installation() {
    print_info "Testing installation..."
    
    # Test if bash-lib can be sourced
    if source "$INSTALL_DIR/bash-lib.sh" 2>/dev/null; then
        print_success "Library can be sourced successfully"
    else
        print_error "Failed to source library"
        return 1
    fi
    
    # Test if functions are available
    if declare -F colors::success >/dev/null; then
        print_success "Core functions are available"
    else
        print_error "Core functions are not available"
        return 1
    fi
    
    # Test bash-lib command
    if "$BIN_DIR/bash-lib" --version >/dev/null 2>&1; then
        print_success "bash-lib command works"
    else
        print_warning "bash-lib command test failed (this is normal if no --version flag)"
    fi
}

# Function to show installation summary
show_summary() {
    echo
    print_success "Bash Library installation completed!"
    echo
    echo "Installation Summary:"
    echo "  Library location: $INSTALL_DIR"
    echo "  Binary location: $BIN_DIR"
    echo "  Version: $(cat "$INSTALL_DIR/bash-lib.sh" | grep "BASH_LIB_VERSION=" | cut -d'"' -f2)"
    echo
    echo "Usage:"
    echo "  # In your scripts:"
    echo "  source \"$INSTALL_DIR/bash-lib.sh\""
    echo
    echo "  # Or use the command:"
    echo "  bash-lib --help"
    echo
    echo "  # Or import in your .bashrc (already done):"
    echo "  source ~/.bashrc"
    echo
    print_info "Run 'source ~/.bashrc' or restart your terminal to start using bash-lib"
}

# Function to show help
show_help() {
    echo "Bash Library Installer"
    echo
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  -d, --dir DIR     Installation directory (default: $DEFAULT_INSTALL_DIR)"
    echo "  -b, --bin DIR     Binary directory (default: $DEFAULT_BIN_DIR)"
    echo "  -h, --help        Show this help message"
    echo
    echo "Environment variables:"
    echo "  BASH_LIB_INSTALL_DIR  Installation directory"
    echo "  BASH_LIB_BIN_DIR      Binary directory"
    echo
    echo "Examples:"
    echo "  $0                                    # Install to default locations"
    echo "  $0 -d /opt/bash-lib                  # Install to custom directory"
    echo "  BASH_LIB_INSTALL_DIR=/opt $0         # Use environment variable"
}

# Main installation function
main() {
    echo "Bash Library Installer"
    echo "======================"
    echo
    
    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -d|--dir)
                INSTALL_DIR="$2"
                shift 2
                ;;
            -b|--bin)
                BIN_DIR="$2"
                shift 2
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    print_info "Installation directory: $INSTALL_DIR"
    print_info "Binary directory: $BIN_DIR"
    echo
    
    # Run installation steps
    check_root
    check_dependencies
    create_directories
    copy_files
    create_symlinks
    create_bashrc_config
    test_installation
    show_summary
}

# Run main function with all arguments
main "$@" 