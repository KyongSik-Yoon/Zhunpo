#!/usr/bin/env bash

# Detect shell for test compatibility
if [ -n "$ZSH_VERSION" ]; then
    SHELL_RC_FILE=".zshrc"
else
    SHELL_RC_FILE=".bashrc"
fi

# Use current directory for testing
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
# Normalize the path to avoid ../test_temp vs test_temp issues
SHUNPO_TEST_DIR="$(cd "$SCRIPT_DIR/.." && pwd)/test_temp"

setup_env() {
    # Clean up any existing test directory
    rm -rf "$SHUNPO_TEST_DIR"
    
    # Also clean up any Shunpo installation from previous tests
    unset SHUNPO_DIR
    
    # Create test environment in current project
    HOME=${SHUNPO_TEST_DIR}/home
    mkdir -p "$HOME"
    XDG_DATA_HOME=${SHUNPO_TEST_DIR}/home/.local/share
    mkdir -p "$XDG_DATA_HOME"
    
    # Export for subprocesses
    export HOME
    export XDG_DATA_HOME
    
    # Ensure we start in the test directory
    cd "$SHUNPO_TEST_DIR"
}

cleanup_env() {
    # Clean up entire test directory
    if [ -d "${SHUNPO_TEST_DIR}" ]; then
        rm -rf "${SHUNPO_TEST_DIR}"
    fi
}

make_directories() {
    # Make directory structure.
    local should_bookmark=${1:-0}
    local depth=4
    local width=3
    
    # Start from SHUNPO_TEST_DIR
    cd "$SHUNPO_TEST_DIR"
    
    for i in $(seq 1 $depth); do
        mkdir -p "$i"
        if [[ $i -ne 1 ]]; then
            for j in $(seq 1 $width); do
                mkdir -p "$i.$j"
            done
        fi
        cd "$i"
        
        # Add bookmark if requested
        if [[ $should_bookmark -eq 1 ]]; then
            sb >/dev/null 2>&1
        fi
    done
}

get_num_bookmarks() {
    SHUNPO_BOOKMARKS_FILE="${XDG_DATA_HOME:-$HOME/.local/share}/shunpo/.shunpo_bookmarks"
    if [ -f "$SHUNPO_BOOKMARKS_FILE" ]; then
        echo $(wc -l <"$SHUNPO_BOOKMARKS_FILE" | tr -d '[:space:]')
    else
        echo 0
    fi
}
