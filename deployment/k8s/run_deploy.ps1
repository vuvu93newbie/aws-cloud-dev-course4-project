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

# Troubleshoot
# Use this command to see the STATUS of your pods:
kubectl get pods
kubectl describe pod [pod-name]
## An example:
## kubectl logs backend-user-5667798847-knvqz
## Error from server (BadRequest): container "backend-user" in pod "backend-user-5667798847-knvqz" is waiting to start: trying and failing to pull image
#In case of ImagePullBackOff or ErrImagePull or CrashLoopBackOff, review your deployment.yaml file(s) if they have the correct image path and environment variable names.

#Check if the backend pods are experiencing CrashLoopBackOff due to an insufficient memory error. If yes, then you can increase the memory limits as shown in this example(opens in a new tab).
kubectl get pods
kubectl logs [pod-name] -p
## Once you increase the memory, check the updated deployment as:
kubectl get pod [pod-name] --output=yaml
## You can autoscale, if required, as
kubectl autoscale deployment backend-user --cpu-percent=70 --min=3 --max=5
#Look at what's there inside the running container. Open a Shell to a running container(opens in a new tab) as:
kubectl get pods
## Assuming "backend-feed-68d5c9fdd6-dkg8c" is a pod
kubectl exec --stdin --tty backend-feed-68d5c9fdd6-dkg8c -- /bin/bash
## See what values are set for environment variables in the container
printenv | grep POST
## Or, you can try "curl <cluster-IP-of-backend>:8080/api/v0/feed " to check if services are running.
## This is helpful to see is backend is working by opening a bash into the frontend container
# When you are sure that all pods are running successfully, then use developer tools in the browser to see the precise reason for the error.
# If your frontend is loading properly, and showing Error: Uncaught (in promise): HttpErrorResponse: {"headers":{"normalizedNames":{},"lazyUpdate":null,"headers":{}},"status":0,"statusText":"Unknown Error"...., it is possibly because the udagram-frontend/src/environments/environment.ts file has incorrectly defined the ‘apiHost’ to whom forward the requests.
# If your frontend is not not loading, and showing Error: Uncaught (in promise): HttpErrorResponse: {"headers":{"normalizedNames":{},"lazyUpdate":null,"headers":{}},"status":0,"statusText":"Unknown Error", .... , it is possibly because URL variable is not set correctly.
# In the case of Failed to load resource: net::ERR_CONNECTION_REFUSED error as well, it is possibly because the URL variable is not set correctly.

## Run these commands from the /udagram-deployment directory
## Rolling update the containers of "frontend" deployment
kubectl set image deployment frontend frontend=[Dockerhub-username]/udagram-frontend:v6

# force update image
kubectl set image deployment/udagram-frontend udagram-frontend=vuvunewbie/udagram-frontend:latest --record

kubectl rollout restart deployment udagram-api-feed

