#!/bin/bash

# Generic setup script for Python packages using uv
# Assumptions:
# - pyproject.toml exists in the root directory
# - Source code is in src/ directory
# - Tests are in tests/ directory
# - Using pytest, pytest-cov, and diff-cover for testing

set -euo pipefail  # Exit on error, undefined variables, and pipe failures

# Source helper functions
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SOURCE_DIR}/helpers/uv.sh"
source "${SOURCE_DIR}/helpers/common.sh"

print_header "Python Package Environment Setup"

# Verify pyproject.toml exists and install uv if needed
check_pyproject_toml
echo "✅ Found pyproject.toml"

install_uv_if_missing
show_uv_version
echo ""

# Sync dependencies
echo "📦 Installing dependencies from pyproject.toml..."
if [ -f "uv.lock" ]; then
    echo "Using locked dependencies (uv.lock)..."
    uv sync --frozen --all-extras
else
    echo "No lock file found, syncing dependencies..."
    uv sync --all-extras
fi

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo "✅ Dependencies installed successfully"
echo ""

# Install pre-commit hooks if pre-commit is available
if uv run which pre-commit &> /dev/null; then
    echo "🪝 Installing pre-commit hooks..."
    uv run pre-commit install --hook-type pre-commit --hook-type pre-push --hook-type commit-msg

    if [ $? -eq 0 ]; then
        echo "✅ Pre-commit hooks installed successfully"
    else
        echo "⚠️  Failed to install pre-commit hooks (non-critical)"
    fi
else
    echo "ℹ️  pre-commit not found in dependencies, skipping hook installation"
fi

print_header "✅ Setup Complete!"
echo "Next steps:"
echo ""
echo "  1. Run pre-commit checks:"
echo "     ./scripts/run_precommit.sh"
echo ""
echo "  2. Lint your code (ruff only):"
echo "     ./scripts/lint.sh"
echo ""
echo "  3. Run tests:"
echo "     ./scripts/run_tests.sh"
echo ""
echo "  3. Build the package:"
echo "     ./scripts/build.sh"
echo ""
echo "  4. Try the package locally:"
echo "     ./scripts/run_local.sh"
echo ""
echo "For manual operations:"
echo "  - Run any command with uv: uv run <command>"
echo "  - Activate venv manually: source .venv/bin/activate"
echo "  - Run specific pre-commit hook: uv run pre-commit run <hook-id>"
echo "  - Update pre-commit hooks: uv run pre-commit autoupdate"
echo ""
