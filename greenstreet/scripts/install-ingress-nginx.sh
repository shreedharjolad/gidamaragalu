#!/usr/bin/env bash

source "$(dirname "$0")/lib.sh"

require_command kubectl
ensure_cluster_exists

info "Installing ingress-nginx"

kubectl apply \
    --server-side \
    -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

info "Waiting for controller..."

kubectl wait \
    --namespace ingress-nginx \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/component=controller \
    --timeout=300s

success "Ingress Controller installed."
