#!/bin/bash

# Run pre-commit hooks on all files
#
# Requirements:
# - Dependencies installed (run ./scripts/setup.sh first)
# - .pre-commit-config.yaml configuration file in root directory

set -euo pipefail

# Source helper functions
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SOURCE_DIR}/helpers/uv.sh"
source "${SOURCE_DIR}/helpers/common.sh"

print_header "Running Pre-commit Hooks"

check_environment
echo ""

echo "🔍 Running pre-commit on all files..."
echo ""
uv run pre-commit run --all-files

EXIT_CODE=$?

print_header "Pre-commit Summary"

if [ $EXIT_CODE -eq 0 ]; then
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
exit $EXIT_CODE
