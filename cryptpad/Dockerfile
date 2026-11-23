# CryptPad for Railway: the official image, pinned by version and digest, plus a small wrapper.
# SPDX-License-Identifier: AGPL-3.0-or-later
FROM cryptpad/cryptpad:version-2026.10.1@sha256:b1129d954692e9b8a7d198e79d3080d3627051c95137bbf41a7d2683aa53305d

# Office editors (Document, Sheet, Presentation). Upstream installs them at container start into a
# bind mount; here they are baked into the image (release zips checked by sha512 inside the script),
# so the first deploy works and a redeploy never downloads them again. A new instance only needs
# the current editor (v9) and the x2t converter, which is what the script installs by default.
# The editors are AGPL-3.0, based on Euro-Office/ONLYOFFICE (see www/common/onlyoffice/README.md).
RUN ./install-office.sh --accept-license --trust-repository --no-rdfind \
 && rm -rf /cryptpad/onlyoffice-conf/onlyoffice-builds.git

USER root
COPY config.js infra.js start.sh /railway/
RUN chmod 0755 /railway/start.sh \
 && bash -n /railway/start.sh \
 && node --check /railway/config.js && node --check /railway/infra.js \
 && command -v setpriv

ENV CRYPTPAD_CONFIG=/railway/config.js \
    CRYPTPAD_CONFIG_INFRA=/railway/infra.js \
    PORT=3000

EXPOSE 3000
ENTRYPOINT ["/railway/start.sh"]
CMD []
