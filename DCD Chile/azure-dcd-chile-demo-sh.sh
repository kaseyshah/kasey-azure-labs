# Kasey's Demo at DCD Chile Keynote presentation
# Building data center network on Microsoft Azure
# Reauirements below: 
# (1) Build 4 data centres across the world each with 60K hosts capacity
# (2) Deploy two subnets on each network
# (3) Deploy two virtual machines in each subnet of all Data Center networks
# (4) Configure routing across all Data Center networks for bi-directional access 
# 
# create a resource group
az group create -n rsg-dcd -l westus2
#
# command to list regions 
# az account list-locations
#
# create vnet10
az network vnet create -g rsg-dcd -n vnet10 --address-prefix 10.10.0.0/16 -l westus2
#creating two subnets in vnet10
az network vnet subnet create -n s10v10 -g rsg-dcd --vnet-name vnet10 --address-prefix 10.10.10.0/24
az network vnet subnet create -n s20v10 -g rsg-dcd --vnet-name vnet10 --address-prefix 10.10.20.0/24
#
# create vnet20
az network vnet create -g rsg-dcd -n vnet20 --address-prefix 10.20.0.0/16 -l eastus
#creating two subnets in vnet20
az network vnet subnet create -n s10v20 -g rsg-dcd --vnet-name vnet20 --address-prefix 10.20.10.0/24
az network vnet subnet create -n s20v20 -g rsg-dcd --vnet-name vnet20 --address-prefix 10.20.20.0/24
#
# create vnet30
az network vnet create -g rsg-dcd -n vnet30 --address-prefix 10.30.0.0/16 -l westeurope
#creating two subnets in vnet30
az network vnet subnet create -n s10v30 -g rsg-dcd --vnet-name vnet30 --address-prefix 10.30.10.0/24
az network vnet subnet create -n s20v30 -g rsg-dcd --vnet-name vnet30 --address-prefix 10.30.20.0/24
#
# create vnet40
az network vnet create -g rsg-dcd -n vnet40 --address-prefix 10.40.0.0/16 -l brazilsouth
#creating two subnets in vnet40
az network vnet subnet create -n s10v40 -g rsg-dcd --vnet-name vnet40 --address-prefix 10.40.10.0/24
az network vnet subnet create -n s20v40 -g rsg-dcd --vnet-name vnet40 --address-prefix 10.40.20.0/24
#
# create vm-s10v10
az vm create -n vm-s10v10 -g rsg-dcd \
    --admin-username kasey \
    --admin-password Microsoft@123 \
    --image UbuntuLTS \
    --public-ip-address-allocation static \
    --vnet-name vnet10 \
    --subnet s10v10 \
    --location westus2 \
    --nsg nsg-ssh-any-uswest2
#
# create vm-s20v10
az vm create -n vm-s20v10 -g rsg-dcd \
    --admin-username kasey \
    --admin-password Microsoft@123 \
    --image UbuntuLTS \
    --public-ip-address-allocation static \
    --vnet-name vnet10 \
    --subnet s20v10 \
    --location westus2 \
    --nsg nsg-ssh-any-uswest2
#
# create vm-s10v20
az vm create -n vm-s10v20 -g rsg-dcd \
    --admin-username kasey \
    --admin-password Microsoft@123 \
    --image UbuntuLTS \
    --public-ip-address-allocation static \
    --vnet-name vnet20 \
    --subnet s10v20 \
    --location eastus \
    --nsg nsg-ssh-any-useast
#
# create vm-s20v20
az vm create -n vm-s20v20 -g rsg-dcd \
    --admin-username kasey \
    --admin-password Microsoft@123 \
    --image UbuntuLTS \
    --public-ip-address-allocation static \
    --vnet-name vnet20 \
    --subnet s20v20 \
    --location eastus \
    --nsg nsg-ssh-any-useast 
#
# create vm-s10v30
az vm create -n vm-s10v30 -g rsg-dcd \
    --admin-username kasey \
    --admin-password Microsoft@123 \
    --image UbuntuLTS \
    --public-ip-address-allocation static \
    --vnet-name vnet30 \
    --subnet s10v30 \
    --location westeurope \
    --nsg nsg-ssh-any-westeurope 
#
# create vm-s20v30
az vm create -n vm-s20v30 -g rsg-dcd \
    --admin-username kasey \
    --admin-password Microsoft@123 \
    --image UbuntuLTS \
    --public-ip-address-allocation static \
    --vnet-name vnet30 \
    --subnet s20v30 \
    --location westeurope \
    --nsg nsg-ssh-any-westeurope 
#
# create vm-s10v40
az vm create -n vm-s10v40 -g rsg-dcd \
    --admin-username kasey \
    --admin-password Microsoft@123 \
    --image UbuntuLTS \
    --public-ip-address-allocation static \
    --vnet-name vnet40 \
    --subnet s10v40 \
    --location brazilsouth \
    --nsg nsg-ssh-any-brazilsouth
#
# create vm-s20v40
az vm create -n vm-s20v40 -g rsg-dcd \
    --authentication-type password \
    --admin-username kasey \
    --admin-password Microsoft@123 \
    --generate-ssh-keys \
    --image UbuntuLTS \
    --public-ip-address-allocation static \
    --vnet-name vnet40 \
    --subnet s20v40 \
    --location brazilsouth \
    --nsg nsg-ssh-any-brazilsouth
#
# routing across data centers
# vnet peering from vnet20 to vnet10
az network vnet peering create \
    --resource-group rsg-dcd \
    --name vnet20-to-vnet10 \
    --vnet-name vnet20 \
    --remote-vnet vnet10 \
    --allow-vnet-access
# peer vnet20 to vnet10, vnet30, and vnet40
# vnet peering from vnet10 to vnet20
az network vnet peering create \
    -g rsg-dcd \
    -n vnet10-to-vnet20 \
    --vnet-name vnet10 \
    --remote-vnet vnet20 \
    --allow-vnet-access
#
# vnet peering from vnet20 to vnet30
az network vnet peering create \
    -g rsg-dcd \
    -n vnet20-to-vnet30 \
    --vnet-name vnet20 \
    --remote-vnet vnet30 \
    --allow-vnet-access
# vnet peering from vnet30 to vnet20
az network vnet peering create \
    -g rsg-dcd \
    -n vnet30-to-vnet20 \
    --vnet-name vnet30 \
    --remote-vnet vnet20 \
    --allow-vnet-access
#
# vnet peering from vnet20 to vnet40
az network vnet peering create \
    -g rsg-dcd \
    -n vnet20-to-vnet40 \
    --vnet-name vnet20 \
    --remote-vnet vnet40 \
    --allow-vnet-access
# vnet peering from vnet40 to vnet20
az network vnet peering create \
    -g rsg-dcd \
    -n vnet40-to-vnet20 \
    --vnet-name vnet40 \
    --remote-vnet vnet20 \
    --allow-vnet-access
#
# list virtual machines with IP addresses 
az vm list -d -o table
# ssh to vm-s10v10 and vm-s10v40
# pint each other with private IP
#
# Delete all resources above
az group delete -n rsg-dcd --yes --no-wait
#
# finished