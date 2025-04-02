#!/bin/bash

# Configuration des variables 
DOCKER_IMAGE_REDIS_NODE="redis-node-app"
DOCKER_IMAGE_REDIS_REACT="redis-react-app"
K8S_PATH="/k8s"

# Démarrer Minikube avec Docker comme driver
minikube start --driver=docker

# Configurer les variables d'environnement pour Docker
eval $(minikube docker-env)

# Construire les images Docker (Backend et Frontend)

# Backend Node.js



git clone https://github.com/arthurescriou/redis-node backend
mv ./backend_dockerfile ./backend/Dockerfile
cd backend
docker build -t $DOCKER_IMAGE_REDIS_NODE .
cd ..

# Frontend React



git clone https://github.com/arthurescriou/redis-react frontend
mv ./frontend_dockerfile ./frontend/Dockerfile
cd frontend
docker build -t $DOCKER_IMAGE_REDIS_REACT .
cd ..
cd k8s
kubectl apply -f redis
#kubectl apply -f $K8S_PATH/redis/redis-replica.yaml
#kubectl apply -f $K8S_PATH/redis/redis-pvc.yaml
# Appliquer le déploiement du backend Node.js
#kubectl apply -f $K8S_PATH/nodejs/nodejs-deployment.yaml
kubectl apply -f nodejs
# Appliquer le déploiement du frontend React
kubectl apply -f react

# Appliquer le déploiement et la configuration de Prometheus

# Déployer Prometheus ConfigMap et Service
kubectl apply -f monitoring
#kubectl apply -f $K8S_PATH/monitoring/prometheus-deployment.yaml
#kubectl apply -f $K8S_PATH/monitoring/prometheus-pvc.yaml
# Déployer Grafana
#kubectl apply -f $K8S_PATH/monitoring/grafana-deployment.yaml
#kubectl apply -f $K8S_PATH/monitoring/grafana-dashboard-config.yaml
#kubectl apply -f $K8S_PATH/monitoring/grafana-dashboard-provider.yaml
#kubectl apply -f $K8S_PATH/monitoring/grafana-pvc.yaml

# Afficher les URL des services déployés
NODEJS_URL=$(minikube service nodejs-service --url)
REACT_URL=$(minikube service react-service --url)
GRAFANA_URL=$(minikube service grafana-service --url)
PROMETHEUS_URL=$(minikube service prometheus-service --url)

echo "Node.js Service URL: $NODEJS_URL"
echo "React Service URL: $REACT_URL"
echo "Grafana Service URL: $GRAFANA_URL"
echo "Prometheus Service URL: $PROMETHEUS_URL"

echo "Deployment completed successfully!"


kubectl get pods
kubectl get services
