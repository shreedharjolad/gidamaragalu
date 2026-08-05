#!/usr/bin/env bash

set -euo pipefail

source "$(dirname "$0")/lib.sh"

usage() {
    echo "Usage:"
    echo "  ./port-forward.sh argocd"
    echo "  ./port-forward.sh backend"
    echo "  ./port-forward.sh frontend"
    echo "  ./port-forward.sh postgres"
    echo "  ./port-forward.sh minio"
    exit 1
}

[[ $# -eq 1 ]] || usage

case "$1" in

argocd)
    info "Port forwarding ArgoCD → https://localhost:8081"
    kubectl port-forward \
        svc/argocd-server \
        -n argocd \
        8081:443
    ;;

backend)
    info "Port forwarding Backend → http://localhost:8000"
    kubectl port-forward \
        svc/backend \
        -n greenstreet \
        8000:8000
    ;;

frontend)
    info "Port forwarding Frontend → http://localhost:4321"
    kubectl port-forward \
        svc/frontend \
        -n greenstreet \
        4321:4321
    ;;

postgres)
    info "Port forwarding PostgreSQL → localhost:5432"
    kubectl port-forward \
        svc/postgres \
        -n greenstreet \
        5432:5432
    ;;

minio)
    info "Port forwarding MinIO"

    echo "Console : http://localhost:9001"
    echo "S3 API  : http://localhost:9000"

    kubectl port-forward \
        svc/minio \
        -n greenstreet \
        9000:9000 \
        9001:9001
    ;;

*)
    usage
    ;;
esac