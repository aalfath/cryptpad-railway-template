#!/bin/sh
# Proxies the sandbox origin to the CryptPad service on Railway's private network.
set -eu
case "${CRYPTPAD_UPSTREAM:-}" in
  "" | ":"* | *":") echo "sandbox: CRYPTPAD_UPSTREAM is empty or incomplete ('${CRYPTPAD_UPSTREAM:-}'), using cryptpad.railway.internal:3000"; CRYPTPAD_UPSTREAM="cryptpad.railway.internal:3000" ;;
esac
export CRYPTPAD_UPSTREAM PORT="${PORT:-8080}"
echo "sandbox: listening on :$PORT, proxying to $CRYPTPAD_UPSTREAM"
exec caddy run --config /etc/caddy/Caddyfile --adapter caddyfile
