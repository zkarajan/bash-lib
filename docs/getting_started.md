# Getting Started with Bash Library

## 🚀 Quick Start

### 1. Installation

#### Automatic Installation (Recommended)
```bash
# Clone repository
git clone https://github.com/mrvi0/bash-lib.git
cd bash-lib

# Install library
sudo ./scripts/install.sh

# Activate in current session
source ~/.bashrc
```

#### Manual Installation
```bash
# Create directories
sudo mkdir -p /usr/local/lib/bash-lib
sudo mkdir -p /usr/local/bin

# Copy files
sudo cp -r src /usr/local/lib/bash-lib/
sudo cp bash-lib.sh /usr/local/lib/bash-lib/

# Create symlink
sudo ln -sf /usr/local/lib/bash-lib/bash-lib.sh /usr/local/bin/bash-lib

# Add to .bashrc
echo 'source /usr/local/lib/bash-lib/bash-lib.sh' >> ~/.bashrc
source ~/.bashrc
```

### 2. Verify Installation

```bash
# Check version
bash-lib --version

# Show library information
bash-lib --info

# Run examples
./examples/basic_usage.sh

# Run tests
./tests/unit/test_core.sh
```

## 📝 Your First Script

Create a file `my_script.sh`:

```bash
#!/usr/bin/env bash
# My first script with bash-lib

# Load library (standalone version)
source <(curl -fsSL https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh)

# Setup logging
logging::set_level info
logging::set_file "/tmp/my_script.log"

# Main logic
logging::info "Script started"

# Validate arguments
if [[ $# -eq 0 ]]; then
    colors::error "Email required"
    logging::error "Email not provided"
    exit 1
fi

email="$1"

# Validate email
if ! validation::is_email "$email"; then
    colors::error "Invalid email format: $email"
    logging::error "Email validation failed: $email"
    exit 1
fi

colors::success "Email is valid: $email"
logging::info "Processing email: $email"

# Simulate processing
for i in {1..5}; do
    colors::progress_bar "$i" "5" "30" "Processing"
    sleep 0.5
done

colors::success "Script completed successfully"
logging::info "Script completed"
```

Make the script executable and run:

```bash
chmod +x my_script.sh
./my_script.sh user@example.com
```

## 🎯 Core Functions

### Colored Output
```bash
colors::success "Successful operation"
colors::error "Error"
colors::warning "Warning"
colors::info "Information"
colors::debug "Debug information"
colors::highlight "Highlighted text"
```

### Logging
```bash
# Set logging level
logging::set_level debug  # debug, info, warn, error, fatal

# Logging
logging::info "Information message"
logging::debug "Debug information"
logging::warn "Warning"
logging::error "Error"
logging::fatal "Critical error (with exit)"

# Logging to file
logging::set_file "/var/log/myapp.log"
```

### Validation
```bash
# Email validation
validation::is_email "user@example.com"

# Number validation
validation::is_integer "123"
validation::is_positive_integer "456"
validation::is_in_range "50" "1" "100"

# Port validation
validation::is_port "8080"

# File validation
validation::file_exists "/path/to/file"
validation::is_readable "/path/to/file"

# Combined validation
validation::all "test@example.com" validation::is_email validation::is_not_empty
```

## 🔧 Configuration

### Environment Variables
```bash
# Logging level
export LOG_LEVEL=debug

# Log file
export LOG_FILE="/var/log/myapp.log"

# Timestamp format
export LOG_TIMESTAMP_FORMAT="%Y-%m-%d %H:%M:%S"
```

### In .bashrc
```bash
# Bash Library Configuration
export BASH_LIB_DIR="/usr/local/lib/bash-lib"
source "$BASH_LIB_DIR/bash-lib.sh"

# Default settings
export LOG_LEVEL=info
```

## 🧪 Testing

### Run Tests
```bash
# All tests
./tests/unit/test_core.sh

# Examples
./examples/basic_usage.sh
```

### Create Your Own Tests
```bash
#!/usr/bin/env bash
# test_my_function.sh

source "$(dirname "$0")/../../bash-lib.sh"

# Test function
test_my_function() {
    local result=$(my_function "test")
    if [[ "$result" == "expected" ]]; then
        colors::success "Test passed"
        return 0
    else
        colors::error "Test failed"
        return 1
    fi
}

# Run test
test_my_function
```

## 📚 Next Steps

1. **Study examples** in the `examples/` directory
2. **Read documentation** in the `docs/` directory
3. **Look at source code** in the `src/` directory
4. **Create your own modules** following existing patterns
5. **Add tests** for your functions

## 🆘 Getting Help

- **Documentation**: `docs/`
- **Examples**: `examples/`
- **Source Code**: `src/`
- **Tests**: `tests/`
- **Issues**: [GitHub Issues](https://github.com/mrvi0/bash-lib/issues)

## 🔄 Updating

```bash
# Update library
cd bash-lib
git pull origin main

# Reinstall
sudo ./scripts/install.sh
```

## 🌍 Language Support

- 🇺🇸 [English](../README.md)
- 🇷🇺 [Русский](ru/README.md) 