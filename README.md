<div align="center">
  <picture>
    <source srcset="assets/shunpo_logo.png" media="(prefers-color-scheme: dark)">
    <img src="assets/shunpo_logo_inverted.png" alt="Logo" width="400" style="margin: 0; padding: 0;">
  </picture>
  <h4><i>Quick navigation with minimal mental overhead.</i></h4>
</div>

----
Shunpo is a minimalist shell tool that tries to make directory navigation in terminal just a little bit faster by providing a simple system to manage bookmarks and jump to directories with only a few keystrokes.
If you frequently need to use commands like `cd`, `pushd`, or `popd`, Shunpo is for you.

**New**: Now fully compatible with both Bash and Zsh! 🚀  

![Powered by 🍵](https://img.shields.io/badge/Powered%20by-%F0%9F%8D%B5-blue?style=flat-square)
[![Ko-fi](https://img.shields.io/badge/Ko--fi-Buy%20me%20Tea-ff5f5f?logo=kofi&style=flat-square)](https://ko-fi.com/egurapha)
![Built With Nix](https://img.shields.io/badge/Built%20with-Nix-5277C3?logo=nixos&logoColor=white&style=flat-square)
![Code Formatting](https://img.shields.io/github/actions/workflow/status/egurapha/Shunpo/code_formatting.yml?branch=main&label=Code%20Formatting&style=flat-square)
![Unit Tests](https://img.shields.io/github/actions/workflow/status/egurapha/Shunpo/unit_testing.yml?branch=main&label=Unit%20Tests&style=flat-square)

Requirements
----
- **Bash** 3.2 or newer, or
- **Zsh** 5.0 or newer

> **Note**: Zsh compatibility was added using [Claude Code](https://claude.ai/code) to ensure seamless functionality across both shells.

Installation
----
The installation script automatically detects your shell and configures the appropriate RC file:

```bash
./install.sh
```

Then reload your shell configuration:
- **Bash**: `source ~/.bashrc`
- **Zsh**: `source ~/.zshrc`

For nix installation, click [here](nix/NixREADME.md).

Tutorial
----
Click [here](https://www.youtube.com/watch?v=TN66A3MPo50) for a video tutorial.  
<img src="assets/shunpo_demo.gif" width="600" height="auto" alt="Shunpo Demo">

Commands
----
#### Bookmarking:
`sb`: Add the current directory to bookmarks.  
`sg`, `sg [#]` : Go to a bookmark.  
`sr`, `sr [#]` : Remove a bookmark.  
`sl`: List all bookmarks.  
`sc`: Clear all bookmarks.   

#### Navigation:
`sj`, `sj [#]`: "Jump" up to a parent directory.  
`sd`: "Dive" down to a child directory.

#### Selection:
`0~9`: Select an option.  
`n`: Next page.  
`p`: Previous page.  
`b`: Move selection back to parent directory. (For `sd` only.)  
`Enter`: Navigate to selected directory (For `sd` only.)  
 
Uninstalling
----
Run `uninstall.sh`

## Testing

Shunpo includes comprehensive tests that work with both Bash and Zsh:

```bash
# Run tests with automatic shell detection
./run_tests.sh

# Or run tests manually with BATS
bats tests/test_bookmarks.bats tests/test_navigation.bats
```

**Requirements**: BATS (Bash Automated Testing System)
- Ubuntu/Debian: `sudo apt-get install bats`
- macOS: `brew install bats-core`
- Manual: [github.com/bats-core/bats-core](https://github.com/bats-core/bats-core)

## Credits

Based on the original [Shunpo](https://github.com/egurapha/Shunpo) project by [Raphael Eguchi](https://github.com/egurapha). Zsh compatibility and additional improvements added using [Claude Code](https://claude.ai/code).

