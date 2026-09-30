#!/usr/bin/env bash
set -e

docker swarm init --advertise-addr 192.168.56.10

docker swarm join-token worker | grep docker > /vagrant/worker_join_command
