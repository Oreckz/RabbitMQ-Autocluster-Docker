# RabbitMQ-Autocluster-Docker
Dockerfiles and requirements for creating autocluster images

## Quickstart

* Build Docker image 
    
    `docker build -t rabbitmq:autocluster .`
* Create required network overlay
    
    `docker network create testnet -d overlay`
* Start Consul service to act as Autocluster backend

    ```
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
     ```
     
* Allow 30 - 60 seconds for Consul to start

* Start RabbitMQ service

    ```
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
    ```

* Allow another 30-60 seconds for RabbitMQ to start

* Scale Rabbit service to desired size

    `docker service scale rabbit=N`
    
Source: http://www.kuznero.com/posts/docker/rabbitmq-dynamic-cluster.html