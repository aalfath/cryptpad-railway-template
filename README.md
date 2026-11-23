[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/cryptpad-1?utm_medium=integration&utm_source=button&utm_campaign=cryptpad)

# CryptPad on Railway

One-click [Railway](https://railway.com) template for [CryptPad](https://cryptpad.org), the end-to-end encrypted collaborative office suite (documents, sheets, presentations, rich text, kanban, whiteboards, diagrams, forms).

**Version:** CryptPad `2026.10.1`, official image `cryptpad/cryptpad:version-2026.10.1@sha256:b1129d954692e9b8a7d198e79d3080d3627051c95137bbf41a7d2683aa53305d`, office editors (Euro-Office v9 + x2t) baked in at build time.

## What it deploys

| Service | Folder | What it does |
|---|---|---|
| **CryptPad** | `cryptpad/` | The CryptPad server. Volume at `/data` (documents, files, accounts, admin settings). Health check `/api/config`. |
| **Sandbox** | `sandbox/` | Caddy `2.11.9-alpine` (pinned by digest) giving CryptPad its required second "sandbox" origin, proxied over the private network. Health check `/healthz`. |

No database: CryptPad stores encrypted files on the volume.

## Variables

CryptPad service:

| Variable | Default | Purpose |
|---|---|---|
| `CRYPTPAD_ORIGIN` | `https://${{RAILWAY_PUBLIC_DOMAIN}}` | Main address |
| `CRYPTPAD_SANDBOX_ORIGIN` | `https://${{Sandbox.RAILWAY_PUBLIC_DOMAIN}}` | Sandbox address (must differ from the main one) |
| `CRYPTPAD_INSTALL_TOKEN` | `${{secret(64,"abcdef0123456789")}}` | One-time token for the first admin account |
| `CRYPTPAD_ADMIN_SETUP_URL` | `https://${{RAILWAY_PUBLIC_DOMAIN}}/install/#${{CRYPTPAD_INSTALL_TOKEN}}` | Open once to create the admin |
| `PORT` | `3000` | Listen port |

Optional, not in the template: `CRYPTPAD_MAX_UPLOAD_MB` (default 20), `CRYPTPAD_DEFAULT_STORAGE_MB` (default 50), `CRYPTPAD_LOG_LEVEL` (default `info`).

Sandbox service: `PORT=8080`, `CRYPTPAD_UPSTREAM=${{CryptPad.RAILWAY_PRIVATE_DOMAIN}}:${{CryptPad.PORT}}`.

Nothing to fill in at deploy time.

## After deploy

1. Open `CRYPTPAD_ADMIN_SETUP_URL` (CryptPad service → Variables) and create the admin account. The password derives your keys and can't be reset.
2. In the setup screens, close registration if the instance is invite-only.

## Resources

One worker per pool and one node per tier (upstream runs two), about 200 MB at idle; it runs on a 0.5 GB / 1 vCPU plan. The start script exits non-zero if any server process dies, so Railway's on-failure restart brings it back.

## Updates

Both services build from this repo. A version bump here (new pinned digest plus a `CHANGELOG.md` entry, breaking changes first) makes Railway show "update available" on every deployed project; deployers choose when to apply it. Data on the volume is kept.

## Licence

CryptPad and its office editors are AGPL-3.0; this wrapper is AGPL-3.0 as well.
