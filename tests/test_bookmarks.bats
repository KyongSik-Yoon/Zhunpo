#!/usr/bin/env bats

load common.sh
load bats/assert.sh
load bats/error.sh
load bats/lang.sh
load bats/output.sh

setup() {
    echo "Setting Up Test."
    setup_env
    printf '\n' | ./install.sh
    working_dir=$(pwd)
    
    # Source appropriate RC file based on shell
    if [ -n "$ZSH_VERSION" ]; then
        source ${SHUNPO_TEST_DIR}/home/.zshrc
    else
        source ${SHUNPO_TEST_DIR}/home/.bashrc
    fi
    
    cd ${SHUNPO_TEST_DIR}
}

teardown() {
    echo "Shutting Down Test."
    cd "$working_dir"
    ./uninstall.sh
}

@test "Test Install." {
    [ -e "${SHUNPO_DIR}/shunpo_cmd" ] && assert_success
    [ "$(echo $SHUNPO_DIR)" = "${SHUNPO_DIR}" ] && assert_success
    [ -e "${SHUNPO_DIR}/functions.sh" ] && assert_success
    [ -e "${SHUNPO_DIR}/colors.sh" ] && assert_success
    [ -e "${SHUNPO_DIR}/add_bookmark.sh" ] && assert_success
    [ -e "${SHUNPO_DIR}/go_to_bookmark.sh" ] && assert_success
    [ -e "${SHUNPO_DIR}/remove_bookmark.sh" ] && assert_success
    [ -e "${SHUNPO_DIR}/list_bookmarks.sh" ] && assert_success
    [ -e "${SHUNPO_DIR}/clear_bookmarks.sh" ] && assert_success
    [ -e "${SHUNPO_DIR}/jump_to_parent.sh" ] && assert_success
    [ -e "${SHUNPO_DIR}/jump_to_child.sh" ] && assert_success
    run declare -F sb && assert_success
    run declare -F sg && assert_success
    run declare -F sr && assert_success
    run declare -F sl && assert_success
    run declare -F sc && assert_success
    run declare -F sj && assert_success
    run declare -F sd && assert_success
}

@test "Test Add Bookmark." {
    # Set up directory structure.
    make_directories 1
    assert_success

    # Check if bookmarks are created.
    num_bookmarks=$(get_num_bookmarks)
    assert_equal "$num_bookmarks" "4"

    # Check if bookmark entry is correct.
    bookmark2=$(sed -n 3p ${SHUNPO_DIR}/.shunpo_bookmarks)
    expected_bookmark2="${SHUNPO_TEST_DIR}/1/2"
    assert_equal "$bookmark2" "$expected_bookmark2"
}

@test "Test Go To Bookmark." {
    # Set up directory structure.
    make_directories 1

    # Check sg behavior.
    run sg 3 && assert_success
    sg 3 >/dev/null && echo $(pwd) #&& assert_success
    assert_equal $(pwd) "${SHUNPO_TEST_DIR}/1/2/3"

    run sg 2 && assert_success
    sg 2 >/dev/null && echo $(pwd) #&& assert_success
    assert_equal $(pwd) "${SHUNPO_TEST_DIR}/1/2"

    run sg 7 && assert_failure
    run sg "b" && assert_failure
}

@test "Test Remove Bookmark." {
    # Set up directory structure.
    make_directories 1
    assert [ -f ${SHUNPO_DIR}/.shunpo_bookmarks ]

    # Store the last bookmark.
    bookmark3=$(sed -n 4p ${SHUNPO_DIR}/.shunpo_bookmarks)

    # Check failure handling.
    run sr -1 >/dev/null && assert_failure
    run sr 9 >/dev/null && assert_failure
    run sr "c" >/dev/null && assert_failure

    # Remove bookmarks and check counts.
    run sr 1 && assert_success
    num_bookmarks=$(get_num_bookmarks)
    assert_equal "$num_bookmarks" "3"

    run sr 1 && assert_success
    num_bookmarks=$(get_num_bookmarks)
    assert_equal "$num_bookmarks" "2"

    # Check shifting.
    bookmark1=$(sed -n 2p ${SHUNPO_DIR}/.shunpo_bookmarks)
    assert_equal "$bookmark3" "$bookmark1"

    # Remove until file is removed.
    run sr 0 && assert_success
    run sr 0 && assert_success
    refute [ -f ${SHUNPO_DIR}/.shunpo_bookmarks ]
}

@test "Test Clear Bookmarks." {
    # Set up directory structure.
    make_directories 1

    # Check that the file exists
    assert [ -f ${SHUNPO_DIR}/.shunpo_bookmarks ]

    # Confirm that the file is removed after clearing.
    run sc && assert_success
    refute [ -f ${SHUNPO_DIR}/.shunpo_bookmarks ]
}
