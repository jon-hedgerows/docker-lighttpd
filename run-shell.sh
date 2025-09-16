image=${1:-lighttpd:local}

docker run -d --name lighttpd -p 8000:8000 -v ./test-data/html:/data/html -v ./test-data/conf.d:/data/lighttpd.d --entrypoint=/bin/sh -i $image
