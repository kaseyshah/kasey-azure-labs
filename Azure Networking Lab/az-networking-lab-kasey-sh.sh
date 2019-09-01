# Kasey's Azure Networking Lab Scenario CLI commands solution
# create resource group
az group create -n rsg-aznetw -l westus2
#
# command to list regions is 
az account list-locations
#
# create vnet10
az network vnet create -g rsg-aznetw -n vnet10 --address-prefix 10.10.0.0/16 -l westus2
#creating two subnets in vnet10
az network vnet subnet create -n s10v10 -g rsg-aznetw --vnet-name vnet10 --address-prefix 10.10.10.0/24
az network vnet subnet create -n s20v10 -g rsg-aznetw --vnet-name vnet10 --address-prefix 10.10.20.0/24
#
# create vnet20
az network vnet create -g rsg-aznetw -n vnet20 --address-prefix 10.20.0.0/16 -l eastus
#creating two subnets in vnet20
az network vnet subnet create -n s10v20 -g rsg-aznetw --vnet-name vnet20 --address-prefix 10.20.10.0/24
az network vnet subnet create -n s20v20 -g rsg-aznetw --vnet-name vnet20 --address-prefix 10.20.20.0/24
#
# create vnet30
az network vnet create -g rsg-aznetw -n vnet30 --address-prefix 10.30.0.0/16 -l westeurope
#creating two subnets in vnet30
az network vnet subnet create -n s10v30 -g rsg-aznetw --vnet-name vnet30 --address-prefix 10.30.10.0/24
az network vnet subnet create -n s20v30 -g rsg-aznetw --vnet-name vnet30 --address-prefix 10.30.20.0/24
#
# create vnet40
az network vnet create -g rsg-aznetw -n vnet40 --address-prefix 10.40.0.0/16 -l southeastasia
#creating two subnets in vnet40
az network vnet subnet create -n s10v40 -g rsg-aznetw --vnet-name vnet40 --address-prefix 10.40.10.0/24
az network vnet subnet create -n s20v40 -g rsg-aznetw --vnet-name vnet40 --address-prefix 10.40.20.0/24
#
# create vm-s10v10
az vm create -n vm-s10v10 -g rsg-aznetw \
    --authentication-type password \
    --admin-username kasey \
    --admin-password Microsoft@123 \
    --image UbuntuLTS \
    --public-ip-address-allocation static \
    --vnet-name vnet10 \
    --subnet s10v10 \
    --location westus2 \
    --zone 1
#
# create vm-s20v10
az vm create -n vm-s20v10 -g rsg-aznetw \
    --authentication-type password \
    --admin-username kasey \
    --admin-password Microsoft@123 \
    --image UbuntuLTS \
    --public-ip-address-allocation static \
    --vnet-name vnet10 \
    --subnet s20v10 \
    --location westus2 \
    --zone 2
#
# create vm-s10v20
az vm create -n vm-s10v20 -g rsg-aznetw \
    --authentication-type password \
    --admin-username kasey \
    --admin-password Microsoft@123 \
    --image UbuntuLTS \
    --public-ip-address-allocation static \
    --vnet-name vnet20 \
    --subnet s10v20 \
    --location eastus \
    --public-ip-sku standard \
    --zone 1
#
# create vm-s20v20
az vm create -n vm-s20v20 -g rsg-aznetw \
    --authentication-type password \
    --admin-username kasey \
    --admin-password Microsoft@123 \
    --image UbuntuLTS \
    --public-ip-address-allocation static \
    --vnet-name vnet20 \
    --subnet s20v20 \
    --location eastus \
    --public-ip-sku standard \
    --zone 2
#
# create vm-s10v30
az vm create -n vm-s10v30 -g rsg-aznetw \
    --authentication-type password \
    --admin-username kasey \
    --admin-password Microsoft@123 \
    --image UbuntuLTS \
    --public-ip-address-allocation static \
    --vnet-name vnet30 \
    --subnet s10v30 \
    --location westeurope \
    --zone 1 \
    --no-wait
#
# create vm-s20v30
az vm create -n vm-s20v30 -g rsg-aznetw \
    --authentication-type password \
    --admin-username kasey \
    --admin-password Microsoft@123 \
    --image UbuntuLTS \
    --public-ip-address-allocation static \
    --vnet-name vnet30 \
    --subnet s20v30 \
    --location westeurope \
    --zone 2
#
# create vm-s10v40
az vm create -n vm-s10v40 -g rsg-aznetw \
    --authentication-type password \
    --admin-username kasey \
    --admin-password Microsoft@123 \
    --image UbuntuLTS \
    --public-ip-address-allocation static \
    --vnet-name vnet40 \
    --subnet s10v40 \
    --location southeastasia \
    --zone 1
#
# create vm-s20v40
az vm create -n vm-s20v40 -g rsg-aznetw \
    --authentication-type password \
    --admin-username kasey \
    --admin-password Microsoft@123 \
    --generate-ssh-keys \
    --image UbuntuLTS \
    --public-ip-address-allocation static \
    --vnet-name vnet40 \
    --subnet s20v40 \
    --location southeastasia \
    --zone 2
#
# create vm scaleset with load balancer
 az vmss create \
  --resource-group rsg-aznetw \
  --name vmss01 \
  --vnet-name vnet10 \
  --subnet s10v10 \
  --image UbuntuLTS \
  --upgrade-policy-mode automatic \
  --admin-username kasey \
  --admin-password Microsoft@123 \
  --generate-ssh-keys \
  --load-balancer lb-vmss01 \
  --zones 1 2 3
#
# vnet peering from vnet10 to vnet20
az network vnet peering create \
    --resource-group rsg-aznetw \
    --name vnet10-to-vnet20 \
    --vnet-name vnet10 \
    --remote-vnet vnet20 \
    --allow-vnet-access
# vnet peering from vnet20 to vnet10
az network vnet peering create \
    --resource-group rsg-aznetw \
    --name vnet20-to-vnet10 \
    --vnet-name vnet20 \
    --remote-vnet vnet10 \
    --allow-vnet-access
# peer vnet20 to vnet10, vnet30, and vnet40
# vnet peering from vnet10 to vnet20
az network vnet peering create \
    -g rsg-aznetw \
    -n vnet10-to-vnet20 \
    --vnet-name vnet10 \
    --remote-vnet vnet20 \
    --allow-vnet-access
# vnet peering from vnet20 to vnet30
az network vnet peering create \
    -g rsg-aznetw \
    -n vnet20-to-vnet30 \
    --vnet-name vnet20 \
    --remote-vnet vnet30 \
    --allow-vnet-access
# vnet peering from vnet30 to vnet20
az network vnet peering create \
    -g rsg-aznetw \
    -n vnet30-to-vnet20 \
    --vnet-name vnet30 \
    --remote-vnet vnet20 \
    --allow-vnet-access
#
# vnet peering from vnet20 to vnet40
az network vnet peering create \
    -g rsg-aznetw \
    -n vnet20-to-vnet40 \
    --vnet-name vnet20 \
    --remote-vnet vnet40 \
    --allow-vnet-access
# vnet peering from vnet40 to vnet20
az network vnet peering create \
    -g rsg-aznetw \
    -n vnet40-to-vnet20 \
    --vnet-name vnet40 \
    --remote-vnet vnet20 \
    --allow-vnet-access
#
# Deploy Cisco CSR 1000V solution from Azure marketplace
# portal, add service, search cisco 1000v, select Cisco CSR 1000v solution, create, follow prompts.
#
# Begin VPN from customer site to VPN gateway in vnet20
#
# create gateway subnet in vnet20
az network vnet subnet create \
    --address-prefix 10.20.255.0/27 \
    --name GatewaySubnet \
    --resource-group rsg-aznetw \
    --vnet-name vnet20
#
# create local gw representing on-prem router; replace public ip below with on-prem router ip.
# for simulation use Cisco 1000V solution and use outside interface public ip.
az network local-gateway create \
    --gateway-ip-address 23.99.221.164 \
    --name onprem-site1 \
    --resource-group rsg-aznetw \
    --local-address-prefixes 192.168.10.0/24 192.168.20.0/24
#
# request public ip for vpn gateway
az network public-ip create \
    --name vpngwip-vnet20 \
    --resource-group rsg-aznetw \
    --allocation-method dynamic \
    --location eastus
#
# create vpn gateway in vnet20
az network vnet-gateway create \
    --name vpngw-vnet20 \
    --public-ip-address vpngwip-vnet20 \
    --resource-group rsg-aznetw \
    --vnet vnet20 \
    --gateway-type Vpn \
    --vpn-type RouteBased \
    --sku VpnGw1 \
    --location eastus \
    --no-wait
# view vpn gw
az network vnet-gateway show -n vpngw-vnet20 -g rsg-aznetw
# view public ip status of vpn gw
az network public-ip show --name vpngwip-vnet20 -g rsg-aznetw
# create a vpn connection
az network vpn-connection create \
    --name onprem-site1-to-vpngw-vnet20 \
    --resource-group rsg-aznetw \
    --vnet-gateway1 vpngw-vnet20 \
    -l eastus \
    --shared-key abc123 \
    --local-gateway2 onprem-site1
# show vpn connection
az network vpn-connection show \
    --name onprem-site1-to-vpngw-vnet20 \
    --resource-group rsg-aznetw
#
# End VPN from customer site to VPN gateway in vnet20
#
