docker run -d --name lighttpd -p 80:80 -v ./test-data/html:/data/html -v ./test-data/conf.d:/data/lighttpd.d --entrypoint=/bin/bash -i docker-lighttpd:dev
