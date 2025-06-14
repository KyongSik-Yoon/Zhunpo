#!/usr/bin/env bash

# Colors and formatting
# Get script directory - compatible with both bash and zsh
if [ -n "${BASH_SOURCE[0]}" ]; then
    SHUNPO_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
elif [ -n "${(%):-%N}" ]; then
    SHUNPO_SCRIPT_DIR="${${(%):-%N}:A:h}"
else
    SHUNPO_SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
fi
source "$SHUNPO_SCRIPT_DIR"/colors.sh
source "$SHUNPO_SCRIPT_DIR"/functions.sh

function shunpo_handle_kill() {
    shunpo_clear_output
    shunpo_cleanup
    exit 1
}

trap 'shunpo_handle_kill' SIGINT

if ! shunpo_assert_bookmarks_exist; then
    exit 1
fi

shunpo_interact_bookmarks "List Bookmarks"
shunpo_cleanup
