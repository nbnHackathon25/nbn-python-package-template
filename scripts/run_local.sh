#!/bin/bash

# Generic script to demonstrate Python package usage
# Assumptions:
# - pyproject.toml exists with [project.scripts] entry points
# - Source code is in src/ directory
# - Dependencies are already installed via uv sync

set -e  # Exit on error

# Source UV helper functions
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SOURCE_DIR}/helpers/uv.sh"

echo "================================"
echo "Python Package Demo"
echo "================================"
echo ""

# Check environment (pyproject.toml + uv + dependencies)
check_environment
echo ""

# Extract package name and entry points from pyproject.toml
echo "📦 Detecting package information..."
echo ""

# Try to extract package name (skip comments)
PACKAGE_NAME=$(grep "^name = " pyproject.toml | head -1 | sed -E 's/.*name.*=.*"([^"]+)".*/\1/' || echo "")

if [ -n "$PACKAGE_NAME" ]; then
    echo "Package: $PACKAGE_NAME"
else
    echo "⚠️  Could not detect package name from pyproject.toml"
fi

# Try to extract entry points (skip comments and blank lines)
ENTRY_POINTS=$(awk '/^\[project\.scripts\]/{flag=1;next}/^\[/{flag=0}flag && /^[a-zA-Z0-9_-]+ *=/{print}' pyproject.toml | sed -E 's/^([a-zA-Z0-9_-]+).*/\1/' || echo "")

if [ -n "$ENTRY_POINTS" ]; then
    echo ""
    echo "Available CLI entry points:"
    echo "$ENTRY_POINTS" | while read -r cmd; do
        if [ -n "$cmd" ]; then
            echo "  - $cmd"
        fi
    done
    echo ""
    echo "================================"
    echo "Running Entry Points"
    echo "================================"
    echo ""

    # Run each entry point
    echo "$ENTRY_POINTS" | while read -r cmd; do
        if [ -n "$cmd" ]; then
            echo "→ Running: $cmd"
            echo "  Command: uv run $cmd"
            echo ""
            uv run "$cmd" || true
            echo ""
            echo "---"
            echo ""
        fi
    done
else
    echo ""
    echo "ℹ️  No CLI entry points found in [project.scripts]"
fi

echo "================================"
echo "Usage Examples"
echo "================================"
echo ""
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
if [ -d "src" ]; then
    MAIN_MODULE=$(find src -type d -mindepth 1 -maxdepth 1 | head -1 | xargs basename)
    if [ -n "$MAIN_MODULE" ]; then
        echo "   uv run python -c 'from $MAIN_MODULE import *; help($MAIN_MODULE)'"
        echo ""
        echo "3. Interactive Python session:"
        echo "   uv run python"
        echo "   >>> from $MAIN_MODULE import *"
        echo "   >>> # Use your package functions here"
    fi
else
    echo "   (Could not detect module structure)"
fi
echo ""
echo "4. Install and use in another project:"
echo "   uv pip install /path/to/this/package"
echo "   # or from dist after building:"
echo "   uv pip install dist/*.whl"
echo ""
