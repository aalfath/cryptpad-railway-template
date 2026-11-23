# The CryptPad "sandbox" origin: a second public address for the same CryptPad server.
# CryptPad loads its editors in iframes from this second origin, so a malicious document can't reach
# the keys held by the main page. Railway gives each service one generated domain that templates can
# reference, so the second origin is this small proxy over the private network.
# SPDX-License-Identifier: AGPL-3.0-or-later
FROM caddy:2.11.9-alpine@sha256:003a97808e781aa9f7e75cc2f43d34d461099031faf5e20faefb9f61126836f0
COPY Caddyfile /etc/caddy/Caddyfile
COPY start.sh /usr/local/bin/sandbox-start
RUN chmod 0755 /usr/local/bin/sandbox-start && sh -n /usr/local/bin/sandbox-start \
 && PORT=8080 CRYPTPAD_UPSTREAM=cryptpad.railway.internal:3000 caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile
# Railway shows 32 CPUs inside a 1 vCPU service; keep the Go runtime small.
ENV GOMAXPROCS=2 PORT=8080
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/sandbox-start"]
