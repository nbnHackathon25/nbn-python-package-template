#!/bin/bash

# Generic test script for Python packages using pytest, pytest-cov, and diff-cover
# Assumptions:
# - pyproject.toml exists with pytest configuration
# - Tests are in tests/ directory
# - Source code is in src/ directory
# - Dependencies are already installed via uv sync
#
# Usage: ./run_tests.sh [compare-branch]
#   compare-branch: Optional branch to compare against for diff-cover (e.g., origin/master)

set -e  # Exit on error for setup, but not for test results

# Parse command line arguments
DIFF_COVER_COMPARE_BRANCH="${1:-}"

# Source UV helper functions
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SOURCE_DIR}/helpers/uv.sh"

echo "================================"
echo "Running Tests with Coverage"
echo "================================"
echo ""

# Check environment (pyproject.toml + uv + dependencies)
check_environment
echo ""

# Run pytest with coverage (configuration from pyproject.toml)
echo "🧪 Running tests with coverage..."
echo ""

set +e  # Don't exit on test failure, we want to report results
uv run pytest
TEST_EXIT_CODE=$?
set -e

if [ $TEST_EXIT_CODE -ne 0 ]; then
    echo ""
    echo "❌ Tests failed! (exit code: $TEST_EXIT_CODE)"
    echo ""
    echo "To debug:"
    echo "  - Run specific test: uv run pytest tests/test_file.py::test_name -v"
    echo "  - Run with more detail: uv run pytest -vv"
    echo "  - Run with debugger: uv run pytest --pdb"
    exit $TEST_EXIT_CODE
fi

echo ""
echo "✅ All tests passed!"
echo ""

# Generate diff-cover report if coverage.xml exists and git repo present
if [ -f "coverage.xml" ] && [ -d ".git" ]; then
    echo "📊 Generating diff-cover report..."
    echo ""

    # Use command line argument if provided, otherwise default to origin/master
    if [ -n "$DIFF_COVER_COMPARE_BRANCH" ]; then
        COMPARE_BRANCH="$DIFF_COVER_COMPARE_BRANCH"
    else
        # Compare against origin/master (or origin/main)
        COMPARE_BRANCH="origin/master"

        # Check if origin/master exists, otherwise try origin/main
        if ! git rev-parse --verify "$COMPARE_BRANCH" &>/dev/null; then
            COMPARE_BRANCH="origin/main"
            if ! git rev-parse --verify "$COMPARE_BRANCH" &>/dev/null; then
                echo "⚠️  Warning: Could not find origin/master or origin/main"
                echo "Skipping diff-cover report"
                COMPARE_BRANCH=""
            fi
        fi
    fi

    if [ -n "$COMPARE_BRANCH" ]; then
        echo "Comparing against: $COMPARE_BRANCH"
        echo ""

        set +e
        uv run diff-cover coverage.xml --compare-branch="$COMPARE_BRANCH" --format markdown:newline_report.md --fail-under=80
        DIFF_COVER_EXIT_CODE=$?
        set -e

        echo ""
        if [ $DIFF_COVER_EXIT_CODE -eq 0 ]; then
            echo "✅ Diff coverage: >= 80%"
        else
            echo "⚠️  Diff coverage: < 80%"
            echo "New/changed code should have at least 80% test coverage. Please see newline_report.md for details."
        fi
    fi
else
    echo "ℹ️  Skipping diff-cover (coverage.xml not found or not a git repo)"
    DIFF_COVER_EXIT_CODE=0
fi

echo ""
echo "================================"
echo "Test Summary"
echo "================================"
echo "✅ All tests passed"
echo "📊 Coverage reports generated:"
echo "   - Terminal: shown above"
if [ -f "htmlcov/index.html" ]; then
    echo "   - HTML: htmlcov/index.html"
fi
if [ -f "coverage.xml" ]; then
    echo "   - XML: coverage.xml"
fi
echo ""

# Open HTML coverage report if it exists
if [ -f "htmlcov/index.html" ]; then
    echo "Opening coverage report in browser..."

    if [[ "$OSTYPE" == "darwin"* ]]; then
        open htmlcov/index.html
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        xdg-open htmlcov/index.html 2>/dev/null || echo "Please open htmlcov/index.html manually"
    else
        echo "Please open htmlcov/index.html in your browser"
    fi
fi

echo ""
exit ${DIFF_COVER_EXIT_CODE:-0}
