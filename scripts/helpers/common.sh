#!/bin/bash

# Common utilities for shell scripts
# Source this file in your scripts with: source "$(dirname "$0")/helpers/common.sh"

# Source print utilities
COMMON_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${COMMON_DIR}/print.sh"

# Function to extract package name from pyproject.toml
get_package_name() {
    grep "^name = " pyproject.toml 2>/dev/null | head -1 | sed -E 's/.*name.*=.*"([^"]+)".*/\1/' || echo ""
}

# Function to extract entry points from pyproject.toml
get_entry_points() {
    awk '/^\[project\.scripts\]/{flag=1;next}/^\[/{flag=0}flag && /^[a-zA-Z0-9_-]+ *=/{print}' pyproject.toml 2>/dev/null | sed -E 's/^([a-zA-Z0-9_-]+).*/\1/' || echo ""
}

# Function to detect main module from src directory
get_main_module() {
    if [ -d "src" ]; then
        find src -type d -mindepth 1 -maxdepth 1 2>/dev/null | head -1 | xargs basename
    else
        echo ""
    fi
}

# Function to determine default git branch
get_default_branch() {
    local default_branch="origin/master"

    # Check if origin/master exists, otherwise try origin/main
    if ! git rev-parse --verify "$default_branch" &>/dev/null; then
        default_branch="origin/main"
        if ! git rev-parse --verify "$default_branch" &>/dev/null; then
            echo ""
            return 1
        fi
    fi

    echo "$default_branch"
}

# Function to list files in a directory with formatting
list_files() {
    local dir="$1"
    if [ -d "$dir" ]; then
        ls -lh "$dir/"
    fi
}
