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
Making a CI/CD pipeline which uses Jenkins for CI and Kubernetes for CD the entire pipeline is on a single EC2 instance of type t2.xlarge. When a pull request is made for the code in the GitHub then the jenkins job is automatically triggered via the webhook.
The jenkins intiates the build and which then uses the dockerfile in this repository and create the image. The image is then tagged and pushed into the dockerhub. 
The same image is deployed into Kubernetes cluster which has to be manually setup first in the instance itself.
Here is the setup of the entire pipeline Step by step. 

## AWS 
Create an instance of the type t2.xlarge. That instance is being used because of its large amount of memory.  Allow all traffic for now and use Ubuntu 22.04 as the ami. 

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
kubeadm init 
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

// If the nodes are in the constant state of NotReady run this command 
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

// To display the kubeconfig file use this 
cat ~/.kube/config
```


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

- Go to manage Jenkins and now the go to the plugins page. Install all related plugins. 

- Now go to new project and make a pipeline project and copy paste the Jenkinsfile from this repository. 


## GitHub 
As I said before GitHub acts as the Version control system for this project. It contains the entire code needed and it also triggers the build as soon as the pull request is made this is how its done: 

- First install the necessary plugins in the Jenkins manage page. 

- Next go to GitHub repository > settings > add webhook and give it jenkins url and content type of application/json. 

- For trigger events select Pull requests and save the webhook 
![Alt text](<./resources/image (40).png>)

- Go to jenkins and click configure on the build and then select GitHub hook trigger for GITScm polling under Build Triggers 

- Then the use of properties in the jenkinsfile comes. I have already added this in the jenkins file 

- Now all the Pull requests to this repository will trigger the build in the jenkins. 
