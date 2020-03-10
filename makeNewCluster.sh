#!/bin/bash

set -x


az acr login --name registryqft0511

export aksname="tripAKSCluster-A"
export serverAppId=$(az ad app create \
  --display-name "${aksname}Server" \
  --identifier-uris "https://${aksname}Server" \
  --query appId -o tsv)

az ad app update --id $serverAppId --set groupMembershipClaims=All
az ad sp delete --id $serverAppId
az ad sp create --id $serverAppId

export serverApplicationSecret=$(az ad sp credential reset \
  --name $serverAppId \
  --credential-description "AKSPassword" \
  --query password -o tsv)

az ad app permission add \
  --id $serverAppId \
  --api 00000003-0000-0000-c000-000000000000 \
  --api-permissions e1fe6dd8-ba31-4d61-89e7-88639da4683d=Scope 06da0dbc-49e2-44d2-8312-53f166ab848a=Scope 7ab1d382-f21e-4acd-a863-ba3e13f7da61=Role

az ad app permission grant --id 5ffffb1a-90a3-4ac6-9c0b-06d9e1a944ca --api 00000003-0000-0000-c000-000000000000

az ad app permission admin-consent --id $serverAppId

export clientApplicationId=$(az ad app create \
     --display-name "${aksname}Client" \
     --native-app \
     --reply-urls "https://${aksname}Client" \
     --query appId -o tsv)

az ad sp create --id $clientApplicationId

oAuthPermissionId=$(az ad app show --id $serverAppId --query "oauth2Permissions[0].id" -o tsv)

az ad app permission add   --id $clientApplicationId --api $serverAppId --api-permissions ${oAuthPermissionId}=Scope
az ad app permission grant --id $clientApplicationId --api $serverAppId
az ad app permission grant --id $clientApplicationId --api $serverAppId

VNET_ID=$(az network vnet show --resource-group teamResources --name Vnet --query id -o tsv)
SUBNET_ID=$(az network vnet subnet show --resource-group teamResources --vnet-name Vnet --name vm-subnet --query id -o tsv)

az aks create --resource-group teamResources --name $aksname \
	--node-count 1 \
	--generate-ssh-keys \
	--kubernetes-version 1.15.7 \
	--location canadacentral \
	--aad-server-app-id $serverAppId \
	--aad-server-app-secret $serverApplicationSecret \
	--aad-client-app-id $clientApplicationId \
	--aad-tenant-id $(az account show --query tenantId -o tsv) \
	--network-plugin azure \
	--vnet-subnet-id $SUBNET_ID \
	--docker-bridge-address 172.17.0.1/16 \
	--dns-service-ip 10.2.100.10 \
	--service-cidr 10.2.100.0/24

