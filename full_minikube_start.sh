

# Deploy hello-minikube

kubectl apply -f hello-minikube.yaml
kubectl apply -f hello-minikube-service.yaml

# Deploy datadog
kubectl apply -f datadog-agent-all-features.yml

# Deploy cluster agent

kubectl apply -f datadog-cluster-agent_service.yaml 

#Update with your API
kubectl apply -f dca-secret.yaml
kubectl apply -f cluster-agent.yaml 

kubectl apply -f rbac-agent.yaml

# Create customer metric server

kubectl apply -f custom-metric-server.yaml 
kubectl apply -f rbac-hpa.yaml 


# Create HPA for nginx
kubectl apply -f hpa_hello_world.yaml

# Deploy kube state metric https://github.com/kubernetes/kube-state-metrics/tree/master/examples/standard
kubectl apply -f kube_state_metric/

# Deploy Kube Metric Server https://github.com/kubernetes-sigs/metrics-server
kubectl apply -f metrics-server/deploy/kubernetes/



# Get URL
echo "To access app: \n"
minikube service hello-minikube --url