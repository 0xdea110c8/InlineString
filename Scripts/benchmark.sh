#!/usr/bin/env zsh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
RESULTS_DIR="$SCRIPT_DIR/benchmarks"

mkdir -p "$RESULTS_DIR"
swift run -c release InlineStringBenchmarks | sed -n '/^name[[:space:]]/,/^$/p' > "$RESULTS_DIR/benchmarks-$(git rev-parse --short HEAD).txt"
