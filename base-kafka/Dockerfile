FROM java:8-jre

ENV DEBIAN_FRONTEND noninteractive
ENV SCALA_VERSION 2.11
ENV KAFKA_VERSION 0.10.1.0
ENV KAFKA_HOME /opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"
#fix terminal bug docker
ENV TERM xterm


RUN apt-get update && \
    apt-get install -y zookeeper wget supervisor dnsutils vim netcat && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    wget -q http://apache.mirrors.spacedump.net/kafka/"$KAFKA_VERSION"/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -O /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz && \
    tar xfz /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -C /opt && \
	rm /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz

RUN wget -q https://github.com/outbrain/zookeepercli/releases/download/v1.0.10/zookeepercli_1.0.10_amd64.deb -O /tmp/zookeepercli_1.0.10_amd64.deb && \
	dpkg -i /tmp/zookeepercli_1.0.10_amd64.deb 

COPY config /config
COPY scripts /scripts
RUN chmod +x /scripts/*.sh

ENTRYPOINT ["/scripts/entrypoint.sh"]
