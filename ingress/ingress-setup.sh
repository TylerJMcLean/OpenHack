# Create separate namespace
kubectl create namespace ingress-basic


# Add the official stable repository
helm repo add stable https://kubernetes-charts.storage.googleapis.com/

# Use Helm to deploy an NGINX ingress controller
helm install nginx-ingress stable/nginx-ingress \
    --namespace ingress-basic \
    --set controller.replicaCount=2 \
    --set controller.nodeSelector."beta\.kubernetes\.io/os"=linux \
    --set defaultBackend.nodeSelector."beta\.kubernetes\.io/os"=linux



##
# $ kubectl get service -l app=nginx-ingress --namespace ingress-basic
# 
# NAME              TYPE           CLUSTER-IP     EXTERNAL-IP   PORT(S)                      AGE
# nginx-ingress-controller   LoadBalancer   10.0.61.144    EXTERNAL_IP   80:30386/TCP,443:32276/TCP   6m2s
# nginx-ingress-default-backend  ClusterIP      10.0.192.145   <none>        80/TCP                       6m2s
# 


## DEMO APPLICATION
helm repo add azure-samples https://azure-samples.github.io/helm-charts/

helm install aks-helloworld azure-samples/aks-helloworld --namespace ingress-basic

helm install aks-helloworld-two azure-samples/aks-helloworld \
    --namespace ingress-basic \
    --set title="AKS Ingress Demo" \
    --set serviceName="aks-helloworld-two"

kubectl apply -f hello-world-ingress.yaml

export EXTERNAL_IP=$(kubectl get service -l app=nginx-ingress --namespace ingress-basic |awk '{print $4}' | head -2 | tail -1)

echo Visit $EXTERNAL_IP in your browser to see the demo app...

read input

## Delete the sample namespace and all resources
helm delete aks-helloworld aks-helloworld-two nginx-ingress --namespace ingress-basic


helm repo remove azure-samples

kubectl delete -f hello-world-ingress.yaml

kubectl delete namespace ingress-basic

