#!/bin/bash

# Setup Python development environment using uv
#
# Requirements:
# - pyproject.toml with project dependencies
# - Internet connection (to install uv and dependencies)

set -euo pipefail

# Source helper functions
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SOURCE_DIR}/helpers/python.sh"
source "${SOURCE_DIR}/helpers/common.sh"

# Verify prerequisites
verify_prerequisites() {
    check_pyproject_toml
    echo "✅ Found pyproject.toml"

    install_uv_if_missing
    show_uv_version
}

# Install project dependencies
install_dependencies() {
    echo ""
    echo "📦 Installing dependencies from pyproject.toml..."

    if [ -f "uv.lock" ]; then
        echo "Using locked dependencies (uv.lock)..."
        uv sync --frozen --all-extras || {
            echo "❌ Failed to install dependencies"
            exit 1
        }
    else
        echo "No lock file found, syncing dependencies..."
        uv sync --all-extras || {
            echo "❌ Failed to install dependencies"
            exit 1
        }
    fi

    echo "✅ Dependencies installed successfully"
}

# Install pre-commit hooks
install_pre_commit_hooks() {
    echo ""

    if ! uv run which pre-commit &> /dev/null; then
        echo "ℹ️  pre-commit not found in dependencies, skipping hook installation"
        return 0
    fi

    echo "🪝 Installing pre-commit hooks..."

    if uv run pre-commit install --hook-type pre-commit --hook-type pre-push --hook-type commit-msg; then
        echo "✅ Pre-commit hooks installed successfully"
    else
        echo "⚠️  Failed to install pre-commit hooks (non-critical)"
    fi
}

# Show next steps to the user
show_next_steps() {
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
    echo "  4. Build the package:"
    echo "     ./scripts/build.sh"
    echo ""
    echo "  5. Try the package locally:"
    echo "     ./scripts/run_local.sh"
    echo ""
    echo "For manual operations:"
    echo "  - Run any command with uv: uv run <command>"
    echo "  - Activate venv manually: source .venv/bin/activate"
    echo "  - Run specific pre-commit hook: uv run pre-commit run <hook-id>"
    echo "  - Update pre-commit hooks: uv run pre-commit autoupdate"
    echo ""
}

# Main execution
main() {
    print_header "Python Package Environment Setup"

    verify_prerequisites
    install_dependencies
    install_pre_commit_hooks
    show_next_steps
}

main
