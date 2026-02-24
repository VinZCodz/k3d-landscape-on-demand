#!/bin/bash
set -e

echo "🎨 Deploying Headlamp Landscape (No-Auth Mode)"

helm repo add headlamp https://kubernetes-sigs.github.io/headlamp/
helm repo update

helm upgrade --install headlamp headlamp/headlamp \
  --namespace headlamp --create-namespace \
  --set service.type=NodePort \
  --set service.nodePort=30090 \
  --set config.noAuth=true

# Grant Permissions: Headlamp uses a ServiceAccount named 'headlamp' by default. Give it cluster-admin so it can edit nodes/pods without logging in.
kubectl create clusterrolebinding headlamp-admin-binding \
  --clusterrole=cluster-admin \
  --serviceaccount=headlamp:headlamp \
  --namespace headlamp || true

echo "------------------------------------------------------------"
echo "✅ SUCCESS: Headlamp is running."
echo "🚀 Open the 'Ports' tab and click the link for 9090 for cluster dashboard."
echo "------------------------------------------------------------"
