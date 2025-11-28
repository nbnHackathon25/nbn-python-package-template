#!/bin/bash

# Usage: ./scripts/run_precommit.sh
# Runs pre-commit hooks on all files in the repository.
# Requirements:
#   - Dependencies installed (run ./scripts/setup.sh first)
#   - .pre-commit-config.yaml configuration file in root directory

set -euo pipefail

# Source helper functions
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SOURCE_DIR
source "${SOURCE_DIR}/helpers/python.sh"
source "${SOURCE_DIR}/helpers/common.sh"

# Run pre-commit hooks on all files
run_precommit_hooks() {
    echo "🔍 Running pre-commit on all files..."
    echo ""

    uv run pre-commit run --all-files
    return $?
}

# Display pre-commit results summary
show_precommit_summary() {
    local exit_code=$1

    print_header "Pre-commit Summary"

    if [ "$exit_code" -eq 0 ]; then
        echo "✅ All pre-commit hooks passed!"
        echo ""
        echo "Your code is ready to commit."
    else
        echo "⚠️  Some pre-commit hooks failed or made changes"
        echo ""
        echo "Common fixes:"
        echo "  - Review the changes made by auto-fixers (ruff, trailing-whitespace, etc.)"
        echo "  - Run again: ./scripts/run_precommit.sh"
        echo "  - For specific hooks: uv run pre-commit run <hook-id>"
        echo ""
        echo "To see all hooks:"
        echo "  uv run pre-commit run --all-files --verbose"
    fi

    echo ""
}

# Main execution
main() {
    print_header "Running Pre-commit Hooks"

    check_environment
    ensure_dev_dependencies
    echo ""

    run_precommit_hooks
    local exit_code=$?

    show_precommit_summary $exit_code

    exit $exit_code
}

main
