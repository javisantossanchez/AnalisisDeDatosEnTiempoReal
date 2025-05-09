

#!/bin/bash

# Apply Zookeeper manifests
microk8s kubectl apply -f zookeeper-deployment.yaml

# Wait for Zookeeper to be running
echo "Waiting for Zookeeper to be running..."
microk8s kubectl wait --for=condition=available --timeout=600s deployment/zookeeper-deployment

# Apply Kafka broker manifests
microk8s kubectl apply -f broker-deployment.yaml

microk8s kubectl apply -f broker-2-deployment.yaml

microk8s kubectl apply -f broker-3-deployment.yaml

microk8s kubectl apply -f broker-4-deployment.yaml

# Wait for Kafka brokers to be running
echo "Waiting for Kafka brokers to be running..."
microk8s kubectl wait --for=condition=available --timeout=600s deployment/kafka-deployment
microk8s kubectl wait --for=condition=available --timeout=600s deployment/kafka-deployment-2	
microk8s kubectl wait --for=condition=available --timeout=600s deployment/kafka-deployment-3	
microk8s kubectl wait --for=condition=available --timeout=600s deployment/kafka-deployment-4	

# Apply Kafka UI manifests
microk8s kubectl apply -f kafka-ui-deployment.yaml

# Wait for Kafka UI to be running
echo "Waiting for Kafka UI to be running..."
microk8s kubectl wait --for=condition=available --timeout=600s deployment/kafka-ui-deployment

echo "All components are up and running!"

