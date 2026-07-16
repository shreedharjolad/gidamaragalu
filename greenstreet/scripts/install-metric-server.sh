#!/usr/bin/env bash

source "$(dirname "$0")/lib.sh"

require_command kubectl
ensure_cluster_exists

info "Installing Metrics Server"

kubectl apply \
    -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

info "Patching Metrics Server for Kind"

kubectl patch deployment metrics-server \
    -n kube-system \
    --type=json \
    -p='[
    {
      "op":"add",
      "path":"/spec/template/spec/containers/0/args/-",
      "value":"--kubelet-insecure-tls"
    }
    ]'

kubectl rollout restart deployment metrics-server -n kube-system

wait_for_deployment kube-system metrics-server

success "Metrics Server installed."
