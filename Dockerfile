FROM ubuntu:noble

LABEL maintainer="Jon Davies <jon@hedgerows.org.uk>" \
    maintainer.org="Hedgerows" \
    maintainer.org.uri="https://hedgerows.org.uk" \
    # Open container labels
    org.opencontainers.image.description="Lighttpd on Ubuntu linux plus extras" \
    org.opencontainers.image.vendor="Hedgerows" \
    org.opencontainers.image.source="https://github.com/jon-hedgerows/docker-lighttpd" \
    # Artifact hub annotations
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

RUN install /staging/entrypoint /usr/local/bin
RUN install /staging/healthcheck /usr/local/bin
RUN install --directory /etc/lighttpd/conf.d
RUN install --directory /data/lighttpd.d 
RUN install --directory /data/html 
RUN install /staging/index.html /data/html
RUN install --mode=u=rw,go=r /staging/lighttpd.conf /etc/lighttpd/lighttpd.conf 
RUN install --mode=u=rw,go=r /staging/conf.d/*.conf /etc/lighttpd/conf.d/
RUN rm -rf /staging
# Check config is ok
RUN lighttpd -t -f /etc/lighttpd/lighttpd.conf

VOLUME /data/html
VOLUME /data/lighttpd.d
# VOLUME /etc/lighttpd

HEALTHCHECK --interval=1m --timeout=5s --start-period=30s CMD healthcheck
ENTRYPOINT ["entrypoint"]
CMD ["-D"]
# CMD ["/bin/bash", "-c", "while true; do date ; sleep 60 ; done"]