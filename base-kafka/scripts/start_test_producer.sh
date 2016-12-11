#!/bin/bash

for i in `seq 1 1000000`
do 
	echo $i | $KAFKA_HOME/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic infobip-topic 
done
