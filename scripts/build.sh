#!/bin/bash

# Build Python package using uv
#
# Requirements:
# - pyproject.toml with build configuration
# - Source code in src/ directory
# - uv installed (run ./scripts/setup.sh first)

set -euo pipefail

# Source helper functions
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SOURCE_DIR}/helpers/python.sh"
source "${SOURCE_DIR}/helpers/common.sh"

# Verify all prerequisites for building
verify_build_prerequisites() {
    check_pyproject_toml

    if [ ! -d "src" ]; then
        echo "❌ Error: src/ directory not found"
        echo "This script expects source code in src/ directory."
        exit 1
    fi

    check_uv_installed

    echo "✅ Found pyproject.toml and src/ directory"
    show_uv_version
}

# Clean previous build artifacts
clean_build_artifacts() {
    echo ""
    echo "🧹 Cleaning previous build artifacts..."

    rm -rf dist/ build/ *.egg-info
    find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
    find . -type f -name "*.pyc" -delete 2>/dev/null || true

    echo "✅ Cleaned previous artifacts"
}

# Build the package using uv
build_package() {
    echo ""
    echo "📦 Building Python package..."
    echo "This will create both wheel (.whl) and source distribution (.tar.gz)"
    echo ""

    uv build || {
        echo "❌ Build failed"
        exit 1
    }

    echo ""
    echo "✅ Build completed successfully"
}

# Verify build outputs were created
verify_build_outputs() {
    echo ""

    [ -d "dist" ] || {
        echo "❌ Error: dist/ directory not created"
        exit 1
    }

    local wheel_count=$(find dist -name "*.whl" | wc -l | tr -d ' ')
    local sdist_count=$(find dist -name "*.tar.gz" | wc -l | tr -d ' ')

    if [ "$wheel_count" -eq 0 ] || [ "$sdist_count" -eq 0 ]; then
        echo "⚠️  Warning: Expected both wheel and source distribution"
        echo "Found: $wheel_count wheel(s), $sdist_count source dist(s)"
    fi

    echo "$wheel_count $sdist_count"
}

# Display build summary and next steps
show_build_summary() {
    local counts=($1)
    local wheel_count=${counts[0]}
    local sdist_count=${counts[1]}

    print_header "Build Summary"
    echo "📁 Build artifacts in dist/:"
    echo ""
    list_files dist
    echo ""
    echo "✅ Wheel files: $wheel_count"
    echo "✅ Source distributions: $sdist_count"
    echo ""
    echo "Next steps:"
    echo ""
    echo "  - Test installation locally:"
    echo "    uv pip install dist/*.whl"
    echo ""
    echo "  - Publish to PyPI/Artifactory:"
    echo "    uv publish --index <your-index>"
    echo ""
    echo "  - Inspect package contents:"
    echo "    tar -tzf dist/*.tar.gz | head -20"
    echo "    unzip -l dist/*.whl | head -20"
    echo ""
}

# Main execution
main() {
    print_header "Python Package Build"

    verify_build_prerequisites
    clean_build_artifacts
    build_package

    local build_counts=$(verify_build_outputs)
    show_build_summary "$build_counts"
}

main
