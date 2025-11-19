#!/bin/bash

# Generic build script for Python packages using uv
# Assumptions:
# - pyproject.toml exists in the root directory
# - Source code is in src/ directory
# - Using hatchling or similar build backend

set -euo pipefail  # Exit on error, undefined variables, and pipe failures

# Source helper functions
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SOURCE_DIR}/helpers/uv.sh"
source "${SOURCE_DIR}/helpers/common.sh"

print_header "Python Package Build"

# Verify pyproject.toml and uv
check_pyproject_toml

# Verify src directory exists
if [ ! -d "src" ]; then
    echo "❌ Error: src/ directory not found"
    echo "This script expects source code in src/ directory."
    exit 1
fi

check_uv_installed

echo "✅ Found pyproject.toml and src/ directory"
show_uv_version
echo ""

# Clean previous build artifacts
echo "🧹 Cleaning previous build artifacts..."
rm -rf dist/ build/ *.egg-info
find . -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
find . -type f -name "*.pyc" -delete 2>/dev/null || true

echo "✅ Cleaned previous artifacts"
echo ""

# Build the package
echo "📦 Building Python package..."
echo "This will create both wheel (.whl) and source distribution (.tar.gz)"
echo ""

uv build

if [ $? -ne 0 ]; then
    echo "❌ Build failed"
    exit 1
fi

echo ""
echo "✅ Build completed successfully"
echo ""

# Validate build outputs
if [ ! -d "dist" ]; then
    echo "❌ Error: dist/ directory not created"
    exit 1
fi

WHEEL_COUNT=$(find dist -name "*.whl" | wc -l | tr -d ' ')
SDIST_COUNT=$(find dist -name "*.tar.gz" | wc -l | tr -d ' ')

if [ "$WHEEL_COUNT" -eq 0 ] || [ "$SDIST_COUNT" -eq 0 ]; then
    echo "⚠️  Warning: Expected both wheel and source distribution"
    echo "Found: $WHEEL_COUNT wheel(s), $SDIST_COUNT source dist(s)"
fi

print_header "Build Summary"
echo "📁 Build artifacts in dist/:"
echo ""
list_files dist
echo ""
echo "✅ Wheel files: $WHEEL_COUNT"
echo "✅ Source distributions: $SDIST_COUNT"
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
