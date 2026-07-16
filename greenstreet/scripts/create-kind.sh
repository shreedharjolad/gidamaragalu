#!/usr/bin/env bash

source "$(dirname "$0")/lib.sh"

require_command kind
require_command kubectl

CONFIG_FILE="$(dirname "$0")/../configs/kind-config.yaml"

info "Creating Kind Cluster"

# Cluster already exists?

if cluster_exists
then
    warn "Cluster already exists."
    exit 0
fi

# Validate config file
[ -f "$CONFIG_FILE" ] || die "Kind config not found: $CONFIG_FILE"

kind create cluster \
    --name "$CLUSTER_NAME" \
    --config "$CONFIG_FILE"

info "Verifying Cluster"

kubectl cluster-info

kubectl get nodes

success "Kind cluster '$CLUSTER_NAME' created successfully."
