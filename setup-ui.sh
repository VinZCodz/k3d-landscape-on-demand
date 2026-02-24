#!/bin/bash
set -e

echo "🎡 Installing Official Kubernetes Dashboard (v3)..."

helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
helm repo update

helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard \
  --namespace kubernetes-dashboard --create-namespace \
  --set api.service.type=NodePort \
  --set api.service.nodePort=30090 \
  --set api.extraArgs="{--enable-skip-login,--disable-settings-authorizer}" \
  --set authMode=none
  
# Grant Permissions: dashboard-auth account to cluster-admin.
kubectl create clusterrolebinding dashboard-admin-sa \
  --clusterrole=cluster-admin \
  --serviceaccount=kubernetes-dashboard:kubernetes-dashboard-auth || true

echo "------------------------------------------------------------"
echo "✅ SUCCESS: Official Dashboard is deployed."
echo "🌐 Access: Port 9090 (via your Codespaces Ports tab)."
echo "🚀 Action: On the login screen, simply click the 'SKIP' button."
echo "------------------------------------------------------------"
