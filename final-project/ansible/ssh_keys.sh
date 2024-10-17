#!/bin/bash
#sudo yum install sshpass
ssh-keygen -q -t rsa -N "" -f "/home/andrey/.ssh/id_rsa"

ssh-keyscan -t rsa loadbalancer2 >> /home/andrey/.ssh/known_hosts
ssh-keyscan -t rsa loadbalancer1 >> /home/andrey/.ssh/known_hosts
ssh-keyscan -t rsa web2 >> /home/andrey/.ssh/known_hosts
ssh-keyscan -t rsa web2 >> /home/andrey/.ssh/known_hosts
ssh-keyscan -t rsa pg1 >> /home/andrey/.ssh/known_hosts
ssh-keyscan -t rsa pg2 >> /home/andrey/.ssh/known_hosts
ssh-keyscan -t rsa pg3 >> /home/andrey/.ssh/known_hosts
ssh-keyscan -t rsa storage >> /home/andrey/.ssh/known_hosts
sshpass -p "123321ab" ssh-copy-id -f -i /home/andrey/.ssh/id_rsa.pub loadbalancer1
sshpass -p "123321ab" ssh-copy-id -f -i /home/andrey/.ssh/id_rsa.pub loadbalancer2
sshpass -p "123321ab" ssh-copy-id -f -i /home/andrey/.ssh/id_rsa.pub web1
sshpass -p "123321ab" ssh-copy-id -f -i /home/andrey/.ssh/id_rsa.pub web2
sshpass -p "123321ab" ssh-copy-id -f -i /home/andrey/.ssh/id_rsa.pub web3
sshpass -p "123321ab" ssh-copy-id -f -i /home/andrey/.ssh/id_rsa.pub pg1
sshpass -p "123321ab" ssh-copy-id -f -i /home/andrey/.ssh/id_rsa.pub pg2
sshpass -p "123321ab" ssh-copy-id -f -i /home/andrey/.ssh/id_rsa.pub pg3
sshpass -p "123321ab" ssh-copy-id -f -i /home/andrey/.ssh/id_rsa.pub storage

