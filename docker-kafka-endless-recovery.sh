#!/bin/bash

while [[ 1 ]]; do
	echo -n "Stop one broker kafka: "
	RES_COMMAND=$(docker-compose scale kafka=2 >/dev/null 2>&1)
	if [ $? -ne 0 ]; then
		code=$?
	    echo "ERROR"
	    echo $RES_COMMAND
	    exit $code
	else
		echo "OK"
	fi

	sleep 10

	echo -n "Count kafka brokers: "
	RES_COMMAND=$(docker exec -it infobip_kafka_1 zookeepercli --servers zookeeper1:2181,zookeeper2:2181,zookeeper3:2181 -c ls /brokers/ids|wc -l)
	if [ $? -ne 0 ]; then
		code=$?
	    echo "ERROR"
	    echo $RES_COMMAND
	    exit $code
	else
		echo $RES_COMMAND
	fi


	echo -n "Start one broker kafka: "
	RES_COMMAND=$(docker-compose scale kafka=3 >/dev/null 2>&1)
	if [ $? -ne 0 ]; then
		code=$?
	    echo "ERROR"
	    echo $RES_COMMAND
	    exit $code
	else
		echo "OK"
	fi

	sleep 10

	echo -n "Count kafka brokers: "
	RES_COMMAND=$(docker exec -it infobip_kafka_1 zookeepercli --servers zookeeper1:2181,zookeeper2:2181,zookeeper3:2181 -c ls /brokers/ids|wc -l)
	if [ $? -ne 0 ]; then
		code=$?
	    echo "ERROR"
	    echo $RES_COMMAND
	    exit $code
	else
		echo $RES_COMMAND
	fi

	echo "Reassign partitions: "
	docker exec -it infobip_kafka_1 /scripts/kafka_reassign_partions.sh

	sleep 10
done

