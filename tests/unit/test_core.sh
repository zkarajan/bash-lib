#!/usr/bin/env bash
# Unit tests for core modules

# Source the library
source "$(dirname "$0")/../../bash-lib.sh"

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Test function
test_function() {
    local test_name="$1"
    local test_command="$2"
    
    echo -n "Testing $test_name... "
    
    if eval "$test_command" >/dev/null 2>&1; then
        colors::success "PASS"
        ((TESTS_PASSED++))
    else
        colors::error "FAIL"
        ((TESTS_FAILED++))
    fi
}

echo "=== Bash Library Core Tests ==="
echo

# Test colors module
echo "Testing Colors Module:"
test_function "colors::success" "colors::success 'test' >/dev/null"
test_function "colors::error" "colors::error 'test' >/dev/null"
test_function "colors::warning" "colors::warning 'test' >/dev/null"
test_function "colors::info" "colors::info 'test' >/dev/null"
test_function "colors::debug" "colors::debug 'test' >/dev/null"
echo

# Test validation module
echo "Testing Validation Module:"
test_function "validation::is_email (valid)" "validation::is_email 'test@example.com'"
test_function "validation::is_email (invalid)" "! validation::is_email 'invalid-email'"
test_function "validation::is_integer (valid)" "validation::is_integer '123'"
test_function "validation::is_integer (invalid)" "! validation::is_integer 'abc'"
test_function "validation::is_port (valid)" "validation::is_port '8080'"
test_function "validation::is_port (invalid)" "! validation::is_port '99999'"
test_function "validation::file_exists (valid)" "validation::file_exists '$0'"
test_function "validation::file_exists (invalid)" "! validation::file_exists '/nonexistent/file'"
echo

# Test logging module
echo "Testing Logging Module:"
test_function "logging::info" "logging::info 'test' >/dev/null"
test_function "logging::error" "logging::error 'test' >/dev/null"
test_function "logging::set_level" "logging::set_level debug"
echo

# Test library functions
echo "Testing Library Functions:"
test_function "bash_lib::version" "bash_lib::version | grep -q '0.1.0'"
test_function "bash_lib::info" "bash_lib::info | grep -q 'Bash Library'"
echo

# Summary
echo "=== Test Summary ==="
echo "Tests passed: $TESTS_PASSED"
echo "Tests failed: $TESTS_FAILED"
echo "Total tests: $((TESTS_PASSED + TESTS_FAILED))"

if [[ $TESTS_FAILED -eq 0 ]]; then
    colors::success "All tests passed!"
    exit 0
else
    colors::error "Some tests failed!"
    exit 1
fi 