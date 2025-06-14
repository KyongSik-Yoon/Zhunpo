#!/usr/bin/env bash

# Get install paths.
DEFAULT_INSTALL_DIR=${XDG_DATA_HOME:-$HOME/.local/share}/shunpo
# Use compatible read command for both bash and zsh
if [ -n "$ZSH_VERSION" ]; then
    echo -n "Enter the installation directory [default: $DEFAULT_INSTALL_DIR]: "
    read user_input
else
    read -p "Enter the installation directory [default: $DEFAULT_INSTALL_DIR]: " user_input
fi
INSTALL_DIR=${user_input:-"$DEFAULT_INSTALL_DIR"}
SCRIPT_DIR=${INSTALL_DIR}/scripts/

# Detect shell and set appropriate RC file
if [ -n "$ZSH_VERSION" ]; then
    RC_FILE="$HOME/.zshrc"
    SHELL_NAME="zsh"
else
    RC_FILE="$HOME/.bashrc"
    SHELL_NAME="bash"
fi

# File containing command definitions.
SHUNPO_CMD="$INSTALL_DIR/shunpo_cmd"

setup() {
    mkdir -p $INSTALL_DIR
    mkdir -p $SCRIPT_DIR
    if [ -f $SHUNPO_CMD ]; then
        rm $SHUNPO_CMD
    fi
    touch $SHUNPO_CMD
}

add_commands() {
    # Define command set.
    SCRIPT_DIR="$(realpath "$SCRIPT_DIR")"
    cat >"$SHUNPO_CMD" <<EOF
#!/usr/bin/env bash
sj() { source "$SCRIPT_DIR/jump_to_parent.sh" "\$@"; }
sd() { source "$SCRIPT_DIR/jump_to_child.sh"; }
sb() { "$SCRIPT_DIR/add_bookmark.sh"; }
sr() { "$SCRIPT_DIR/remove_bookmark.sh" "\$@"; }
sg() { source "$SCRIPT_DIR/go_to_bookmark.sh" "\$@"; }
sl() { "$SCRIPT_DIR/list_bookmarks.sh"; }
sc() { "$SCRIPT_DIR/clear_bookmarks.sh"; }
EOF
}

install() {
    # Store scripts in SCRIPTS_DIR.
    cp src/* $SCRIPT_DIR

    # Add sourcing for shunpo_cmd (overwrite).
    source_rc_line="source $SHUNPO_CMD"
    temp_file=$(mktemp)
    sed '/^source.*\shunpo_cmd/d' "$RC_FILE" >"$temp_file"
    mv "$temp_file" "$RC_FILE"
    echo "$source_rc_line" >>"$RC_FILE"
    echo "Added to $SHELL_NAME RC file: $source_rc_line"

    # Record SHUNPO_DIR for uninstallation (overwrite).
    install_dir_line="export SHUNPO_DIR=$INSTALL_DIR"
    temp_file=$(mktemp)
    grep -v '^export SHUNPO_DIR=' "$RC_FILE" >"$temp_file"
    mv "$temp_file" "$RC_FILE"
    echo "$install_dir_line" >>"$RC_FILE"
    echo "Added to $SHELL_NAME RC file: $install_dir_line"

    add_commands
}

# Install.
echo "Installing."
setup
install

echo "Done."
echo "(Remember to run: source $RC_FILE)"
