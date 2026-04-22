
helm repo add bitnami https://charts.bitnami.com/bitnami
 


helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

helm upgrade --install nginx-ingress ingress-nginx/ingress-nginx \
  --namespace $namespace --create-namespace \
  --set controller.allowSnippetAnnotations=true \
  --set controller.admissionWebhooks.enabled=false \
  --set controller.image.pullPolicy=IfNotPresent
 
