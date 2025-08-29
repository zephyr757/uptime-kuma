#!/usr/bin/env bash
set -euo pipefail
PORT="${1:-}"
if [[ -z "${PORT}" ]]; then
  echo "Usage: $0 <port>" >&2
  exit 2
fi

if command -v lsof >/dev/null 2>&1; then
  if lsof -nP -iTCP:"${PORT}" -sTCP:LISTEN >/dev/null 2>&1; then
    echo "IN USE: ${PORT}"
    exit 1
  else
    echo "FREE: ${PORT}"
  fi
else
  echo "lsof not found; cannot check ports reliably" >&2
  exit 3
fi
