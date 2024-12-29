# create EKS Cluster
eksctl create cluster --name my-cluster --region us-east-1 --nodegroup-name my-nodes --node-type m5.large --nodes 2 --nodes-min 2 --nodes-max 3

# delete EKS Cluster
eksctl delete cluster --name my-cluster --region us-east-1
