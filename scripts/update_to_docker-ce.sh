#!/usr/bin/env bash

#Warn the user because we are nice
echo "Running this will remove the current Docker installation"
read -r -p "Are you sure? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    upgrade_docker()
else
    return 0
fi

function upgrade_docker {

    #Gracefully shut down and remove Docker
    docker stop $(docker ps -q)
    sudo systemctl stop docker
    sudo apt remove docker.io

    #Add official Docker apt repo
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt update

    #Install docker-ce from official repo
    sudo apt-get install -y docker-ce
}