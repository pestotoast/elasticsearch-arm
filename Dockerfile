FROM arm32v7/alpine as builder
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-armhf
ARG ELASTICSEARCH_VERSION
ENV ELASTICSEARCH_VERSION=$ELASTICSEARCH_VERSION
RUN apk add -U curl xz gpgme
RUN curl https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz.sha512 -o elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz.sha512
RUN curl https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz.asc -o elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz.asc
RUN curl https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz -o elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz
RUN sha512sum -c elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz.sha512
COPY GPG-KEY-elasticsearch GPG-KEY-elasticsearch
RUN gpg --import GPG-KEY-elasticsearch
RUN gpg --verify elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz.asc
RUN tar -xzf elasticsearch-${ELASTICSEARCH_VERSION}-linux-x86_64.tar.gz

FROM arm32v7/ubuntu
ARG ELASTICSEARCH_VERSION
ENV ELASTICSEARCH_VERSION=$ELASTICSEARCH_VERSION
COPY --from=builder /elasticsearch-${ELASTICSEARCH_VERSION} /elasticsearch
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-armhf
RUN apt-get update && apt-get install -y default-jre
EXPOSE 9200
EXPOSE 9300
RUN /elasticsearch/bin/elasticsearch-plugin install --batch ingest-attachment
ADD elasticsearch.yml /elasticsearch/config/elasticsearch.yml
ADD jvm.options /elasticsearch/config/jvm.options
VOLUME /var/data/elasticsearch
CMD /elasticsearch/bin/elasticsearch