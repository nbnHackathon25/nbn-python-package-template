#!/bin/bash

# Demonstrate Python package usage and CLI entry points
#
# Requirements:
# - Dependencies installed (run ./scripts/setup.sh first)
# - pyproject.toml (optionally with [project.scripts] entry points)

set -euo pipefail

# Source helper functions
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SOURCE_DIR
source "${SOURCE_DIR}/helpers/python.sh"
source "${SOURCE_DIR}/helpers/common.sh"

# Detect and display package information
show_package_info() {
    echo "📦 Detecting package information..."
    echo ""

    local package_name=$(get_package_name)

    if [ -n "$package_name" ]; then
        echo "Package: $package_name"
    else
        echo "⚠️  Could not detect package name from pyproject.toml"
    fi
}

# Display and run CLI entry points
run_entry_points() {
    local entry_points=$(get_entry_points)

    if [ -z "$entry_points" ]; then
        echo ""
        echo "ℹ️  No CLI entry points found in [project.scripts]"
        return 0
    fi

    echo ""
    echo "Available CLI entry points:"
    echo "$entry_points" | while read -r cmd; do
        [ -n "$cmd" ] && echo "  - $cmd"
    done

    print_header "Running Entry Points"

    echo "$entry_points" | while read -r cmd; do
        if [ -n "$cmd" ]; then
            echo "→ Running: $cmd"
            echo "  Command: uv run $cmd"
            echo ""
            uv run "$cmd" || true
            print_subseparator
        fi
    done
}

# Display usage examples for the package
show_usage_examples() {
    local entry_points=$(get_entry_points)
    local main_module=$(get_main_module)

    print_header "Usage Examples"

    echo "1. Run CLI commands:"
    if [ -n "$entry_points" ]; then
        echo "$entry_points" | while read -r cmd; do
            [ -n "$cmd" ] && echo "   uv run $cmd"
        done
    else
        echo "   (No entry points defined)"
    fi

    echo ""
    echo "2. Use as a library in Python:"
    if [ -n "$main_module" ]; then
        echo "   uv run python -c 'from $main_module import *; help($main_module)'"
        echo ""
        echo "3. Interactive Python session:"
        echo "   uv run python"
        echo "   >>> from $main_module import *"
        echo "   >>> # Use your package functions here"
    else
        echo "   (Could not detect module structure)"
    fi

    echo ""
    echo "4. Install and use in another project:"
    echo "   uv pip install /path/to/this/package"
    echo "   # or from dist after building:"
    echo "   uv pip install dist/*.whl"
    echo ""
}

# Main execution
main() {
    print_header "Python Package Demo"

    check_environment
    echo ""

    show_package_info
    run_entry_points
    show_usage_examples
}

main
