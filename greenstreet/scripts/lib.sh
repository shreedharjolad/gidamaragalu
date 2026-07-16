#!/usr/bin/env bash

set -Eeuo pipefail

CLUSTER_NAME="${CLUSTER_NAME:-tws-kind-cluster}"

info() {
    echo
    echo "=================================================="
    echo " $1"
    echo "=================================================="
}

success() {
    echo
    echo "✔ $1"
}

warn() {
    echo
    echo "⚠ $1"
}

die() {
    echo
    echo "✖ $1"
    exit 1
}

require_command() {

    command -v "$1" >/dev/null 2>&1 ||
        die "$1 is not installed."
}

ensure_cluster_exists() {

    if ! kind get clusters | grep -qx "$CLUSTER_NAME"
    then
        die "Kind cluster '$CLUSTER_NAME' not found."
    fi
}

ensure_namespace() {

    kubectl create namespace "$1" \
        --dry-run=client \
        -o yaml |
        kubectl apply -f -
}

wait_for_deployment() {

    kubectl rollout status \
        deployment/"$2" \
        -n "$1" \
        --timeout=300s
}

load_image() {

    local image="$1"

    kind load docker-image "$image" \
        --name "$CLUSTER_NAME"
}

build_image() {

    local image="$1"
    local path="$2"

    info "Building $image"

    docker build -t "$image" "$path"

    load_image "$image"
}

cluster_exists() {

    kind get clusters | grep -qx "$CLUSTER_NAME"
}

project_root() {

    git rev-parse --show-toplevel
}

ENVIRONMENT="${1:-kind}"
