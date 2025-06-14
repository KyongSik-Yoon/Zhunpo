#!/usr/bin/env bash

# This script should be sourced and not executed.

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
    if declare -f shunpo_cleanup >/dev/null; then
        shunpo_cleanup
    fi
    return 1
}

trap 'shunpo_handle_kill; return 1' SIGINT

shunpo_jump_to_parent_dir $1

# Handle case where bookmark is not set.
if [ $? -eq 1 ]; then

    if declare -f shunpo_cleanup >/dev/null; then
        shunpo_cleanup
    fi
    return 1
elif [ $? -eq 2 ]; then
    if declare -f shunpo_cleanup >/dev/null; then
        shunpo_cleanup
    fi
    echo -e "${SHUNPO_BOLD}${SHUNPO_ORANGE}Invalid Parent Selection.${SHUNPO_RESET}"
    return 1
fi

if declare -f shunpo_cleanup >/dev/null; then
    shunpo_cleanup
fi
