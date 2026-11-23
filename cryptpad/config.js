// CryptPad server config for Railway. Every piece of state lives on the volume at /data.
// SPDX-License-Identifier: AGPL-3.0-or-later
const mb = (name, def) => {
    const n = Number(process.env[name]);
    return (Number.isFinite(n) && n > 0 ? n : def) * 1024 * 1024;
};
module.exports = {
    ...require("/cryptpad/config.local/config.example.js"),
    filePath: "/data/datastore/",
    archivePath: "/data/data/archive",
    pinPath: "/data/data/pins",
    taskPath: "/data/data/tasks",
    blockPath: "/data/block",
    blobPath: "/data/blob",
    blobStagingPath: "/data/data/blobstage",
    decreePath: "/data/data",
    logoPath: "/data/data/logo",
    challengePath: "/data/data/challenges",
    basePath: "/data/data",
    logPath: false,
    logToStdout: true,
    logLevel: process.env.CRYPTPAD_LOG_LEVEL || "info",
    // Upstream starts 2 workers per pool; one each keeps the server inside a 0.5 GB plan.
    maxWorkers: { core: 1, storage: 1, http: 1, "http-storage": 1, "storage-http": 1 },
    // Optional overrides (not template variables): upload size and default quota per account, in MB.
    maxUploadSize: mb("CRYPTPAD_MAX_UPLOAD_MB", 20),
    defaultStorageLimit: mb("CRYPTPAD_DEFAULT_STORAGE_MB", 50),
    installMethod: "railway",
};
