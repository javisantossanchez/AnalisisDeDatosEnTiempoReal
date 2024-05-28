

#!/bin/bash

# Apply Zookeeper manifests
microk8s kubectl apply -f zookeeper-deployment.yaml
microk8s kubectl apply -f zookeeper-service.yaml

# Wait for Zookeeper to be running
echo "Waiting for Zookeeper to be running..."
microk8s kubectl wait --for=condition=available --timeout=600s deployment/zookeeper

# Apply Kafka broker manifests
microk8s kubectl apply -f kafka1-deployment.yaml
microk8s kubectl apply -f kafka1-service.yaml

microk8s kubectl apply -f kafka2-deployment.yaml
microk8s kubectl apply -f kafka2-service.yaml

microk8s kubectl apply -f kafka3-deployment.yaml
microk8s kubectl apply -f kafka3-service.yaml

microk8s kubectl apply -f kafka4-deployment.yaml
microk8s kubectl apply -f kafka4-service.yaml

# Wait for Kafka brokers to be running
echo "Waiting for Kafka brokers to be running..."
microk8s kubectl wait --for=condition=available --timeout=600s deployment/kafka1
microk8s kubectl wait --for=condition=available --timeout=600s deployment/kafka2
microk8s kubectl wait --for=condition=available --timeout=600s deployment/kafka3
microk8s kubectl wait --for=condition=available --timeout=600s deployment/kafka4

# Apply Kafka UI manifests
microk8s kubectl apply -f kafka-ui-deployment.yaml
microk8s kubectl apply -f kafka-ui-service.yaml

# Wait for Kafka UI to be running
echo "Waiting for Kafka UI to be running..."
microk8s kubectl wait --for=condition=available --timeout=600s deployment/kafka-ui

echo "All components are up and running!"

