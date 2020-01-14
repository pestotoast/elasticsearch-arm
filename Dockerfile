FROM arm32v7/ubuntu
RUN apt-get update && apt-get install -y wget curl default-jre xz-utils
RUN wget $(curl https://archlinuxarm.org/packages/armv7h/elasticsearch | grep elasticsearch- |grep -Po '(?<=href=")[^"]*')
RUN tar -xf *.tar.xz
EXPOSE 9200
EXPOSE 9300
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-armhf
RUN usr/share/elasticsearch/bin/elasticsearch-plugin install --batch ingest-attachment
ADD elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
ADD jvm.options /etc/elasticsearch/jvm.options
VOLUME /var/lib/elasticsearch
CMD /usr/share/elasticsearch/bin/elasticsearch
