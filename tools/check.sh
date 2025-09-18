#!/usr/bin/env bash
set -euo pipefail
projects=("mytoken" "escrow" "simplenft" "minimarket" "paysplit" "vesting")
for p in "${projects[@]}"; do
  echo "===> '$p'"
  (cd "$p" && aptos move clean && aptos move compile && aptos move test --filter .)
done
echo "OK: all projects built & tests passed"
