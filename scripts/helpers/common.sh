#!/bin/bash

COMMON_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${COMMON_DIR}/print.sh"
source "${COMMON_DIR}/python.sh"

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

list_files() {
    local dir="$1"
    if [ -d "$dir" ]; then
        ls -lh "$dir/"
    fi
}

# Run command and handle exit code (disables strict error handling temporarily)
run_command() {
    local exit_code
    set +e
    "$@"
    exit_code=$?
    set -euo pipefail
    return $exit_code
}
