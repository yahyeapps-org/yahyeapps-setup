
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install redis bitnami/redis \
  --namespace $namespace --create-namespace \
  --set image.tag=sha256-8beb49786cd278b0e0e2494aff147e3a1a84d354fca94b4a27b049f7d951069d \
  --set auth.enabled=false \
  --set master.resources.requests.cpu="100m" \
  --set master.resources.requests.memory="80Mi" \
  --set master.resources.limits.cpu="100m" \
  --set master.resources.limits.memory="80Mi" \
  --set replica.resources.requests.cpu="100m" \
  --set replica.resources.requests.memory="80Mi" \
  --set replica.resources.limits.cpu="100m" \
  --set replica.resources.limits.memory="80Mi"