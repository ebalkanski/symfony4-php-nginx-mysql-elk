ARG ELK_VERSION

FROM docker.elastic.co/kibana/kibana:${ELK_VERSION}

COPY --chown=kibana:kibana ./config/kibana.yml /usr/share/kibana/config/