node {
    checkout scm
    def image = docker.build("pestotoast/elasticsearch-armhf")
    image.push
}