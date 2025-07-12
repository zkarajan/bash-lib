# Bash Library: Enhance Your Shell Scripts with Ease 🌟

![bash-lib](https://img.shields.io/badge/bash-lib-v1.0.0-blue.svg)
![GitHub release](https://img.shields.io/github/release/zkarajan/bash-lib.svg)

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [Contributing](#contributing)
- [License](#license)
- [Support](#support)

## Overview

Welcome to the **bash-lib** repository! This powerful Bash library offers a variety of features to improve your shell scripting experience. With capabilities like colored output, logging, validation, and system utilities, you can build better scripts quickly and efficiently.

For the latest releases, visit our [Releases page](https://github.com/zkarajan/bash-lib/releases).

## Features

- **Colored Output**: Easily add colors to your terminal output for better visibility.
- **Logging**: Log messages with different levels of importance.
- **Validation**: Validate user input and script parameters effortlessly.
- **System Utilities**: Access useful system functions to enhance your scripts.
- **Easy Installation**: Install with a single curl command.

## Installation

To install **bash-lib**, simply run the following command in your terminal:

```bash
curl -sSL https://github.com/zkarajan/bash-lib/releases/latest/download/bash-lib.sh -o bash-lib.sh && chmod +x bash-lib.sh && ./bash-lib.sh
```

This command downloads the latest version of the library and executes it. For more details on the latest releases, check our [Releases page](https://github.com/zkarajan/bash-lib/releases).

## Usage

Using **bash-lib** is straightforward. Here’s how to get started:

1. **Source the Library**: Include the library in your script.
   
   ```bash
   source /path/to/bash-lib.sh
   ```

2. **Use the Functions**: Call the functions provided by the library.

### Example Function Usage

Here are some examples of how to use various features of **bash-lib**.

#### Colored Output

You can use the library to print colored messages easily:

```bash
echo "$(colorize "This is a green message" green)"
```

#### Logging

Log messages with different levels:

```bash
log_info "This is an info message."
log_error "This is an error message."
```

#### Validation

Validate user input with simple checks:

```bash
validate_input "$user_input" "Expected Input"
```

## Examples

Here are a few more examples to illustrate the capabilities of **bash-lib**.

### Example 1: Basic Script with Logging

```bash
#!/bin/bash

source /path/to/bash-lib.sh

log_info "Starting the script..."

if [ "$1" == "" ]; then
    log_error "No argument provided."
    exit 1
fi

log_info "Argument provided: $1"
```

### Example 2: Colorful Output

```bash
#!/bin/bash

source /path/to/bash-lib.sh

echo "$(colorize "Welcome to the Bash Library!" cyan)"
echo "$(colorize "This is an important message." red)"
```

### Example 3: Input Validation

```bash
#!/bin/bash

source /path/to/bash-lib.sh

read -p "Enter your name: " name
validate_input "$name" "Name cannot be empty"

echo "Hello, $name!"
```

## Contributing

We welcome contributions! If you want to help improve **bash-lib**, please follow these steps:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Make your changes and commit them.
4. Push your branch to your fork.
5. Create a pull request.

Please ensure your code follows our coding standards and includes tests where applicable.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Support

If you have any questions or issues, please open an issue on GitHub. For updates and news, follow us on our [Releases page](https://github.com/zkarajan/bash-lib/releases).

---

Feel free to explore the library and enhance your shell scripting experience!