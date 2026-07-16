#!/usr/bin/env bash

source "$(dirname "$0")/lib.sh"

require_command kubectl

ensure_cluster_exists

ensure_namespace argocd

info "Installing Argo CD"

kubectl apply \
    --server-side \
    -n argocd \
    -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

wait_for_deployment argocd argocd-server

success "Argo CD installed."

echo
echo "=========================================="
echo "Login Instructions"
echo "=========================================="
echo

echo "Port Forward:"
echo

echo "kubectl port-forward svc/argocd-server -n argocd 8081:443"

echo
echo "Username:"
echo "admin"

echo
echo "Password:"
echo

echo "kubectl get secret argocd-initial-admin-secret \\"
echo "-n argocd \\"
echo "-o jsonpath='{.data.password}' | base64 -d"
