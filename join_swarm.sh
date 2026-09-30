#!/usr/bin/env bash
set -e


while [ ! -f /vagrant/worker_join_command ]; do
    sleep 2
done 

echo "Arquivo encontrado! Executando o comando do Docker Swarm..."
$(cat /vagrant/worker_join_command)
