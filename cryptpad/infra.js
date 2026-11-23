// One node per tier (upstream runs two of each): same app, about half the memory. Internal nodes use
// 127.0.0.1, not "localhost", which can resolve to ::1 where a container has no IPv6.
// httpHost "::" listens on IPv4 and IPv6, so the Sandbox service reaches this service over
// Railway's IPv6 private network. (Upstream's CPAD_MAIN_DOMAIN switch forces 0.0.0.0, IPv4 only,
// so this template uses its own variable names.)
// SPDX-License-Identifier: AGPL-3.0-or-later
module.exports = {
    public: {
        origin: process.env.CRYPTPAD_ORIGIN,
        sandboxOrigin: process.env.CRYPTPAD_SANDBOX_ORIGIN,
        httpHost: "::",
        httpPort: Number(process.env.PORT) || 3000,
        externalWebsocketURL: undefined,
        fileHost: undefined,
        httpServerId: "",
    },
    front: [{ host: "127.0.0.1", port: 3010 }],
    core: [{ host: "127.0.0.1", port: 3020 }],
    storage: [{ host: "127.0.0.1", port: 3030, wsPort: 3040 }],
};
