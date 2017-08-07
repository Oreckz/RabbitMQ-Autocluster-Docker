# RabbitMQ-Autocluster-Docker
Dockerfiles and requirements for creating autocluster images

## Build Docker Image
`docker build -t rabbitmq:autocluster .`

## Deploy to single instance
`docker-compose up -d`

## Deploy to Docker Swarm
`docker stack deploy -c docker-compose.yml $SERVICENAME`