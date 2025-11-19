#!/bin/bash

# Lint and format Python code using ruff
#
# Requirements:
# - Dependencies installed (run ./scripts/setup.sh first)
# - pyproject.toml with ruff configuration

set -euo pipefail

# Source helper functions
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SOURCE_DIR}/helpers/python.sh"
source "${SOURCE_DIR}/helpers/common.sh"

# Run ruff check with auto-fix
run_ruff_check() {
    echo "🔍 Running ruff check (with auto-fix)..."
    echo ""

    run_command uv run ruff check --fix .
    return $?
}

# Run ruff format
run_ruff_format() {
    echo ""
    echo "🎨 Running ruff format..."
    echo ""

    run_command uv run ruff format .
    return $?
}

# Display linting results
show_linting_results() {
    local check_exit_code=$1
    local format_exit_code=$2

    print_header "Linting Summary"

    if [ $check_exit_code -eq 0 ] && [ $format_exit_code -eq 0 ]; then
        echo "✅ All checks passed!"
        echo "Your code is clean and properly formatted."
        echo ""
        echo "Optional: Run comprehensive pre-commit checks:"
        echo "  uv run pre-commit run --all-files"
        return 0
    fi

    echo "⚠️  Some issues were found:"
    [ $check_exit_code -ne 0 ] && echo "  - Ruff check found issues (exit code: $check_exit_code)"
    [ $format_exit_code -ne 0 ] && echo "  - Ruff format found issues (exit code: $format_exit_code)"
    echo ""
    echo "Some issues may have been auto-fixed."
    echo "Please review the changes and commit them."
    echo ""
    echo "To see remaining issues:"
    echo "  uv run ruff check ."
    return 1
}

# Main execution
main() {
    print_header "Running Code Linting and Formatting"

    check_environment
    ensure_dev_dependencies
    echo ""

    run_ruff_check
    local check_exit_code=$?

    run_ruff_format
    local format_exit_code=$?

    show_linting_results $check_exit_code $format_exit_code
    exit $?
}

main
