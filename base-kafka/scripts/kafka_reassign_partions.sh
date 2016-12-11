#!/bin/bash

FILE_TOPIC_TO_MOVE='/tmp/topics-to-move.json'
FILE_EXPAND_CLUSTER_REASSIGNMENT='/tmp/expand-cluster-reassignment.json'


echo "Show topic status (infobip-topic)"
$KAFKA_HOME/bin/kafka-topics.sh --describe \
--zookeeper zookeeper1:2181,zookeeper2:2181,zookeeper3:2181 \
--topic infobip-topic

for i in $($KAFKA_HOME/bin/kafka-topics.sh --list --zookeeper zookeeper1:2181,zookeeper2:2181,zookeeper3:2181)
do
/bin/cat <<EOF >$FILE_TOPIC_TO_MOVE
{"topics": [{"topic": "$i"}],
 "version":1
}
EOF

BROKER_LIST=$(zookeepercli --servers zookeeper1:2181,zookeeper2:2181,zookeeper3:2181 -c ls /brokers/ids | paste -sd,)

echo "Generate reassignment $i"
$KAFKA_HOME/bin/kafka-reassign-partitions.sh \
--zookeeper zookeeper1:2181,zookeeper2:2181,zookeeper3:2181 \
--topics-to-move-json-file /tmp/topics-to-move.json \
--broker-list $BROKER_LIST \
--generate | grep -A100 "Proposed partition reassignment configuration" |tail -1 > $FILE_EXPAND_CLUSTER_REASSIGNMENT

echo "Execute reassignment $i"
$KAFKA_HOME/bin/kafka-reassign-partitions.sh \
--zookeeper zookeeper1:2181,zookeeper2:2181,zookeeper3:2181 \
--reassignment-json-file $FILE_EXPAND_CLUSTER_REASSIGNMENT \
--execute

sleep 5

echo "Verify reassignment $i"
$KAFKA_HOME/bin/kafka-reassign-partitions.sh \
--zookeeper zookeeper1:2181,zookeeper2:2181,zookeeper3:2181 \
--reassignment-json-file $FILE_EXPAND_CLUSTER_REASSIGNMENT \
--verify

echo "Replica election $i"
$KAFKA_HOME/bin/kafka-preferred-replica-election.sh \
--zookeeper zookeeper1:2181,zookeeper2:2181,zookeeper3:2181
done

echo "Show topic status (infobip-topic)"
$KAFKA_HOME/bin/kafka-topics.sh --describe \
--zookeeper zookeeper1:2181,zookeeper2:2181,zookeeper3:2181 \
--topic infobip-topic
