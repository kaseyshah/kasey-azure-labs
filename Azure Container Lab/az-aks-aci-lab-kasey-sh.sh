# AKS In Action - Demo - AKS quickstart
# cluster aks08
# create resource group
az group create -n rsg-aks08 -l eastus
# create AKS cluster
az aks create -g rsg-aks08 -n aks08 --generate-ssh-keys --node-count 1
az aks list
# set the context to this cluster
az aks get-credentials -g rsg-aks08 -n aks08 --overwite-existing
# see cluster info for the current context
kubectl cluster-info
kubectl get nodes
# deploy app and service from the following yaml file on github
kubectl apply -f https://raw.githubusercontent.com/kaseyshah/aks-quickstart/master/azure-vote.yaml
kubectl get pods
kubectl get deployments
kubectl get rs
# wait for service to receive public IP
kubectl get service azure-vote-front --watch
# wait 5 minutes before the curl and http commands below
curl <public IP from above output>
http://<public IP from above output>
# send vote from multiple browser tabs
# scale to 3 replicas
kubectl scale --replicas=3 -f https://raw.githubusercontent.com/kaseyshah/aks-quickstart/master/azure-vote.yaml
kubectl get deployments
kubectl get pods
#apply autoscaling
kubectl autoscale deployment azure-vote-front --min=2 --max=10 
kubectl get pods
# scale azure-vote-front replicas to 4 and see autoscaling bringing it below 4
kubectl scale deployment azure-vote-front --replicas=4
kubectl get pods
# see autoscaler
kubectl get hpa
# delete hpa
kubectl delete hpa azure-vote-front
# apply new autoscaler with CPU percent 75
kubectl autoscale deployment azure-vote-front --min=2 --max=10 --cpu-percent=75
kubectl get pods
# scale aks cluster to 2 nodes
az aks scale -g rsg-aks08 -n aks08 --node-count 2
kubectl get nodes
# browse kubernetes dashboard url 
az aks browse -g rsg-aks08 -n aks08
#
# Azure ACI lab
az group create -n rsg-aci -l eastus
az container create \
    --resource-group rsg-aci \
    --name aci01 \
    --image microsoft/aci-helloworld \
    --ip-address public 
# list ACI containers
az container list -g rsg-aci
# curl to ip address listed
# $ curl -s http://20.42.38.47 | grep "<h1>"

