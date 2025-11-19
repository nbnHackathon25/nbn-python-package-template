#!/bin/bash

# Lint and format Python code using ruff
#
# Requirements:
# - Dependencies installed (run ./scripts/setup.sh first)
# - pyproject.toml with ruff configuration

set -euo pipefail

# Source helper functions
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SOURCE_DIR}/helpers/uv.sh"
source "${SOURCE_DIR}/helpers/common.sh"

print_header "Running Code Linting and Formatting"

# Check environment (pyproject.toml + uv + dependencies)
check_environment
echo ""

echo "🔍 Running ruff check (with auto-fix)..."
echo ""

set +e
uv run ruff check --fix .
CHECK_EXIT_CODE=$?
set -euo pipefail

echo ""
echo "🎨 Running ruff format..."
echo ""

set +e
uv run ruff format .
FORMAT_EXIT_CODE=$?
set -euo pipefail

print_header "Linting Summary"

if [ $CHECK_EXIT_CODE -eq 0 ] && [ $FORMAT_EXIT_CODE -eq 0 ]; then
    echo "✅ All checks passed!"
    echo "Your code is clean and properly formatted."
    echo ""
    echo "Optional: Run comprehensive pre-commit checks:"
    echo "  uv run pre-commit run --all-files"
    exit 0
else
    echo "⚠️  Some issues were found:"
    if [ $CHECK_EXIT_CODE -ne 0 ]; then
        echo "  - Ruff check found issues (exit code: $CHECK_EXIT_CODE)"
    fi
    if [ $FORMAT_EXIT_CODE -ne 0 ]; then
        echo "  - Ruff format found issues (exit code: $FORMAT_EXIT_CODE)"
    fi
    echo ""
    echo "Some issues may have been auto-fixed."
    echo "Please review the changes and commit them."
    echo ""
    echo "To see remaining issues:"
    echo "  uv run ruff check ."
    exit 1
fi
