ARG ELK_VERSION

FROM docker.elastic.co/elasticsearch/elasticsearch:${ELK_VERSION}

COPY --chown=elasticsearch:elasticsearch ./config/elasticsearch.yml /usr/share/elasticsearch/config/