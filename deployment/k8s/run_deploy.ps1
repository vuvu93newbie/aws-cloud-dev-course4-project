## Apply env variables and secrets
kubectl apply -f aws-secret.yaml
kubectl apply -f env-secret.yaml
kubectl apply -f env-configmap.yaml

## Deployments - Double check the Dockerhub image name and version in the deployment files
kubectl apply -f feed-deployment.yaml
kubectl apply -f user-deployment.yaml
kubectl apply -f reverseproxy-deployment.yaml
kubectl apply -f frontend-deployment.yaml

## Service
kubectl apply -f feed-service.yaml
kubectl apply -f user-service.yaml
kubectl apply -f reverseproxy-service.yaml
kubectl apply -f frontend-service.yaml


## Check the deployment names and their pod status
kubectl get deployments
## Create a Service object that exposes the frontend deployment
## The command below will ceates an external load balancer and assigns a fixed, external IP to the Service.
kubectl expose deployment udagram-frontend --type=LoadBalancer --name=publicfrontend
kubectl expose deployment udagram-reverseproxy --type=LoadBalancer --name=publicreverseproxy
## Repeat the process for the *reverseproxy* deployment. 
## Check name, ClusterIP, and External IP of all deployments
kubectl get services 
kubectl get pods # It should show the STATUS as Running

## publicfrontend: ae4d5a4ff0dc64d67b8810592b360427-853270820.us-east-1.elb.amazonaws.com
## publicreverseproxy: a63fdac5d0c3e4b979b029b176c85aa6-668803658.us-east-1.elb.amazonaws.com