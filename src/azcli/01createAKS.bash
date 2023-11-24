#!/bin/bash

# remove Windows bash problems
export MSYS_NO_PATHCONV=1

# Environmental Variables
UNIQUEID=$(openssl rand -hex 3)
APPNAME=petclinic
RESOURCE_GROUP=rg-$APPNAME-$UNIQUEID
LOCATION=WestEurope

# Deploy RG
az group create -g $RESOURCE_GROUP -l $LOCATION

# Deploy ACR
MYACR=acr$APPNAME$UNIQUEID
az acr create \
    -n $MYACR \
    -g $RESOURCE_GROUP \
    --sku Basic
# Wait for ACR to be provisioned


# Deploy VNET
VIRTUAL_NETWORK_NAME=vnet-$APPNAME-$UNIQUEID
az network vnet create \
    --resource-group $RESOURCE_GROUP \
    --name $VIRTUAL_NETWORK_NAME \
    --location $LOCATION \
    --address-prefix 10.1.0.0/16
   
AKS_SUBNET_CIDR=10.1.0.0/24
az network vnet subnet create \
    --resource-group $RESOURCE_GROUP \
    --vnet-name $VIRTUAL_NETWORK_NAME \
    --address-prefixes $AKS_SUBNET_CIDR \
    --name aks-subnet 

# Wait for VNET to be provisioned


# Deploy AKS
SUBNET_ID=$(az network vnet subnet show --resource-group $RESOURCE_GROUP --vnet-name $VIRTUAL_NETWORK_NAME --name aks-subnet --query id -o tsv)

AKSCLUSTER=aks-$APPNAME-$UNIQUEID
az aks create \
    -n $AKSCLUSTER \
    -g $RESOURCE_GROUP \
    --location $LOCATION \
    --generate-ssh-keys \
    --attach-acr $MYACR \
    --vnet-subnet-id $SUBNET_ID
