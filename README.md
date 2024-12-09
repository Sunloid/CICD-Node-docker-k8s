# CI/CD Pipeline with Kubernetes for Node.js Application 

## Project Overview
This repository demonstrates a CI/CD pipeline for a Node.js application utilizing Jenkins, Docker and Kubernetes. The pipeline automates the build, test and containerization and deployment processes, ensuring seamless integration and deployment. 

## Project structure 
```
CICD-Node-docker-k8s/
├── Dockerfile                  # Dockerfile for Node.js application
├── Jenkinsfile                 # Jenkins pipeline script
├── deployment.yaml             # Kubernetes deployment configuration
├── service.yaml                # Kubernetes service configuration
├── app.js                      # Contains the basic config for nodejs  
├── package.json                # Contains the dependencies required
├── README.md                   # Detailed documentation for the project
 
```

# Explaining the Approach 
Making a CI/CD pipeline which uses Jenkins for CI and Kubernetes for CD the entire pipeline is on a single EC2 instance of type t2.xlarge. The code is commited and pushed into the GitHub which is the Version control system of the pipeline and then the jenkins job is automatically triggered via the webhook.
The jenkins intiates the build and which then uses the dockerfile in this repository and create the image. The image is then tagged and pushed into the dockerhub. 
The same image is deployed into Kubernetes cluster which has to be manually setup first in the instance itself.  Here is the setup of the entire pipeline Step by step. This CI/CD 

## AWS 
Create an instance of the type t2.xlarge. That instance is being used because of its large amount of memory.  Allow all traffic for now and use Ubuntu 22.04 as the ami. 

## Jenkins
In the instance run this commands and install jenkins and then go to Jenkins on port 8080 and install the suggested plugins  
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

- In the jenkins go to manage jenkins and then tools. In the tools configure JDK and git with the names of OracleJDK8 and GIT specify their directory from the same instance 

- In the manage Jenkins page go the credentials and add the credentials for Docker, GitHub and Kubernetes. For Kubernetes use secret file and use the apiconfig from the kubernetes cluster. Do this step after the Kubernetes setup is done. 

- Now go to new project and make a pipeline project and copy paste the Jenkinsfile from this repository. 
## Kubernetes
In the instance terminal use these commands and install and setup the Kubernetes cluster. 

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