#!/usr/bin/env bash

source "$(dirname "$0")/lib.sh"

info "Bootstrapping local Kubernetes platform"

./create-kind.sh
./install-ingress.sh
./install-metrics-server.sh
./install-argocd.sh
./deploy-greenstreet.sh

success "Bootstrap complete"
