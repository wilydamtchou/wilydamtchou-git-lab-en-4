#!/bin/bash

# GitHub Actions Self-Hosted Runner Manager
# This script helps manage the GitHub Actions runner on your machine

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Runner directory
RUNNER_DIR="$HOME/actions-runner"

# Function to print colored output
print_status() {
    echo -e "${BLUE}➜${NC} $1"
}

print_success() {
    echo -e "${GREEN}✅${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

# Function to check if runner is running
is_runner_running() {
    if pgrep -f "actions-runner" > /dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to start the runner
start_runner() {
    print_status "Starting GitHub Actions runner..."

    if ! [ -d "$RUNNER_DIR" ]; then
        print_error "Runner directory not found at $RUNNER_DIR"
        print_warning "Please set up the runner first. Visit:"
        echo "https://github.com/YOUR_USERNAME/YOUR_REPO/settings/actions/runners"
        exit 1
    fi

    if is_runner_running; then
        print_warning "Runner is already running"
        return
    fi

    cd "$RUNNER_DIR"

    # Start the runner in background
    nohup ./run.sh > "$RUNNER_DIR/runner.log" 2>&1 &

    sleep 2

    if is_runner_running; then
        print_success "Runner started successfully"
        print_status "Runner logs: $RUNNER_DIR/runner.log"
    else
        print_error "Failed to start runner"
        tail -n 20 "$RUNNER_DIR/runner.log"
        exit 1
    fi
}

# Function to stop the runner
stop_runner() {
    print_status "Stopping GitHub Actions runner..."

    if ! is_runner_running; then
        print_warning "Runner is not running"
        return
    fi

    pkill -f "actions-runner" || true
    sleep 2

    if ! is_runner_running; then
        print_success "Runner stopped successfully"
    else
        print_error "Failed to stop runner"
        exit 1
    fi
}

# Function to check runner status
check_status() {
    print_status "Checking runner status..."
    echo ""

    if is_runner_running; then
        print_success "Runner is RUNNING"

        # Show process info
        ps aux | grep "actions-runner" | grep -v grep | head -1

        echo ""
        print_status "Recent logs:"
        if [ -f "$RUNNER_DIR/runner.log" ]; then
            tail -n 10 "$RUNNER_DIR/runner.log"
        else
            echo "No logs available yet"
        fi
    else
        print_error "Runner is NOT RUNNING"
        echo ""
        print_status "To start the runner, run:"
        echo "  $0 start"
    fi
}

# Function to show logs
show_logs() {
    print_status "Runner logs:"

    if [ -f "$RUNNER_DIR/runner.log" ]; then
        tail -f "$RUNNER_DIR/runner.log"
    else
        print_error "No logs found at $RUNNER_DIR/runner.log"
        exit 1
    fi
}

# Function to show diagnostics
show_diagnostics() {
    print_status "GitHub Actions Runner Diagnostics"
    echo "======================================================"

    print_status "Runner Directory: $RUNNER_DIR"
    if [ -d "$RUNNER_DIR" ]; then
        print_success "Directory exists"
        ls -lah "$RUNNER_DIR" | head -10
    else
        print_error "Directory does not exist"
    fi

    echo ""
    print_status "Runner Status:"
    if is_runner_running; then
        print_success "RUNNING"
    else
        print_warning "NOT RUNNING"
    fi

    echo ""
    print_status "System Requirements:"
    bash "$(dirname "$0")/check-runner.sh"

    echo ""
    echo "======================================================"
    print_status "For more information, see:"
    echo "  GITHUB_ACTIONS_SETUP.md"
    echo "  DEPLOYMENT_GUIDE.md"
}

# Function to show usage
show_usage() {
    echo "GitHub Actions Self-Hosted Runner Manager"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start       Start the GitHub Actions runner"
    echo "  stop        Stop the GitHub Actions runner"
    echo "  status      Check runner status"
    echo "  logs        Show runner logs (follow mode)"
    echo "  diag        Show diagnostics information"
    echo "  help        Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 start       # Start the runner"
    echo "  $0 status      # Check if runner is running"
    echo "  $0 logs        # Watch logs in real-time"
    echo ""
}

# Main script
case "${1:-help}" in
    start)
        start_runner
        ;;
    stop)
        stop_runner
        ;;
    status)
        check_status
        ;;
    logs)
        show_logs
        ;;
    diag)
        show_diagnostics
        ;;
    help|--help|-h)
        show_usage
        ;;
    *)
        print_error "Unknown command: $1"
        echo ""
        show_usage
        exit 1
        ;;
esac

exit 0
