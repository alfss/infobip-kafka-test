#!/bin/bash
set -e

if [ "$1" = 'zookeeper' ]; then
	cp /config/zookeeper/zoo.cfg /etc/zookeeper/conf/
	echo "$2" > /etc/zookeeper/conf/myid 
	/usr/share/zookeeper/bin/zkServer.sh start-foreground
fi

if [[ "$1" = 'kafka' ]]; then
	cp /config/kafka/server.properties $KAFKA_HOME/config/server.properties
	JMX_PORT=9999 $KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties
fi

exec "$@"