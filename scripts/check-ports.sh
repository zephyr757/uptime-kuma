#!/usr/bin/env bash
set -euo pipefail

# Load .env if present
if [[ -f .env ]]; then
  # shellcheck disable=SC2046
  set -a; source .env; set +a
fi

ports=()
ports+=("${KUMA_HOST_PORT:-8010}")
ports+=("${KUMA_HOST_PORT_A:-8010}")
ports+=("${KUMA_HOST_PORT_B:-8011}")
ports+=("${KUMA_HOST_PORT_C:-8012}")

echo "Checking ports: ${ports[*]}" >&2
status=0
for p in "${ports[@]}"; do
  if scripts/check-port.sh "$p" | grep -q '^IN USE'; then
    status=1
  fi
done
exit $status
