Port Fowarding

Get pod id (kubectl get services), External Port/Internal port


    kubectl port-forward poi-844c5f8d59-b4nd4 1829:80


Get Service Principal

    az aks show --name $AKS_CLUSTER_NAME --resource-group $AKS_CLUSTER_RESOURCE_GROUP --query servicePrincipalProfile.clientId -o tsv
