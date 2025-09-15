image=docker-lighttpd:local
if [ "$1" == "ghcr" ]; then
    image=ghcr.io/jon-hedgerows/docker-lighttpd:dev
fi
if [ ! -f test-data/logs/access.log ] ; then
    touch test-data/logs/access.log
    chmod a+rw test-data/logs/access.log
fi
docker run -d --name lighttpd -p 8000:8000 -v ./test-data/html:/data/html -v ./test-data/conf.d:/data/lighttpd.d -v ./test-data/logs:/data/logs $image
