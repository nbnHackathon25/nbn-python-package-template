#!/bin/bash

# Reusable UV helper functions for Python package scripts
# Source this file in your scripts with: source "$(dirname "$0")/helpers/uv.sh"

# Function to verify pyproject.toml exists
check_pyproject_toml() {
    if [ ! -f "pyproject.toml" ]; then
        echo "❌ Error: pyproject.toml not found in current directory"
        echo "Please run this script from the repository root."
        exit 1
    fi
}

# Function to check if uv is installed
check_uv_installed() {
    if ! command -v uv &> /dev/null; then
        echo "❌ Error: uv is not installed"
        echo "Please run scripts/setup.sh first to set up the environment."
        exit 1
    fi
}

# Function to install uv if not present (used only in setup.sh)
install_uv_if_missing() {
    if ! command -v uv &> /dev/null; then
        echo ""
        echo "⚠️  uv is not installed. Installing uv..."
        curl -LsSf https://astral.sh/uv/install.sh | sh

        if [ $? -eq 0 ]; then
            echo "✅ uv installed successfully"
            # Add uv to PATH for current session
            export PATH="$HOME/.local/bin:$PATH"
        else
            echo "❌ Failed to install uv"
            echo "Please install manually: https://github.com/astral-sh/uv"
            exit 1
        fi
    fi
}

# Function to verify dependencies are installed
check_dependencies_installed() {
    if [ ! -d ".venv" ] && [ ! -f "uv.lock" ]; then
        echo "⚠️  Warning: No virtual environment or lock file detected"
        echo "Please run scripts/setup.sh first to install dependencies."
        exit 1
    fi
}

# Function to display uv version
show_uv_version() {
    echo "✅ uv found: $(uv --version)"
}

# Combined check for most scripts (pyproject.toml + uv + dependencies)
check_environment() {
    check_pyproject_toml
    check_uv_installed
    check_dependencies_installed
    echo "✅ Environment ready"
}
