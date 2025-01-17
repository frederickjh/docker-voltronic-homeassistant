FROM alpine:latest AS core
RUN apk update && apk upgrade
RUN apk add curl coreutils mosquitto-clients bash jq libgcc libstdc++
ADD sources/ /opt/
ADD config/ /etc/inverter/


FROM core AS builder
RUN apk add git make cmake g++
RUN cd /opt/inverter-cli/ && mkdir /opt/inverter-cli/bin && cmake . && make \
&& mv /opt/inverter-cli/inverter_poller /opt/inverter-cli/bin/


FROM core AS production
COPY --from=builder /opt/inverter-cli/bin /opt/inverter-cli/bin
WORKDIR /opt
ENTRYPOINT ["/bin/bash", "/opt/inverter-mqtt/entrypoint.sh"]

