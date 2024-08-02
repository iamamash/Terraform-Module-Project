#!/bin/bash
sudo apt-get update -y
sudo apt-get install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible -y
sudo apt-get install ansible -y