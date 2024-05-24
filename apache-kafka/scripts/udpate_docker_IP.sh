#!/bin/bash

# Exit script on any error
set -e

# Function to get the IP address of a container
get_container_ip() {
    local container_name=$1
    docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$container_name"
}

# Get IP addresses of the Kafka containers
kafka1_ip=$(get_container_ip kafka1)
kafka2_ip=$(get_container_ip kafka2)
kafka3_ip=$(get_container_ip kafka3)
kafka4_ip=$(get_container_ip kafka4)

# Backup the current /etc/hosts file
sudo cp /etc/hosts /etc/hosts.bak

# Update /etc/hosts file
echo "Updating /etc/hosts file..."
{
    echo "$kafka1_ip kafka1"
    echo "$kafka2_ip kafka2"
    echo "$kafka3_ip kafka3"
    echo "$kafka4_ip kafka4"
} | sudo tee -a /etc/hosts

echo "Updated /etc/hosts with Kafka container IP addresses."
