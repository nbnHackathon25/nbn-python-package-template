#!/bin/bash

# Validate pyproject.toml exists
check_pyproject_toml() {
    if [ ! -f "pyproject.toml" ]; then
        echo "❌ Error: pyproject.toml not found in current directory"
        echo "Please run this script from the repository root."
        exit 1
    fi
}

# Check if uv is installed
check_uv_installed() {
    if ! command -v uv &> /dev/null; then
        echo "❌ Error: uv is not installed"
        echo "Please run scripts/setup.sh first to set up the environment."
        exit 1
    fi
}

# Install uv if missing
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

# Check if dependencies are installed
check_dependencies_installed() {
    if [ ! -d ".venv" ] && [ ! -f "uv.lock" ]; then
        echo "⚠️  Warning: No virtual environment or lock file detected"
        echo "Please run scripts/setup.sh first to install dependencies."
        exit 1
    fi
}

# Show uv version
show_uv_version() {
    echo "✅ uv found: $(uv --version)"
}

# Run all environment checks
check_environment() {
    check_pyproject_toml
    check_uv_installed
    check_dependencies_installed
    echo "✅ Environment ready"
}

# Extract package name from pyproject.toml
get_package_name() {
    grep "^name = " pyproject.toml 2>/dev/null | head -1 | sed -E 's/.*name.*=.*"([^"]+)".*/\1/' || echo ""
}

# Extract CLI entry points from pyproject.toml
get_entry_points() {
    awk '/^\[project\.scripts\]/{flag=1;next}/^\[/{flag=0}flag && /^[a-zA-Z0-9_-]+ *=/{print}' pyproject.toml 2>/dev/null | sed -E 's/^([a-zA-Z0-9_-]+).*/\1/' || echo ""
}

# Get main module directory from src/
get_main_module() {
    if [ -d "src" ]; then
        find src -type d -mindepth 1 -maxdepth 1 2>/dev/null | head -1 | xargs basename
    else
        echo ""
    fi
}

# Check if development dependencies are defined in pyproject.toml, add and install if missing
ensure_dev_dependencies() {
    local required_dev_deps=("commitizen" "pytest" "pytest-cov" "pytest-mock" "diff-cover" "ruff" "pre-commit")
    local missing_deps=()

    # Use uv to check which dev dependencies are missing
    for dep in "${required_dev_deps[@]}"; do
        if ! uv pip list 2>/dev/null | grep -qE "^${dep}\s"; then
            missing_deps+=("$dep")
        fi
    done

    [ ${#missing_deps[@]} -eq 0 ] && return 0

    echo "⚠️  Missing development dependencies: ${missing_deps[*]}"
    echo "📦 Adding and installing missing dependencies..."
    echo ""

    local install_failed=false
    for dep in "${missing_deps[@]}"; do
        if ! uv add --dev "$dep"; then
            install_failed=true
        fi
    done
    if [ "$install_failed" = true ]; then
        echo ""
        echo "❌ Failed to add at least one development dependency"
        exit 1
    else
        echo ""
        echo "✅ Development dependencies added to pyproject.toml and installed"
    fi
}
