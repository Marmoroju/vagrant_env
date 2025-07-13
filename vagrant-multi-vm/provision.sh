#!/bin/bash

sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y clean


#INSTALAÇÃO DO DOCKER
echo '##############################'
echo '#### INSTALAÇÃO DO DOCKER ####'   
echo '##############################'

curl -fsSL https://get.docker.com | bash

sudo usermod -aG docker vagrant

newgrp docker

sudo systemctl start docker

sudo systemctl enable docker