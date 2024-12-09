# CI/CD Pipeline with Kubernetes for Node.js Application 

## Project Overview
This repository demonstrates a CI/CD pipeline for a Node.js application utilizing Jenkins, Docker and Kubernetes. The pipeline automates the build, test and containerization and deployment processes, ensuring seamless integration and deployment. 

## Project structure 
```
CICD-Node-docker-k8s/
├── Dockerfile                  # Dockerfile for Node.js application
├── Jenkinsfile                 # Jenkins pipeline script
├── Kubernetes/                 # Directory for Kubernetes manifests
│   ├── deployment.yaml         # Kubernetes deployment configuration
│   ├── service.yaml            # Kubernetes service configuration
├── README.md                   # Detailed documentation for the project
├── scripts/                    # Optional scripts for setup or maintenance
│   ├── jenkins-setup.sh        # Script to install jenkins in the instance 
│   ├── k8s-setup.sh            # Script to install kubernetes and setup kubernetes cluster in the instance 
```

## Explaining the Approach 


## Jenkins 
sh 
```
#!/bin/bash
sudo apt update -y
sudo apt upgrade -y
sudo apt install openjdk-17-jdk -y
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
  
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

sudo apt-get update -y
sudo apt-get install jenkins -y
```

## Kubernetes
```
sudo apt update -y 
sudo apt install docker.io -y 
sudo systemctl enable docker
sudo systemctl start docker
ufw disable 
swapoff -a 
sudo apt install -y apt-transport-https ca-certificates curl gnupg
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list
sudo apt update -y 
sudo apt install -y kubeadm kubectl kubelet
# If the nodes are in the constant state of NotReady run this command 
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml
```