FROM ubuntu:noble

LABEL maintainer="Jon Davies <jon@hedgerows.org.uk>" \
    maintainer.org="Jon Davies" \
    maintainer.org.uri="https://github.com/jon-hedgerows" \
    # Open container labels \
    org.opencontainers.image.description="Lighttpd on Ubuntu linux plus extras" \
    org.opencontainers.image.vendor="Jon Davies" \
    org.opencontainers.image.source="https://github.com/jon-hedgerows/docker-lighttpd" \
    # Artifact hub annotations \
    io.artifacthub.package.alternative-locations="oci://ghcr.io/jon-hedgerows/docker-lighttpd" \
    io.artifacthub.package.readme-url="https://github.com/jon-hedgerows/docker-lighttpd/-/raw/main/README.md" \
    io.artifacthub.package.logo-url="https://github.com/jon-hedgerows/docker-lighttpd/-/raw/main/favicon.svg"

ENV PORT=8000 \
    SERVER_NAME="localhost" \
    SERVER_ROOT="/data/html/" \
    CONFIG_FILE="/etc/lighttpd/lighttpd.conf" \
    SKIP_HEALTHCHECK="false" \
    MAX_FDS="1024"

RUN apt-get -yqq update \
    && apt-get -yqq upgrade

RUN apt-get -yqq install lighttpd curl bash git

COPY ./files /staging/

RUN install /staging/entrypoint /usr/local/bin \
    && install /staging/healthcheck /usr/local/bin \
    && install --directory /etc/lighttpd/conf.d \
    && install --directory /data/lighttpd.d \
    && install --directory /data/html \
    && install /staging/index.html /data/html \
    && install --mode=u=rw,go=r /staging/lighttpd.conf /etc/lighttpd/lighttpd.conf \ 
    && install --mode=u=rw,go=r /staging/conf.d/*.conf /etc/lighttpd/conf.d/ \
    && rm -rf /staging
# Check config is ok
RUN lighttpd -t -f /etc/lighttpd/lighttpd.conf

VOLUME /data/html
VOLUME /data/lighttpd.d
# VOLUME /etc/lighttpd

HEALTHCHECK --interval=1m --timeout=5s --start-period=30s CMD healthcheck
ENTRYPOINT ["entrypoint"]
CMD ["-D"]
# CMD ["/bin/bash", "-c", "while true; do date ; sleep 60 ; done"]