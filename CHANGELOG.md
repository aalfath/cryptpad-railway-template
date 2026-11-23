# Changelog

## 2026.10.1 (2026-11-23)

- First release of the template: CryptPad `2026.10.1` (official image pinned by digest, office editors baked in) and a Caddy `2.11.9-alpine` sandbox-origin service.
- All state on one volume at `/data`; first admin claimed with a generated one-time install token.
- Tuned for 0.5 GB (one worker per pool, one node per tier); the start script exits non-zero when any server process dies.
