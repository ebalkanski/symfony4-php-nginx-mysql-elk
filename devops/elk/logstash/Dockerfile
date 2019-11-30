ARG ELK_VERSION

FROM docker.elastic.co/logstash/logstash:${ELK_VERSION}

COPY config/logstash.yml /usr/share/logstash/config/
RUN rm -f /usr/share/logstash/pipeline/logstash.conf
COPY pipeline /usr/share/logstash/pipeline/