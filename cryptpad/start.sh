#!/bin/bash
# Railway start script for CryptPad.
# - checks the two origins, prepares the volume (Railway mounts it root-owned),
# - on a fresh volume, registers the generated install token so only the deployer can create the
#   first admin account (CRYPTPAD_ADMIN_SETUP_URL),
# - builds the pages for this instance's origin and runs the server as the cryptpad user,
# - exits non-zero whenever the server stops unexpectedly, so Railway's ON_FAILURE policy restarts it
#   (upstream's launcher exits 0 when a child process is killed, for example by the OOM killer).
set -euo pipefail

: "${CRYPTPAD_ORIGIN:?CRYPTPAD_ORIGIN is not set (the main https:// address)}"
: "${CRYPTPAD_SANDBOX_ORIGIN:?CRYPTPAD_SANDBOX_ORIGIN is not set (the Sandbox service https:// address)}"
for o in "$CRYPTPAD_ORIGIN" "$CRYPTPAD_SANDBOX_ORIGIN"; do
  [[ "$o" =~ ^https?://[^/]+[^/:]$ ]] || { echo "railway: '$o' is not a full address such as https://example.up.railway.app (no path, no trailing slash)"; exit 1; }
done
if [ "$CRYPTPAD_ORIGIN" = "$CRYPTPAD_SANDBOX_ORIGIN" ]; then
  echo "railway: CRYPTPAD_ORIGIN and CRYPTPAD_SANDBOX_ORIGIN must be two different, non-empty addresses"; exit 1
fi

mkdir -p /data/datastore /data/block /data/blob /data/data
chown -R cryptpad:cryptpad /data
as_cryptpad() { setpriv --reuid=4001 --regid=4001 --clear-groups env HOME=/cryptpad "$@"; }

decrees=/data/data/decree.ndjson
if ! grep -qs '"ADD_FIRST_ADMIN"\|"ADD_INSTALL_TOKEN"' "$decrees"; then
  token="${CRYPTPAD_INSTALL_TOKEN:-}"
  if [[ "$token" =~ ^[0-9a-f]{64}$ ]]; then
    printf '["ADD_INSTALL_TOKEN",["%s"],"",%s000]\n' "$token" "$(date +%s)" >> "$decrees"
    chown cryptpad:cryptpad "$decrees"
    echo "railway: first boot: open CRYPTPAD_ADMIN_SETUP_URL (CryptPad service variables) to create the admin account"
  else
    echo "railway: CRYPTPAD_INSTALL_TOKEN is not 64 lowercase hex characters; CryptPad will generate its own token and print the setup link below"
  fi
fi

cd /cryptpad
as_cryptpad npm run --silent build >/dev/null

stopping=0
trap 'stopping=1; [ -n "${pid:-}" ] && kill -TERM "$pid" 2>/dev/null' TERM INT
as_cryptpad node server.js &
pid=$!
set +e
wait "$pid"; rc=$?
while [ "$stopping" = 1 ] && kill -0 "$pid" 2>/dev/null; do wait "$pid"; rc=$?; done
if [ "$stopping" = 1 ]; then exit 0; fi
echo "railway: CryptPad server stopped unexpectedly (exit $rc); exiting non-zero so Railway restarts it"
[ "$rc" -eq 0 ] && rc=1
exit "$rc"
