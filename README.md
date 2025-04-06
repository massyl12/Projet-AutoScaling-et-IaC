# Projet AutoScaling et Infrastructure as Code (IaC)

## Objectif du Projet

Ce projet consiste à déployer une infrastructure Kubernetes composée de :

- Une application **Node.js** (backend)
- Une application **React** (frontend)
- Une base de données **Redis**
- Un système de monitoring avec **Prometheus** et **Grafana**
- Un mécanisme d'**auto-scaling horizontal**

## Structure du Projet

Le projet est organisé en plusieurs répertoires et fichiers :

- **backend/** : Contient le Dockerfile et les fichiers nécessaires à l'application backend (Node.js).
- **frontend/** : Contient le Dockerfile et les fichiers nécessaires à l'application frontend (React).
- **k8s/** : Contient les configurations Kubernetes pour déployer Redis, Node.js, React, Prometheus, et Grafana.
- **deploy.sh** : Script d'automatisation permettant de déployer l'infrastructure.
- **README.md** : Documentation du projet.

## Exécution du Script de deploiement de l'architecture

Le fichier `deploy.sh` permet d'automatiser le déploiement de l'ensemble de l'infrastructure. Pour l'exécuter, suivez les étapes ci-dessous :

1. **Préparez l'environnement** : 
   Assurez-vous que **Minikube** et **Docker** sont installés et fonctionnels sur votre machine.

2. **Rendez le script exécutable** : 
   Avant d'exécuter le script, vous devez le rendre exécutable. Pour ce faire, ouvrez un terminal dans le répertoire contenant `deploy.sh` et entrez la commande suivante :
   `chmod +x deploy.sh`

3. **Executez le script**:
    Vous pouvez dès à présent executer le script avec la commande:
    `./deploy.sh`

4. **Exposer le port localement**
    Une fois le script executé, il faut rediriger le port de Kubernetes vers la machine local. Il faut donc executer la commande suivante:
    kubectl port-forward service/nodejs-service 5400:3000

5. **Voir les résultats**
    Vous pouvez ensuite voir les résultats sur mettant les adresses indiquées sur le terminal apres l'éxécution du script dans un navigateur.

6. **Accès au Dashboard grafana**
    Dans Grafana, pour accéder au dashboard de monitoring de l'application Node.js, déroulez le menu situé en haut à gauche, cliquez sur "Dashboards", puis sélectionnez "Node.js App Monitoring"

## Execution du script d'arrêt
De même, nous avons céer un script d'arrêt de l'infrastructure appelé `stop.sh`. Ce dernier permet de stopper tout les deploiements mis en place via le fichier `deploy.sh`. Pour l'exécuter suivez les étapes ci-dessous:

1. **Rendez le script exécutable** : 
   Avant d'exécuter le script, vous devez le rendre exécutable. Pour ce faire, ouvrez un terminal dans le répertoire contenant `stop.sh` et entrez la commande suivante :
   `chmod +x stop.sh`

2. **Executez le script**:
    Vous pouvez dès à présent executer le script avec la commande:
    `./stop.sh`
