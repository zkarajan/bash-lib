# Bash Library

A reusable bash functions and utilities library for development, deployment, and system management.

## 🌍 Language Selection

- 🇺🇸 [English](README.md) (current)
- 🇷🇺 [Русский](docs/ru/README.md)

## 📋 Table of Contents

- [🚀 Quick Start](#-quick-start)
- [🤖 AI Assistant Prompts](#-ai-assistant-prompts)
- [📦 Versioning](#-versioning)
- [📁 Project Structure](#-project-structure)
- [🎯 Core Modules](#-core-modules)
- [📚 Usage Examples](#-usage-examples)
- [🔧 Installation Methods](#-installation-methods)
- [🎯 Recommendations](#-recommendations)
- [🔧 Installation and Setup](#-installation-and-setup)
- [🧪 Testing](#-testing)
- [📖 Documentation](#-documentation)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)
- [🆘 Support](#-support)
- [🔄 Versions](#-versions)

[⬆️ Back to top](#bash-library)

## 🚀 Quick Start

### Simple Connection (No Installation)

**The easiest way** - connect the library directly in your script with one line:

```bash
#!/usr/bin/env bash
# Connect the entire library with one line
source <(curl -fsSL https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh)

# Now you can use all functions
logging::info "Script started"
colors::success "Operation completed successfully!"

if validation::is_email "user@example.com"; then
    echo "Email is valid"
fi
```

[⬆️ Back to top](#bash-library)

### Universal Method (Recommended)

For more efficient usage, create a loading function:

```bash
#!/usr/bin/env bash

# Universal bash-lib loading
load_bash_lib() {
    local remote_url="https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh"
    local cache_dir="$HOME/.cache/bash-lib"
    local cache_file="$cache_dir/bash-lib-standalone.sh"
    
    # Check if library is already loaded
    if [[ -n "$__BASH_LIB_IMPORTED" ]]; then
        return 0
    fi
    
    # Create cache directory
    mkdir -p "$cache_dir"
    
    # Use cache if not expired (24 hours)
    if [[ -f "$cache_file" ]] && [[ $(($(date +%s) - $(stat -c %Y "$cache_file"))) -lt 86400 ]]; then
        source "$cache_file"
    else
        # Download and cache
        if curl -fsSL "$remote_url" -o "$cache_file"; then
            source "$cache_file"
        else
            echo "Error loading library"
            exit 1
        fi
    fi
}

# Load library
load_bash_lib

# Use functions
logging::info "Script started"
colors::success "Ready to work!"
```

[⬆️ Back to top](#bash-library)

### Installation

```bash
# Clone repository
git clone https://github.com/mrvi0/bash-lib.git
cd bash-lib

# Install library
sudo ./scripts/install.sh

# Activate in current session
source ~/.bashrc
```

[⬆️ Back to top](#bash-library)

### Usage

```bash
#!/usr/bin/env bash
# Connect library
source /usr/local/lib/bash-lib/bash-lib.sh

# Use functions
logging::info "Starting work"
colors::success "Operation completed successfully"

if validation::is_email "user@example.com"; then
    echo "Valid email"
fi
```

[⬆️ Back to top](#bash-library)

## 🤖 AI Assistant Prompts

When asking AI assistants (like ChatGPT, Claude, etc.) to create bash scripts, you can use these prompts:

### Quick Prompt
```
Use my bash library to create a script:

Library: https://github.com/mrvi0/bash-lib
Connection: source <(curl -fsSL https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh)

Available functions:
- colors::success/error/warning/info/debug
- logging::info/error/debug/warn/fatal  
- validation::is_email/is_integer/file_exists/is_port
- confirm "question" - for confirmations
- print_header "title" - for headers
- get_system_info - system information
- check_internet - internet check

Add colored output, logging, validation, and error handling.
```

### Detailed Prompts
See `prompts/ai_usage_prompt.md` for comprehensive prompts including:
- Detailed usage instructions
- Task-specific prompts
- Debugging prompts
- Improvement prompts

[⬆️ Back to top](#bash-library)

## 📦 Versioning

Each stable version of the library is marked with a git tag.

### How to connect a specific version:

```bash
source <(curl -fsSL https://raw.githubusercontent.com/mrvi0/bash-lib/v1.0.0/bash-lib-standalone.sh)
```

### How to check current version:

```bash
bash_lib::version
```

### How to check version in script:

```bash
if [[ "$__BASH_LIB_VERSION" != "1.0.0" ]]; then
    echo "Error: bash-lib version 1.0.0 required"
    exit 1
fi
```

> See all versions on the [Releases](https://github.com/mrvi0/bash-lib/releases) tab or by git tags.

[⬆️ Back to top](#bash-library)

## 📁 Project Structure

```
bash-lib/
├── src/                          # Main library code
│   ├── core/                     # Basic functions
│   │   ├── colors.sh            # Colored output
│   │   ├── logging.sh           # Logging
│   │   └── validation.sh        # Data validation
│   ├── io/                      # File and I/O operations
│   ├── system/                  # System functions
│   ├── development/             # Development functions
│   └── database/                # Database operations
├── examples/                     # Usage examples
│   ├── basic_usage.sh          # Basic example
│   ├── simple_usage.sh         # Simple connection
│   ├── cached_usage.sh         # With caching
│   ├── local_usage.sh          # Local file
│   └── universal_usage.sh      # Universal method
├── tests/                        # Tests
├── docs/                         # Documentation
├── scripts/                      # Installation scripts
├── bash-lib.sh                  # Main import file
├── bash-lib-standalone.sh       # Single file for simple connection
└── README.md
```

[⬆️ Back to top](#bash-library)

## 🎯 Core Modules

### Core (Basic Functions)

#### Colors (`src/core/colors.sh`)
Colored terminal output with support for various colors and styles.

```bash
colors::success "Successful operation"
colors::error "Error"
colors::warning "Warning"
colors::info "Information"
colors::debug "Debug information"
colors::highlight "Highlighted text"
```

#### Logging (`src/core/logging.sh`)
Logging system with various levels and formats.

```bash
# Set logging level
logging::set_level debug

# Logging
logging::info "Information message"
logging::debug "Debug information"
logging::warn "Warning"
logging::error "Error"
logging::fatal "Critical error (with exit)"

# Logging to file
logging::set_file "/var/log/myapp.log"
```

#### Validation (`src/core/validation.sh`)
Validation of various data types.

```bash
# Email validation
validation::is_email "user@example.com"

# Integer validation
validation::is_integer "123"
validation::is_positive_integer "456"

# Range validation
validation::is_in_range "50" "1" "100"

# Port validation
validation::is_port "8080"

# File existence check
validation::file_exists "/path/to/file"

# Combined validation
validation::all "test@example.com" validation::is_email validation::is_not_empty
```

[⬆️ Back to top](#bash-library)

## 📚 Usage Examples

### Basic Example
```bash
#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh)

# Setup logging
logging::set_level info
logging::set_file "/tmp/myapp.log"

# Main logic
logging::info "Starting application"

# Input validation
if ! validation::is_email "$1"; then
    colors::error "Invalid email: $1"
    logging::error "Email validation failed"
    exit 1
fi

colors::success "Email is valid: $1"
logging::info "Application completed successfully"
```

[⬆️ Back to top](#bash-library)

### Progress Bar Example
```bash
#!/usr/bin/env bash
source <(curl -fsSL https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh)

echo "Processing files..."
for i in {1..100}; do
    colors::progress_bar "$i" "100" "30" "Processing"
    sleep 0.01
done
echo "Done!"
```

[⬆️ Back to top](#bash-library)

## 🔧 Installation Methods

### 1. Direct Download (Simplest)
```bash
source <(curl -fsSL https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh)
```
**Pros:** Very simple, always up-to-date version
**Cons:** Requires internet on each run, slower

### 2. Caching (Recommended)
```bash
load_bash_lib() {
    local cache_dir="$HOME/.cache/bash-lib"
    local cache_file="$cache_dir/bash-lib-standalone.sh"
    local remote_url="https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh"
    
    mkdir -p "$cache_dir"
    if [[ -f "$cache_file" ]] && [[ $(($(date +%s) - $(stat -c %Y "$cache_file"))) -lt 86400 ]]; then
        source "$cache_file"
    else
        curl -fsSL "$remote_url" -o "$cache_file" && source "$cache_file"
    fi
}
load_bash_lib
```
**Pros:** Fast, 24-hour caching, works without internet
**Cons:** Slightly more complex

### 3. Local File
```bash
# Download file once
curl -fsSL https://raw.githubusercontent.com/mrvi0/bash-lib/main/bash-lib-standalone.sh -o bash-lib-standalone.sh

# Use in scripts
source "./bash-lib-standalone.sh"
```
**Pros:** Maximum speed, works without internet
**Cons:** Need to update manually

### 4. Universal Method
See `examples/universal_usage.sh` - combines all methods with priority.

[⬆️ Back to top](#bash-library)

## 🎯 Recommendations

| Scenario | Recommended Method | Reason |
|----------|-------------------|---------|
| **Quick Scripts** | Direct Download | Maximum simplicity |
| **Serious Projects** | Caching | Balance of speed and relevance |
| **Production** | Local File | Reliability and speed |
| **Development** | Universal | Flexibility |

[⬆️ Back to top](#bash-library)

## 🔧 Installation and Setup

### Automatic Installation
```bash
# Install in standard directories
sudo ./scripts/install.sh

# Install in user directories
./scripts/install.sh -d ~/.local/lib/bash-lib -b ~/.local/bin
```

### Manual Installation
```bash
# Copy files
sudo cp -r src /usr/local/lib/bash-lib/
sudo cp bash-lib.sh /usr/local/lib/bash-lib/

# Add to .bashrc
echo 'source /usr/local/lib/bash-lib/bash-lib.sh' >> ~/.bashrc
source ~/.bashrc
```

[⬆️ Back to top](#bash-library)

## 🧪 Testing

```bash
# Run examples
./examples/basic_usage.sh
./examples/simple_usage.sh
./examples/cached_usage.sh
./examples/local_usage.sh
./examples/universal_usage.sh

# Check function availability
bash-lib --help
```

[⬆️ Back to top](#bash-library)

## 📖 Documentation

- [API Reference](docs/api_reference.md) - Complete API documentation
- [Getting Started](docs/getting_started.md) - Getting started guide
- [Best Practices](docs/best_practices.md) - Best practices

[⬆️ Back to top](#bash-library)

## 🤝 Contributing

1. Fork the repository
2. Create a branch for your feature (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

[⬆️ Back to top](#bash-library)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

[⬆️ Back to top](#bash-library)

## 🆘 Support

If you have questions or issues:

1. Check the [documentation](docs/)
2. Look at the [examples](examples/)
3. Create an [Issue](https://github.com/mrvi0/bash-lib/issues)

[⬆️ Back to top](#bash-library)

## 🔄 Versions

- **v1.0.0** - First stable release with full functionality
  - Colored output and formatting
  - Logging system with levels
  - Data validation (email, numbers, files, ports)
  - System utilities (internet check, system information)
  - Universal functions (confirmations, headers, progress bars)
  - Compatibility with old functions
- **v1.1.0** - Planned: IO modules, extended system functions
- **v1.2.0** - Planned: Development modules, database modules

[⬆️ Back to top](#bash-library) 