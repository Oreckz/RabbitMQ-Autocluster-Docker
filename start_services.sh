#!/usr/bin/env bash
# Because who's got time for cutting and pasting amirite?

docker network ls | grep testnet

if [ $? -eq 0 ]
then
    echo "Found Docker network"
else
    echo "Please create the testnet network before continuing"
fi

docker service create \
    --name consul \
    --network testnet \
    -p 8500:8500 \
    -e 'CONSUL_BIND_INTERFACE=eth0' \
    -e 'CONSUL_LOCAL_CONFIG={"skip_leave_on_interrupt": true}' \
    consul agent \
    -server -ui -client=0.0.0.0 \
    -bootstrap-expect=1 \
    -retry-join=consul

echo "Waiting for Consul to initialise"
sleep 30

echo "Starting RabbitMQ service"
docker service create \
    --name rabbit \
    --network testnet \
    -p 5672:5672 \
    -p 15672:15672 \
    -e "AUTOCLUSTER_TYPE=consul" \
    -e "CONSUL_HOST=consul" \
    -e "CONSUL_PORT=8500" \
    -e "CONSUL_SVC=rabbitmq" \
    -e "CONSUL_SVC_ADDR_AUTO=true" \
    -e "AUTOCLUSTER_CLEANUP=true" \
    -e "CLEANUP_WARN_ONLY=false" \
    -e "RABBITMQ_ERLANG_COOKIE=secrect" \
    rabbitmq:autocluster

