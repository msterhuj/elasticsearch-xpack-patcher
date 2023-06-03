FROM elasticsearch:8.7.0 as builder

USER root

ENV elasticsearch_dir=elasticsearch
ENV elasticsearch_version=8.7.0

RUN apt update && apt install -y wget patch openjdk-17-jdk

WORKDIR /usr/share/

COPY ./patch.sh patch.sh
COPY ./patch patch

RUN chmod +x patch.sh
RUN ./patch.sh

FROM elasticsearch:8.7.0

COPY --from=builder \
    /usr/share/elasticsearch/modules/x-pack-core/x-pack-core-8.7.0.jar \
    /usr/share/elasticsearch/modules/x-pack-core/x-pack-core-8.7.0.jar
