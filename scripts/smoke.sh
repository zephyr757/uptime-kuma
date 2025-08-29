#!/usr/bin/env bash
set -euo pipefail

# Load .env if present
if [[ -f .env ]]; then
  # shellcheck disable=SC2046
  set -a; source .env; set +a
fi

HOST_PORT="${KUMA_HOST_PORT:-8010}"
URL="http://localhost:${HOST_PORT}"
echo "Probing ${URL}..." >&2
if curl -fsS "${URL}" >/dev/null; then
  echo "OK: ${URL} reachable"
else
  echo "FAIL: ${URL} not reachable" >&2
  exit 1
fi
