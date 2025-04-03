#!/bin/bash

# Variables
DOCKER_IMAGE_REDIS_NODE="redis-node-app"
DOCKER_IMAGE_REDIS_REACT="redis-react-app"
K8S_PATH="./k8s"

echo "[INFO] Suppression des ressources Kubernetes..."

# Supprimer les ressources Kubernetes si elles existent
kubectl delete -f $K8S_PATH/react --ignore-not-found
kubectl delete -f $K8S_PATH/nodejs --ignore-not-found
kubectl delete -f $K8S_PATH/redis --ignore-not-found
kubectl delete -f $K8S_PATH/monitoring --ignore-not-found

echo "[INFO] Suppression des dossiers clonés..."
rm -rf backend frontend

echo "[INFO] Suppression des images Docker locales..."
docker rmi $DOCKER_IMAGE_REDIS_NODE --force 2>/dev/null
docker rmi $DOCKER_IMAGE_REDIS_REACT --force 2>/dev/null

echo "[INFO] Arrêt de Minikube..."
minikube stop

echo "[INFO] Réinitialisation des variables d'environnement Docker..."
eval $(minikube docker-env -u)

echo "[INFO] Arrêt terminé proprement ✅"
