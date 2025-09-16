image=${1:-lighttpd:local}

# remove and recreate the access log
rm -f test-data/logs/access.log
touch test-data/logs/access.log
chmod a+rw test-data/logs/access.log

docker run -d --name lighttpd -p 8000:8000 -v ./test-data/html:/data/html -v ./test-data/conf.d:/data/lighttpd.d -v ./test-data/logs:/data/logs $image
