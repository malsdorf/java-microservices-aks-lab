UNIQUEID=32a6d0
APPNAME=petclinic
RESOURCE_GROUP=rg-petclinic-32a6d0
LOCATION=WestEurope
VIRTUAL_NETWORK_NAME=vnet-petclinic-32a6d0
MYACR=acrpetclinic32a6d0

# Deploy AKS
SUBNET_ID=$(az network vnet subnet show --resource-group $RESOURCE_GROUP --vnet-name $VIRTUAL_NETWORK_NAME --name aks-subnet --query id -o tsv)

echo $SUBNET_ID

AKSCLUSTER=aks-$APPNAME-$UNIQUEID
az aks create \
    -n $AKSCLUSTER \
    -g $RESOURCE_GROUP \
    --location $LOCATION \
    --generate-ssh-keys \
    --attach-acr $MYACR \
    --vnet-subnet-id /subscriptions/20878ed9-bf6d-4a5a-84c0-64914a442760/resourceGroups/rg-petclinic-32a6d0/providers/Microsoft.Network/virtualNetworks/vnet-petclinic-32a6d0/subnets/aks-subnet
