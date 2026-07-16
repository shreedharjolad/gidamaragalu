#!/usr/bin/env bash

source "$(dirname "$0")/lib.sh"

info "Installing Local Kubernetes Toolchain"

# ----------------------------------------
# Docker
# ----------------------------------------

if command -v docker >/dev/null 2>&1
then
    success "Docker already installed."
else

    info "Installing Docker"

    sudo apt-get update -y

    sudo apt-get install -y docker.io

    sudo usermod -aG docker "$USER"

    warn "You may need to logout/login for docker group changes."

    success "Docker installed."

fi

# ----------------------------------------
# Kind
# ----------------------------------------

if command -v kind >/dev/null 2>&1
then
    success "Kind already installed."
else

    info "Installing Kind"

    ARCH=$(uname -m)

    case "$ARCH" in

        x86_64)

            curl -Lo kind \
            https://kind.sigs.k8s.io/dl/v0.29.0/kind-linux-amd64
            ;;

        aarch64|arm64)

            curl -Lo kind \
            https://kind.sigs.k8s.io/dl/v0.29.0/kind-linux-arm64
            ;;

        *)

            die "Unsupported architecture: $ARCH"

    esac

    chmod +x kind

    sudo mv kind /usr/local/bin/

    success "Kind installed."

fi

# ----------------------------------------
# kubectl
# ----------------------------------------

if command -v kubectl >/dev/null 2>&1
then
    success "kubectl already installed."
else

    info "Installing kubectl"

    VERSION=$(curl -Ls https://dl.k8s.io/release/stable.txt)

    ARCH=$(uname -m)

    case "$ARCH" in

        x86_64)

            curl -Lo kubectl \
            "https://dl.k8s.io/release/${VERSION}/bin/linux/amd64/kubectl"
            ;;

        aarch64|arm64)

            curl -Lo kubectl \
            "https://dl.k8s.io/release/${VERSION}/bin/linux/arm64/kubectl"
            ;;

        *)

            die "Unsupported architecture: $ARCH"

    esac

    chmod +x kubectl

    sudo mv kubectl /usr/local/bin/

    success "kubectl installed."

fi

# ----------------------------------------
# Helm
# ----------------------------------------

if command -v helm >/dev/null 2>&1
then
    success "Helm already installed."
else

    info "Installing Helm"

    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

    success "Helm installed."

fi

# ---------------------------------------
# Git
# ---------------------------------------

if ! command -v git >/dev/null 2>&1
then
    sudo apt-get install -y git
fi

# ----------------------------------------
# Versions
# ----------------------------------------

info "Installed Versions"

docker --version

kind --version

kubectl version --client

helm version

git version

success "Toolchain installation completed."
