#!/bin/bash

set -euo pipefail

echo "======================================"
echo " GreenStreet Cloud Deployment"
echo "======================================"

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
COMPOSE_FILE="$REPO_ROOT/greenstreet/infra/compose/docker-compose-for-cloud.yml"
CLOUD_ENV="/etc/greenstreet/cloud.env"

echo
echo "Repository: $REPO_ROOT"
echo "Compose file: $COMPOSE_FILE"

# --------------------------------------------------
# Load OCI configuration
# --------------------------------------------------

if [ ! -f "$CLOUD_ENV" ]; then
    echo "ERROR: $CLOUD_ENV does not exist."
    exit 1
fi

source "$CLOUD_ENV"

if [ -z "${GREENSTREET_SECRET_OCID:-}" ]; then
    echo "ERROR: GREENSTREET_SECRET_OCID is not set."
    exit 1
fi

# --------------------------------------------------
# Check required commands
# --------------------------------------------------

command -v docker >/dev/null 2>&1 || {
    echo "ERROR: Docker is not installed."
    exit 1
}

command -v oci >/dev/null 2>&1 || {
    echo "ERROR: OCI CLI is not installed."
    exit 1
}

command -v jq >/dev/null 2>&1 || {
    echo "ERROR: jq is not installed."
    exit 1
}

echo
echo "Docker:"
docker --version

echo
echo "OCI CLI:"
oci --version

# --------------------------------------------------
# Get secret from OCI Vault
# --------------------------------------------------

echo
echo "Reading GreenStreet secret from OCI Vault..."

SECRET_JSON=$(
    oci secrets secret-bundle get \
        --secret-id "$GREENSTREET_SECRET_OCID" \
        --query 'data."secret-bundle-content".content' \
        --raw-output |
    base64 --decode
)

# Validate JSON
echo "$SECRET_JSON" | jq empty

echo "Secret retrieved successfully."

# --------------------------------------------------
# Export application variables
# --------------------------------------------------

export POSTGRES_DB="$(echo "$SECRET_JSON" | jq -r '.POSTGRES_DB')"
export POSTGRES_USER="$(echo "$SECRET_JSON" | jq -r '.POSTGRES_USER')"
export POSTGRES_PASSWORD="$(echo "$SECRET_JSON" | jq -r '.POSTGRES_PASSWORD')"

export MINIO_ROOT_USER="$(echo "$SECRET_JSON" | jq -r '.MINIO_ROOT_USER')"
export MINIO_ROOT_PASSWORD="$(echo "$SECRET_JSON" | jq -r '.MINIO_ROOT_PASSWORD')"

export JWT_SECRET="$(echo "$SECRET_JSON" | jq -r '.JWT_SECRET')"

# --------------------------------------------------
# Validate required values
# --------------------------------------------------

for variable in \
    POSTGRES_DB \
    POSTGRES_USER \
    POSTGRES_PASSWORD \
    MINIO_ROOT_USER \
    MINIO_ROOT_PASSWORD \
    JWT_SECRET
do
    if [ -z "${!variable}" ] || [ "${!variable}" = "null" ]; then
        echo "ERROR: $variable is missing from OCI secret."
        exit 1
    fi
done

echo "Required application secrets loaded."

# --------------------------------------------------
# Check Compose file
# --------------------------------------------------

if [ ! -f "$COMPOSE_FILE" ]; then
    echo "ERROR: Compose file not found:"
    echo "$COMPOSE_FILE"
    exit 1
fi

# --------------------------------------------------
# Build images
# --------------------------------------------------

echo
echo "Building GreenStreet images..."

docker compose \
    -f "$COMPOSE_FILE" \
    build

# --------------------------------------------------
# Start GreenStreet
# --------------------------------------------------

echo
echo "Starting GreenStreet..."

docker compose \
    -f "$COMPOSE_FILE" \
    up -d

# --------------------------------------------------
# Show status
# --------------------------------------------------

echo
echo "GreenStreet containers:"
docker compose \
    -f "$COMPOSE_FILE" \
    ps

echo
echo "======================================"
echo " GreenStreet deployment completed"
echo "======================================"