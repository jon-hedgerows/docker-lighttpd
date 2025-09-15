image=docker-lighttpd:local
if [ "$1" == "ghcr" ]; then
    image=ghcr.io/jon-hedgerows/docker-lighttpd:dev
fi

docker run -d --name lighttpd -p 80:80 -v ./test-data/html:/data/html -v ./test-data/conf.d:/data/lighttpd.d --entrypoint=/bin/bash -i $image
