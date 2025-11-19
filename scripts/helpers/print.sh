#!/bin/bash

print_header() {
    local title="$1"
    echo "================================"
    echo "$title"
    echo "================================"
    echo ""
}

print_separator() {
    echo ""
    echo "================================"
}

print_subseparator() {
    echo ""
    echo "---"
    echo ""
}

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
