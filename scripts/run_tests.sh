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

# Run pytest with coverage
run_tests() {
    echo "🧪 Running tests with coverage..."
    echo ""

    if ! run_command uv run pytest; then
        local exit_code=$?
        echo ""
        echo "❌ Tests failed! (exit code: $exit_code)"
        echo ""
        echo "To debug:"
        echo "  - Run specific test: uv run pytest tests/test_file.py::test_name -v"
        echo "  - Run with more detail: uv run pytest -vv"
        echo "  - Run with debugger: uv run pytest --pdb"
        exit $exit_code
    fi

    echo ""
    echo "✅ All tests passed!"
    echo ""
}

# Run diff-cover to check coverage on changed lines
run_diff_cover() {
    # Skip if coverage file or git repo doesn't exist
    if [ ! -f "coverage.xml" ] || [ ! -d ".git" ]; then
        echo "ℹ️  Skipping diff-cover (coverage.xml not found or not a git repo)"
        return 0
    fi

    echo "📊 Generating diff-cover report..."
    echo ""

    local compare_branch="${DIFF_COVER_COMPARE_BRANCH:-$(get_default_branch)}"

    if [ -z "$compare_branch" ]; then
        echo "⚠️  Warning: Could not find origin/master or origin/main"
        echo "Skipping diff-cover report"
        return 0
    fi

    echo "Comparing against: $compare_branch"
    echo ""

    if run_command uv run diff-cover coverage.xml --compare-branch="$compare_branch" \
            --format markdown:newline_report.md --fail-under=80; then
        echo ""
        echo "✅ Diff coverage: >= 80%"
        return 0
    else
        local exit_code=$?
        echo ""
        echo "⚠️  Diff coverage: < 80%"
        echo "New/changed code should have at least 80% test coverage. Please see newline_report.md for details."
        return $exit_code
    fi
}

# Display test summary
show_test_summary() {
    print_header "Test Summary"
    echo "✅ All tests passed"
    echo "📊 Coverage reports generated:"
    echo "   - Terminal: shown above"
    [ -f "htmlcov/index.html" ] && echo "   - HTML: htmlcov/index.html"
    [ -f "coverage.xml" ] && echo "   - XML: coverage.xml"
    echo ""
}

# Main execution
main() {
    print_header "Running Tests with Coverage"

    check_environment
    ensure_dev_dependencies
    echo ""

    run_tests

    run_diff_cover
    local diff_cover_exit_code=$?

    show_test_summary

    exit $diff_cover_exit_code
}

main
