#!/bin/bash

# Demonstrate Python package usage and CLI entry points
#
# Requirements:
# - Dependencies installed (run ./scripts/setup.sh first)
# - pyproject.toml (optionally with [project.scripts] entry points)

set -euo pipefail

# Source helper functions
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SOURCE_DIR}/helpers/python.sh"
source "${SOURCE_DIR}/helpers/common.sh"

print_header "Python Package Demo"

check_environment
echo ""

echo "📦 Detecting package information..."
echo ""

# Extract package information
PACKAGE_NAME=$(get_package_name)

if [ -n "$PACKAGE_NAME" ]; then
    echo "Package: $PACKAGE_NAME"
else
    echo "⚠️  Could not detect package name from pyproject.toml"
fi

ENTRY_POINTS=$(get_entry_points)

if [ -n "$ENTRY_POINTS" ]; then
    echo ""
    echo "Available CLI entry points:"
    echo "$ENTRY_POINTS" | while read -r cmd; do
        if [ -n "$cmd" ]; then
            echo "  - $cmd"
        fi
    done
    print_header "Running Entry Points"

    echo "$ENTRY_POINTS" | while read -r cmd; do
        if [ -n "$cmd" ]; then
            echo "→ Running: $cmd"
            echo "  Command: uv run $cmd"
            echo ""
            uv run "$cmd" || true
            print_subseparator
        fi
    done
else
    echo ""
    echo "ℹ️  No CLI entry points found in [project.scripts]"
fi

print_header "Usage Examples"
echo "1. Run CLI commands:"
if [ -n "$ENTRY_POINTS" ]; then
    echo "$ENTRY_POINTS" | while read -r cmd; do
        if [ -n "$cmd" ]; then
            echo "   uv run $cmd"
        fi
    done
else
    echo "   (No entry points defined)"
fi
echo ""
echo "2. Use as a library in Python:"
MAIN_MODULE=$(get_main_module)
if [ -n "$MAIN_MODULE" ]; then
        echo "   uv run python -c 'from $MAIN_MODULE import *; help($MAIN_MODULE)'"
        echo ""
        echo "3. Interactive Python session:"
        echo "   uv run python"
    echo "   >>> from $MAIN_MODULE import *"
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
