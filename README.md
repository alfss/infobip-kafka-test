# docker kafka for infobip (test task)


## Required
* Docker
* docker-compose
* bash


## Init Cluster

./docker-kafka-init.sh


## Test HA

### First Terminal
```
./docker-kafka-endless-recovery.sh
```
### Second Terminal
```
docker exec -it infobip_kafka_1 /scripts/start_test_consumer.sh
```

###Third terminal
```
docker exec -it infobip_kafka_2 /scripts/start_test_producer.sh
```