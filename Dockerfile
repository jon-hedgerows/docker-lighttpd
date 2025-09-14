# syntax=docker/dockerfile:experimental
FROM ubuntu:noble
ARG VERSION
LABEL maintainer="Jon Davies <jon@hedgerows.org.uk>" \
      maintainer.org="Hedgerows" \
      maintainer.org.uri="https://hedgerows.org.uk" \
      # Open container labels
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.created="${BUILD_TIME}" \
      org.opencontainers.image.description="Lighttpd on Ubuntu linux plus extras" \
      org.opencontainers.image.vendor="Hedgerows" \
      org.opencontainers.image.source="https://github.com/jon-hedgerows/docker-lighttpd" \
      # Artifact hub annotations
      io.artifacthub.package.alternative-locations="oci://ghcr.io/jon-hedgerows/docker-lighttpd" \
      io.artifacthub.package.readme-url="https://github.com/jon-hedgerows/docker-lighttpd/-/raw/main/README.md" \
      io.artifacthub.package.logo-url="https://github.com/jon-hedgerows/docker-lighttpd/-/raw/main/favicon.svg"

ARG WWWDATA_GUID="82"
ARG TARGETARCH
ENV PORT=80 \
    SERVER_NAME="localhost" \
    SERVER_ROOT="/var/www/html/" \
    CONFIG_FILE="/etc/lighttpd/lighttpd.conf" \
    SKIP_HEALTHCHECK="false" \
    MAX_FDS="1024" \
    WWWDATA_GUID="${WWWDATA_GUID}"

RUN apt-get -yqq update \
    && apt-get -yqq upgrade

RUN apt-get -yqq install lighttpd wget bash \

RUN install ./entrypoint /usr/local/bin \
    && install ./healthcheck /usr/local/bin \
    && mkdir -p /etc/lighttpd/conf.d /usr/local/lighttpd.d \
    && cp lighttpd.conf /etc/lighttpd \
    && cp conf.d/*.conf /etc/lighttpd/conf.d/ \
    # Sanity check \
    && lighttpd -V

HEALTHCHECK --interval=1m --timeout=5s --start-period=30s CMD healthcheck
ENTRYPOINT ["entrypoint"]
CMD ["-D"]