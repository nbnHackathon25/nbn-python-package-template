#!/bin/bash

# Clean generated files and artifacts
#
# Requirements:
# - Run from repository root
#
# Usage:
#   ./scripts/clean.sh          # Clean artifacts, keep .venv/
#   ./scripts/clean.sh --all    # Clean everything including .venv/ and uv.lock
#
# This script removes:
# - Build artifacts (dist/, build/, *.egg-info/)
# - Test artifacts (htmlcov/, coverage.xml, .coverage, .pytest_cache/)
# - Python cache files (__pycache__/, *.pyc, *.pyo)
# - Ruff cache (.ruff_cache/)
# - Pre-commit cache (.pre-commit/)
# - Generated reports (newline_report.md)
# - Virtual environment and lock file (with --all flag)

set -euo pipefail

CLEAN_ALL=false
if [ "${1:-}" = "--all" ]; then
    CLEAN_ALL=true
fi

# Source helper functions
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SOURCE_DIR}/helpers/python.sh"
source "${SOURCE_DIR}/helpers/common.sh"

print_header "Cleaning Generated Files"

check_pyproject_toml
echo ""

echo "🧹 Removing build artifacts..."
rm -rf dist/
rm -rf build/
rm -rf src/*.egg-info/
echo "   ✓ Removed: dist/, build/, *.egg-info/"

echo ""
echo "🧹 Removing test artifacts..."
rm -rf htmlcov/
rm -f coverage.xml
rm -f .coverage
rm -rf .pytest_cache/
rm -f newline_report.md
echo "   ✓ Removed: htmlcov/, coverage.xml, .coverage, .pytest_cache/, newline_report.md"

echo ""
echo "🧹 Removing Python cache files..."
find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
find . -type f -name "*.pyc" -delete 2>/dev/null || true
find . -type f -name "*.pyo" -delete 2>/dev/null || true
echo "   ✓ Removed: __pycache__/, *.pyc, *.pyo"

echo ""
echo "🧹 Removing tool cache..."
rm -rf .ruff_cache/
rm -rf .pre-commit/
echo "   ✓ Removed: .ruff_cache/, .pre-commit/"

if [ "$CLEAN_ALL" = true ]; then
    echo ""
    echo "🧹 Removing virtual environment..."
    rm -rf .venv/
    echo "   ✓ Removed: .venv/"
fi

echo ""
print_header "Clean Complete"
if [ "$CLEAN_ALL" = true ]; then
    echo "✅ All generated files, artifacts, and environment have been removed"
    echo ""
    echo "Run ./scripts/setup.sh to recreate the environment"
else
    echo "✅ All generated files and artifacts have been removed"
    echo ""
    echo "Note: Virtual environment (.venv/) and lock file (uv.lock) were preserved"
    echo "To remove them too, run: ./scripts/clean.sh --all"
fi
echo ""
