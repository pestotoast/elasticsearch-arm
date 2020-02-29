# elasticsearch-arm
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker build -t elasticsearch-armhf --build-arg ELASTICSEARCH_VERSION=7.6.0 .