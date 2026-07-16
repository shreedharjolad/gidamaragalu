#!/usr/bin/env bash

source "$(dirname "$0")/lib.sh"

require_command docker
require_command helm
require_command kind
require_command kubectl

ensure_cluster_exists

ENVIRONMENT="${1:-kind}"

info "Building Docker images"

build_image compose_backend:latest ./backend

build_image compose_frontend:latest ./frontend

info "Deploying GreenStreet"

helm upgrade \
    --install greenstreet \
    ./helm/charts/greenstreet \
    --namespace greenstreet \
    --create-namespace \
    -f "./helm/charts/greenstreet/values-${ENVIRONMENT}.yaml"

success "GreenStreet deployed."
