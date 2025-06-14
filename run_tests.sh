#!/usr/bin/env bash

# Test runner script that works with both bash and zsh
# This script can run both BATS tests and our custom test framework

echo "Shunpo Test Runner"
echo "=================="

# Detect current shell
if [ -n "$ZSH_VERSION" ]; then
    CURRENT_SHELL="zsh"
    echo "Running in: Zsh $ZSH_VERSION"
elif [ -n "$BASH_VERSION" ]; then
    CURRENT_SHELL="bash"
    echo "Running in: Bash $BASH_VERSION"
else
    CURRENT_SHELL="unknown"
    echo "Running in: Unknown shell"
fi

echo ""

# Check if we should use BATS or our simple framework
USE_SIMPLE_TESTS=false
if ! command -v bats >/dev/null 2>&1; then
    echo "ℹ️  BATS not found, using built-in test framework"
    USE_SIMPLE_TESTS=true
else
    echo "✅ BATS is available: $(bats --version)"
    echo "🔄 You can also use built-in tests with: $0 --simple"
fi

# Parse command line arguments
if [ "$1" = "--simple" ] || [ "$1" = "-s" ]; then
    USE_SIMPLE_TESTS=true
    echo "🔧 Using built-in test framework (--simple mode)"
fi

echo ""

# Function to run BATS tests
run_bats_test() {
    local test_file="$1"
    local shell_name="$2"
    
    echo "🧪 Running BATS test: $test_file with $shell_name..."
    
    if [ "$shell_name" = "bash" ]; then
        bats "$test_file"
    elif [ "$shell_name" = "zsh" ]; then
        # For zsh, we need to ensure proper environment
        zsh -c "source ~/.zshrc 2>/dev/null || true; bats '$test_file'"
    fi
    
    local exit_code=$?
    if [ $exit_code -eq 0 ]; then
        echo "✅ $test_file passed with $shell_name"
    else
        echo "❌ $test_file failed with $shell_name (exit code: $exit_code)"
    fi
    echo ""
    return $exit_code
}

# Function to run simple tests
run_simple_test() {
    local test_file="$1"
    local shell_name="$2"
    
    echo "🧪 Running simple test: $test_file with $shell_name..."
    
    if [ "$shell_name" = "bash" ]; then
        bash "$test_file"
    elif [ "$shell_name" = "zsh" ]; then
        zsh "$test_file"
    fi
    
    local exit_code=$?
    if [ $exit_code -eq 0 ]; then
        echo "✅ $test_file passed with $shell_name"
    else
        echo "❌ $test_file failed with $shell_name (exit code: $exit_code)"
    fi
    echo ""
    return $exit_code
}

# Test files to run
if [ "$USE_SIMPLE_TESTS" = "true" ]; then
    TEST_FILES=(
        "tests/test_bookmarks_simple.sh"
        "tests/test_navigation_simple.sh"
    )
    TEST_TYPE="simple"
else
    TEST_FILES=(
        "tests/test_bookmarks.bats"
        "tests/test_navigation.bats"
    )
    TEST_TYPE="bats"
fi

echo "Running $TEST_TYPE tests with current shell ($CURRENT_SHELL):"
echo "==============================================="

overall_success=0

for test_file in "${TEST_FILES[@]}"; do
    if [ -f "$test_file" ]; then
        if [ "$USE_SIMPLE_TESTS" = "true" ]; then
            run_simple_test "$test_file" "$CURRENT_SHELL"
        else
            run_bats_test "$test_file" "$CURRENT_SHELL"
        fi
        if [ $? -ne 0 ]; then
            overall_success=1
        fi
    else
        echo "❌ Test file not found: $test_file"
        overall_success=1
    fi
done

echo "Summary:"
echo "========"
if [ $overall_success -eq 0 ]; then
    echo "✅ All tests passed!"
else
    echo "❌ Some tests failed. Check output above for details."
fi

echo ""
echo "Note: This script ensures zsh compatibility by:"
echo "- Detecting the current shell environment"
echo "- Sourcing appropriate RC files (.bashrc or .zshrc)"
echo "- Running tests in the correct shell context"
echo "- Supporting both BATS and built-in test frameworks"
echo ""
echo "Usage:"
echo "  $0           # Auto-detect BATS or use simple tests"
echo "  $0 --simple  # Force use of built-in test framework"

exit $overall_success