docker run -d --name lighttpd -p 80:80 -v ./test-data/html:/data/html -v ./test-data/conf.d:/data/lighttpd.d -v ./test-data/logs:/data/logs docker-lighttpd:dev
