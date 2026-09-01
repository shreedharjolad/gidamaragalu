#!/bin/bash

set -euo pipefail

echo "======================================"
echo " GreenStreet Cloud Deployment"
echo "======================================"

REPO_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
COMPOSE_FILE="$REPO_ROOT/greenstreet/infra/compose/docker-compose-for-cloud.yml"
CLOUD_ENV="/etc/greenstreet/cloud.env"

echo
echo "Repository : $REPO_ROOT"
echo "Compose    : $COMPOSE_FILE"
echo "Env file   : $CLOUD_ENV"

# --------------------------------------------------
# Check cloud.env
# --------------------------------------------------

if [ ! -f "$CLOUD_ENV" ]; then
    echo "ERROR: $CLOUD_ENV does not exist."
    exit 1
fi

# We only source this file to obtain GREENSTREET_SECRET_OCID
# for the OCI Vault lookup.
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

# --------------------------------------------------
# Validate JSON
# --------------------------------------------------

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
# MinIO application settings
# --------------------------------------------------

export MINIO_ACCESS_KEY="$MINIO_ROOT_USER"
export MINIO_SECRET_KEY="$MINIO_ROOT_PASSWORD"

export MINIO_ENDPOINT="${MINIO_ENDPOINT:-minio:9000}"
export MINIO_PUBLIC_ENDPOINT="${MINIO_PUBLIC_ENDPOINT:-}"
export MINIO_SECURE="${MINIO_SECURE:-false}"
export MINIO_BUCKET_NAME="${MINIO_BUCKET_NAME:-greenstreet}"

# --------------------------------------------------
# Database URL
# --------------------------------------------------

export DATABASE_URL="postgresql://${POSTGRES_USER}:${POSTGRES_PASSWORD}@postgres:5432/${POSTGRES_DB}"

# --------------------------------------------------
# Validate required values
# --------------------------------------------------

for variable in \
    POSTGRES_DB \
    POSTGRES_USER \
    POSTGRES_PASSWORD \
    MINIO_ROOT_USER \
    MINIO_ROOT_PASSWORD \
    JWT_SECRET \
    MINIO_ENDPOINT \
    MINIO_PUBLIC_ENDPOINT \
    MINIO_BUCKET_NAME
do
    if [ -z "${!variable:-}" ] || [ "${!variable}" = "null" ]; then
        echo "ERROR: $variable is missing."
        exit 1
    fi
done

echo "Required application values loaded."

# --------------------------------------------------
# Check Compose file
# --------------------------------------------------

if [ ! -f "$COMPOSE_FILE" ]; then
    echo "ERROR: Compose file not found:"
    echo "$COMPOSE_FILE"
    exit 1
fi

# --------------------------------------------------
# Common Docker Compose command
# --------------------------------------------------

compose() {
    docker compose \
        --env-file "$CLOUD_ENV" \
        -f "$COMPOSE_FILE" \
        "$@"
}

# --------------------------------------------------
# Commands
# --------------------------------------------------

COMMAND="${1:-deploy}"
SERVICE="${2:-}"

case "$COMMAND" in

    deploy)

        echo
        echo "Building GreenStreet images..."

        compose build

        echo
        echo "Starting GreenStreet..."

        compose up -d

        echo
        echo "GreenStreet containers:"

        compose ps

        ;;

    build)

        echo
        echo "Building all GreenStreet images..."

        compose build

        ;;

    build-no-cache)

        echo
        echo "Building all GreenStreet images without cache..."

        compose build --no-cache

        ;;

    up)

        echo
        echo "Starting GreenStreet..."

        compose up -d

        compose ps

        ;;

    rebuild)

        if [ -z "$SERVICE" ]; then
            echo "ERROR: Please specify a service."
            echo
            echo "Example:"
            echo "  ./start-cloud.sh rebuild backend"
            exit 1
        fi

        echo
        echo "Rebuilding $SERVICE..."

        compose build "$SERVICE"

        echo
        echo "Restarting $SERVICE..."

        compose up -d --force-recreate "$SERVICE"

        compose ps

        ;;

    restart)

        if [ -z "$SERVICE" ]; then
            echo "ERROR: Please specify a service."
            echo
            echo "Example:"
            echo "  ./start-cloud.sh restart backend"
            exit 1
        fi

        echo
        echo "Restarting $SERVICE..."

        compose restart "$SERVICE"

        compose ps

        ;;

    start)

        if [ -z "$SERVICE" ]; then
            echo "ERROR: Please specify a service."
            exit 1
        fi

        echo
        echo "Starting $SERVICE..."

        compose start "$SERVICE"

        ;;

    stop)

        if [ -z "$SERVICE" ]; then
            echo "ERROR: Please specify a service."
            exit 1
        fi

        echo
        echo "Stopping $SERVICE..."

        compose stop "$SERVICE"

        ;;

    logs)

        if [ -z "$SERVICE" ]; then
            echo "ERROR: Please specify a service."
            echo
            echo "Example:"
            echo "  ./start-cloud.sh logs backend"
            exit 1
        fi

        compose logs -f --tail=100 "$SERVICE"

        ;;

    status)

        echo
        echo "GreenStreet containers:"

        compose ps

        ;;

    config)

        echo
        echo "Checking Docker Compose configuration..."

        compose config

        ;;

    down)

        echo
        echo "Stopping GreenStreet..."

        compose down

        ;;

    *)
        echo
        echo "Unknown command: $COMMAND"
        echo
        echo "Usage:"
        echo "  ./start-cloud.sh"
        echo "  ./start-cloud.sh deploy"
        echo "  ./start-cloud.sh build"
        echo "  ./start-cloud.sh build-no-cache"
        echo "  ./start-cloud.sh up"
        echo "  ./start-cloud.sh rebuild <service>"
        echo "  ./start-cloud.sh restart <service>"
        echo "  ./start-cloud.sh start <service>"
        echo "  ./start-cloud.sh stop <service>"
        echo "  ./start-cloud.sh logs <service>"
        echo "  ./start-cloud.sh status"
        echo "  ./start-cloud.sh config"
        echo "  ./start-cloud.sh down"
        exit 1
        ;;

esac

echo
echo "======================================"
echo " Operation completed"
echo "======================================"