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

# This function executes a command with its arguments, temporarily disabling strict error handling (set -e).
# This allows the command to fail without causing the script to exit immediately, enabling proper error handling.
run_command() {
    set +e
    "$@"
    local exit_code=$?
    set -euo pipefail
    return $exit_code
}
