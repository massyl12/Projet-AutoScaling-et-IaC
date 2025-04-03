#!/bin/bash

# Configuration des variables 
DOCKER_IMAGE_REDIS_NODE="redis-node-app"
DOCKER_IMAGE_REDIS_REACT="redis-react-app"
K8S_PATH="./k8s"

# Démarrer Minikube avec Docker comme driver
echo "[INFO] Démarrage de Minikube..."
minikube start --driver=docker

# Activer metrics-server si pas déjà activé
echo "[INFO] Vérification de metrics-server..."
if ! kubectl get deployment metrics-server -n kube-system >/dev/null 2>&1; then
  echo "[INFO] Activation de metrics-server..."
  minikube addons enable metrics-server
else
  echo "[INFO] metrics-server déjà actif"
fi

# Configurer les variables d'environnement pour Docker
eval $(minikube docker-env)

# --- Construction des images Docker ---

echo "[INFO] Clonage et build du backend Node.js..."
git clone https://github.com/arthurescriou/redis-node backend
mv ./backend_dockerfile ./backend/Dockerfile
cd backend
docker build -t $DOCKER_IMAGE_REDIS_NODE .
cd ..

echo "[INFO] Clonage et build du frontend React..."
git clone https://github.com/arthurescriou/redis-react frontend
mv ./frontend_dockerfile ./frontend/Dockerfile
cd frontend
docker build -t $DOCKER_IMAGE_REDIS_REACT .
cd ..

# --- Déploiement Kubernetes ---

echo "[INFO] Déploiement des volumes persistants..."
kubectl apply -f $K8S_PATH/redis/redis-pvc.yaml
kubectl apply -f $K8S_PATH/monitoring/prometheus-pvc.yaml
kubectl apply -f $K8S_PATH/monitoring/grafana-pvc.yaml

echo "[INFO] Déploiement des ConfigMaps..."
kubectl apply -f $K8S_PATH/monitoring/prometheus-configmap.yaml
kubectl apply -f $K8S_PATH/monitoring/grafana-dashboard-config.yaml
kubectl apply -f $K8S_PATH/monitoring/grafana-dashboard-provider.yaml

echo "[INFO] Déploiement des services Redis..."
kubectl apply -f $K8S_PATH/redis/redis-master.yaml
kubectl apply -f $K8S_PATH/redis/redis-replica.yaml

echo "[INFO] Déploiement du backend Node.js..."
kubectl apply -f $K8S_PATH/nodejs

echo "[INFO] Déploiement du frontend React..."
kubectl apply -f $K8S_PATH/react

echo "[INFO] Déploiement de Prometheus et Grafana..."
kubectl apply -f $K8S_PATH/monitoring/prometheus-deployment.yaml
kubectl apply -f $K8S_PATH/monitoring/grafana-deployment.yaml

# --- Déploiement de l'autoscaler (HPA) ---



# --- Attente que tout soit prêt ---

echo "[INFO] Attente que les pods soient prêts (max 90s)..."
kubectl wait --for=condition=Ready pod --all --timeout=90s

# --- Affichage des URL des services ---

echo "[INFO] Récupération des URLs des services..."
NODEJS_URL=$(minikube service nodejs-service --url)
REACT_URL=$(minikube service react-service --url)
GRAFANA_URL=$(minikube service grafana-service --url)
PROMETHEUS_URL=$(minikube service prometheus-service --url)
kubectl get pods
kubectl get services
kubectl get hda
echo "[INFO] Récapitulatif des services déployés :"
echo "Node.js Service URL: $NODEJS_URL"
echo "React Service URL: $REACT_URL"
echo "Grafana Service URL: $GRAFANA_URL"
echo "Prometheus Service URL: $PROMETHEUS_URL"

echo "✅ Déploiement terminé avec succès !"
echo "ℹ️  Vous pouvez accéder aux services ci-dessus via votre navigateur."
echo "ℹ️  Pour tester en local : kubectl port-forward service/nodejs-service 5400:3000"
