#!/bin/bash

# Print utilities for shell scripts
# Source this file in your scripts with: source "$(dirname "$0")/helpers/print.sh"

# Function to print a header section
print_header() {
    local title="$1"
    echo "================================"
    echo "$title"
    echo "================================"
    echo ""
}

# Function to print a separator
print_separator() {
    echo ""
    echo "================================"
}

# Function to print a subsection separator
print_subseparator() {
    echo ""
    echo "---"
    echo ""
}

# Function to handle exit codes with summary
handle_exit_code() {
    local exit_code="$1"
    local success_message="$2"
    local failure_message="$3"

    echo ""
    print_header "Summary"

    if [ "$exit_code" -eq 0 ]; then
        echo "✅ $success_message"
    else
        echo "⚠️  $failure_message"
    fi
    echo ""
}
