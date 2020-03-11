Port Fowarding

Get pod id (kubectl get services), External Port/Internal port


    kubectl port-forward poi-844c5f8d59-b4nd4 1829:80


Get Service Principal

    az aks show --name $AKS_CLUSTER_NAME --resource-group $AKS_CLUSTER_RESOURCE_GROUP --query servicePrincipalProfile.clientId -o tsv

Installing Ingress controller
    - Install Help Package Manager
        $ curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
        $ chmod 700 get_helm.sh
        $ ./get_helm.sh
    
    - Install Ingress controller
        # Create a namespace for your ingress resources
                kubectl create namespace <name of namespace>

    # Add the official stable repository
                helm repo add stable https://kubernetes-charts.storage.googleapis.com/

    # Use Helm to deploy an NGINX ingress controller
                helm install nginx-ingress stable/nginx-ingress \
                    --namespace <name of namespace> \
                    --set controller.replicaCount=2 \
                    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
                    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux
