# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Shunpo is a minimalist shell tool (compatible with both bash and zsh) for fast directory navigation through bookmarks and jumping to parent/child directories. The tool consists of:

- **Core functions** (`src/functions.sh`): Interactive pagination systems for bookmarks and directory navigation
- **Command scripts** (`src/*.sh`): Individual shell scripts for each command (sb, sg, sr, sl, sc, sj, sd)
- **Installation system**: `install.sh` creates command aliases and installs to `~/.local/share/shunpo/`
- **Test suite**: BATS-based tests in `tests/` directory

## Common Commands

### Development and Testing
- **Run tests**: `bats tests/test_bookmarks.bats tests/test_navigation.bats`
- **Install locally (bash)**: `./install.sh && source ~/.bashrc`
- **Install locally (zsh)**: `./install.sh && source ~/.zshrc`
- **Uninstall**: `./uninstall.sh`

### Nix Development
- **Build with Nix**: `cd nix && nix build .`
- **Test Nix build**: `cd nix && source result/bin/shunpo_init`
- **Install via Nix**: `cd nix && nix profile install .#shunpo`

## Architecture

### Core Interactive Functions
- `shunpo_interact_bookmarks()`: Handles bookmark selection with pagination
- `shunpo_jump_to_parent_dir()`: Interactive parent directory selection
- `shunpo_jump_to_child_dir()`: Interactive child directory navigation with caching

### Terminal Management
- Uses `tput` commands for cursor manipulation and screen clearing
- Implements pagination system with 10 items per page
- Handles terminal resizing with `shunpo_add_space()` function

### Data Storage
- Bookmarks stored in `${XDG_DATA_HOME:-$HOME/.local/share}/shunpo/.shunpo_bookmarks`
- Each bookmark is a full directory path on a separate line

### Command Structure
Each command (sb, sg, sr, etc.) is a separate script that sources `functions.sh` and `colors.sh` for shared functionality.

## Testing

Tests use the BATS framework and create isolated environments in `/tmp/shunpo_test/`. Key test utilities:
- `setup_env()`: Creates test HOME and XDG_DATA_HOME directories
- `make_directories()`: Creates predictable directory structures for testing
- Tests cover installation, bookmarking, navigation, and error handling