#!/bin/bash
echo -n "Init Cluster: "
{ 
	docker-compose down && docker-compose build && docker-compose up -d && docker-compose scale kafka=3 
} >/dev/null 2>&1
if [ $? -ne 0 ]; then
	code=$?
    echo "ERROR"
    exit $code
else
	echo "OK"
fi

sleep 5

echo -n "Create topic (infobip-topic partions=1 replica=3): "
RES_COMMAND=$(docker exec -it infobip_kafka_1 /opt/kafka_2.11-0.10.1.0/bin/kafka-topics.sh \
	--create \
	--zookeeper zookeeper1:2181,zookeeper2:2181,zookeeper3:2181 \
	--replication-factor 3 \
	--partitions 1 \
	--topic infobip-topic)
if [ $? -ne 0 ]; then
	code=$?
    echo "ERROR"
    echo $RES_COMMAND
    exit $code
else
	echo "OK"
fi