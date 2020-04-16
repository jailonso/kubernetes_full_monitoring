# Start minikube

minikube start


# Deploy kube state metric https://github.com/kubernetes/kube-state-metrics/tree/master/examples/standard
kubectl apply -f kube_state_metric/

# Deploy Kube Metric Server https://github.com/kubernetes-sigs/metrics-server
kubectl apply -f metrics-server/deploy/kubernetes/

# Deploy Datadog

kubectl apply -f "https://raw.githubusercontent.com/DataDog/datadog-agent/master/Dockerfiles/manifests/cluster-agent/rbac/rbac-agent.yaml"
kubectl apply -f "https://raw.githubusercontent.com/DataDog/datadog-agent/master/Dockerfiles/manifests/cluster-agent/rbac/rbac-cluster-agent.yaml"
kubectl create -f dca-secret.yaml
kubectl create secret generic datadog-secret --from-literal api-key="127b3bdc7ea5d8e92c2f14694378b0c9"
kubectl apply -f cluster-agent.yaml
kubectl apply -f datadog-cluster-agent_service.yaml
kubectl apply -f rbac-agent.yaml
kubectl apply -f datadog-agent-all-features.yml

kubectl create secret generic datadog-secret-app --from-literal app-key="35f35db9cf21ce17d9dfa4a044aa03c20160eb4b"

# Monitoring control plan.
# Kube APIserver scheduler are autodiscovered
# For  etcd we need to annotate the pod

kubectl annotate pods etcd-m01 ad.datadoghq.com/etcd.check_names='["etcd"]' -n kube-system
kubectl annotate pods etcd-m01 ad.datadoghq.com/etcd.init_configs='[{}]' -n kube-system
kubectl annotate pods etcd-m01 ad.datadoghq.com/etcd.instances='[{"prometheus_url": "http://%%host%%:2379/metrics"}]' -n kube-system
kubectl port-forward etcd-m01 2381:2381 -n kube-system

#etcd not working because it can't access the port


# Deploy hello-minikube

kubectl apply -f hello-minikube.yaml
kubectl apply -f hello-minikube-service.yaml


# Create customer metric server

kubectl apply -f custom-metric-server.yaml 
kubectl apply -f rbac-hpa.yaml 


# Create HPA for  kubernetes.cpu.usage.total 
kubectl apply -f hpa_hello_world.yaml


# Get URL
echo "To access app: \n"
minikube service hello-minikube --url

# Increase load

 while true; do curl -s  http://192.168.64.4:31813;sleep 1; done >/dev/null

# Mirar métricas

# https://app.datadoghq.com/metric/explorer?from_ts=1586267128816&to_ts=1586270728816&live=true&page=0&is_auto=false&tile_size=m&exp_metric=kubernetes.pods.running%2Ckubernetes.cpu.usage.total&exp_scope=kube_service%3Ahello-minikube&exp_agg=avg&exp_row_type=metric



