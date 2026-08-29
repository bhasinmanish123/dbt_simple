#!/bin/bash
# ============================================================
# run.sh — the dbt commands that run INSIDE the container
# (This is where "dbt build" actually lives — like Helia's run.sh)
# ============================================================
set -e   # stop if any command fails

TARGET="${1:-dev}"   # first argument = target, default 'dev'

echo "=== dbt debug (checking connection) ==="
dbt debug --target "$TARGET"

echo "=== dbt deps ==="
dbt deps || true

echo "=== dbt build --target $TARGET ==="
dbt build --target "$TARGET"

echo "=== DONE ==="
