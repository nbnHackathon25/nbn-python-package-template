#!/bin/bash

# Run tests with coverage using pytest and diff-cover
#
# Requirements:
# - Dependencies installed (run ./scripts/setup.sh first)
# - pyproject.toml with pytest configuration
# - Tests in tests/ directory
# - Source code in src/ directory
#
# Usage: ./run_tests.sh [compare-branch]
#   compare-branch: Optional branch for diff-cover comparison (default: origin/master or origin/main)

set -euo pipefail

DIFF_COVER_COMPARE_BRANCH="${1:-}"

# Source helper functions
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SOURCE_DIR}/helpers/python.sh"
source "${SOURCE_DIR}/helpers/common.sh"

print_header "Running Tests with Coverage"

check_environment
ensure_dev_dependencies
echo ""

echo "🧪 Running tests with coverage..."
echo ""

set +e
uv run pytest
TEST_EXIT_CODE=$?
set -euo pipefail

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

if [ -f "coverage.xml" ] && [ -d ".git" ]; then
    echo "📊 Generating diff-cover report..."
    echo ""

    if [ -n "$DIFF_COVER_COMPARE_BRANCH" ]; then
        COMPARE_BRANCH="$DIFF_COVER_COMPARE_BRANCH"
    else
        COMPARE_BRANCH=$(get_default_branch)
        if [ -z "$COMPARE_BRANCH" ]; then
            echo "⚠️  Warning: Could not find origin/master or origin/main"
            echo "Skipping diff-cover report"
        fi
    fi

    if [ -n "$COMPARE_BRANCH" ]; then
        echo "Comparing against: $COMPARE_BRANCH"
        echo ""

        set +e
        uv run diff-cover coverage.xml --compare-branch="$COMPARE_BRANCH" --format markdown:newline_report.md --fail-under=80
        DIFF_COVER_EXIT_CODE=$?
        set -euo pipefail

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

print_header "Test Summary"
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
exit ${DIFF_COVER_EXIT_CODE:-0}
