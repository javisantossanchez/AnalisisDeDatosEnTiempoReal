

#!/bin/bash

echo "Deleting Kafka and Zookeeper deployments, services, and other resources..."

# Namespaces (assuming they are in the default namespace)
NAMESPACE="default"

# Delete pods
microk8s kubectl delete pod -n $NAMESPACE

# Delete persistent volume claims (PVCs)
microk8s kubectl delete pvc -n $NAMESPACE 

# Delete configmaps (if any)
microk8s kubectl delete configmap -n default


# Optionally delete all remaining pods, services, and other resources
microk8s kubectl delete all --all -n $NAMESPACE

echo "Cleanup complete."

