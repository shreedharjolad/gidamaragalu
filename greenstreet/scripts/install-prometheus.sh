#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

VALUES_FILE="$ROOT_DIR/helm/charts/monitoring/prometheus-values-kind.yaml"

echo "=========================================="
echo " Installing Prometheus"
echo "=========================================="

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts >/dev/null 2>&1 || true

helm repo update

helm upgrade --install prometheus \
    prometheus-community/prometheus \
    --namespace monitoring \
    --create-namespace \
    --values "$VALUES_FILE"

echo
echo "Waiting for Prometheus..."

kubectl rollout status \
deployment/prometheus-server \
-n monitoring \
--timeout=300s

echo
echo "Pods"

kubectl get pods -n monitoring

echo
echo "Services"

kubectl get svc -n monitoring

echo
echo "PVC"

kubectl get pvc -n monitoring

echo
echo "Prometheus installed successfully."