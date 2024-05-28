

#!/bin/bash

echo "Deleting Kafka and Zookeeper deployments, services, and other resources..."

# Namespaces (assuming they are in the default namespace)
NAMESPACE="default"

# Delete deployments
microk8s kubectl delete deployment -n $NAMESPACE kafka1 kafka2 kafka3 kafka4 kafka-ui zookeeper

# Delete services
microk8s kubectl delete service -n $NAMESPACE kafka1 kafka2 kafka3 kafka4 kafka-ui zookeeper

# Delete pods
microk8s kubectl delete pod -n $NAMESPACE -l app=kafka
microk8s kubectl delete pod -n $NAMESPACE -l app=zookeeper
microk8s kubectl delete pod -n $NAMESPACE -l app=kafka-ui

# Delete persistent volume claims (PVCs)
microk8s kubectl delete pvc -n $NAMESPACE -l app=kafka
microk8s kubectl delete pvc -n $NAMESPACE -l app=zookeeper
microk8s kubectl delete pvc -n $NAMESPACE -l app=kafka-ui

# Delete configmaps (if any)
microk8s kubectl delete configmap -n $NAMESPACE -l app=kafka
microk8s kubectl delete configmap -n $NAMESPACE -l app=zookeeper
microk8s kubectl delete configmap -n $NAMESPACE -l app=kafka-ui

# Optionally delete all remaining pods, services, and other resources
microk8s kubectl delete all --all -n $NAMESPACE

echo "Cleanup complete."

