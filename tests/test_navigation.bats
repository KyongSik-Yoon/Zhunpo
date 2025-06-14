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
    
    source ${SHUNPO_DIR}/scripts/functions.sh
    cd ${SHUNPO_TEST_DIR}
}

teardown() {
    echo "Shutting Down Test."
    cd "$working_dir"
    ./uninstall.sh
}

@test "Test Jump to Parent." {
    # Set up directory structure.
    make_directories 1
    cd ${SHUNPO_TEST_DIR}/1/2/3/4.2

    # Check expected success and failures.
    run sj 1 >/dev/null && assert_success
    run sj -3 >/dev/null && assert_failure
    run sj "b" >/dev/null && assert_failure

    # Check that post-jump directories are correct.
    sj 1 >/dev/null
    assert_equal $(pwd) "${SHUNPO_TEST_DIR}/1/2/3"

    sg 2 >/dev/null
    assert_equal $(pwd) "${SHUNPO_TEST_DIR}/1/2"
}
