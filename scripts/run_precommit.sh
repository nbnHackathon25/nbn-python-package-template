#!/bin/bash

# Generic script to run pre-commit hooks
# Assumptions:
# - pyproject.toml exists in the root directory
# - Dependencies are already installed via uv sync
# - pre-commit is configured in .pre-commit-config.yaml
#
# Usage: ./run_precommit.sh [--all-files|--from-ref REF --to-ref REF]
#   --all-files: Run on all files (default)
#   --from-ref REF --to-ref REF: Run on files changed between commits

set -e  # Exit on error

# Source UV helper functions
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SOURCE_DIR}/helpers/uv.sh"

echo "================================"
echo "Running Pre-commit Hooks"
echo "================================"
echo ""

# Check environment (pyproject.toml + uv + dependencies)
check_environment
echo ""

# Parse command line arguments
if [ "$1" = "--from-ref" ] && [ "$3" = "--to-ref" ]; then
    echo "🔍 Running pre-commit on files changed between $2 and $4..."
    echo ""
    uv run pre-commit run --from-ref "$2" --to-ref "$4"
else
    echo "🔍 Running pre-commit on all files..."
    echo ""
    uv run pre-commit run --all-files
fi

EXIT_CODE=$?

echo ""
echo "================================"
echo "Pre-commit Summary"
echo "================================"

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
