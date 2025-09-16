for image in $(grep -ie "^from[[:space:]].*[[:space:]]as[[:space:]].*$" Dockerfile | awk '{print $4}'); do
    echo Building target $image
    docker buildx build . --target $image --tag $image:local
done
docker image prune --force
docker image ls
