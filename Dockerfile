FROM alpine:latest

RUN apk update && apk upgrade
RUN apk add curl git g++ make cmake jq mosquitto-clients coreutils bash

ADD sources/ /opt/
ADD config/ /etc/inverter/

RUN cd /opt/inverter-cli && mkdir bin \
    && cmake . && make && \
    mv inverter_poller bin/

HEALTHCHECK \
    --interval=30s \
    --timeout=10s \
    --start-period=1m \
    --retries=3 \
  CMD /opt/healthcheck

WORKDIR /opt
# ENTRYPOINT ["/bin/bash", "/opt/inverter-mqtt/entrypoint.sh"]
