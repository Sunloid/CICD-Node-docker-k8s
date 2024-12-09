# CI/CD Pipeline with Kubernetes for Node.js Application 

## Project Overview
This repository demonstrates a CI/CD pipeline for a Node.js application utilizing Jenkins, Docker and Kubernetes. The pipeline automates the build, test and containerization and deployment processes, ensuring seamless integration and deployment. 

## Project structure 
```
ci-cd-nodejs-kubernetes/
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