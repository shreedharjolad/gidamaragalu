import os
from datetime import timedelta
from minio import Minio


MINIO_ENDPOINT = os.getenv("MINIO_ENDPOINT", "minio:9000")

MINIO_ACCESS_KEY = os.getenv("MINIO_ACCESS_KEY", "admin")

MINIO_SECRET_KEY = os.getenv("MINIO_SECRET_KEY", "some_pass")

MINIO_SECURE = (os.getenv("MINIO_SECURE", "false").lower() == "true")

BUCKET_NAME = os.getenv("MINIO_BUCKET_NAME", "tree-photos")

# Endpoint that should appear inside presigned URLs.
# If not provided, use the normal MinIO endpoint.
# This keeps local/Kubernetes deployments working.
MINIO_PRESIGNED_ENDPOINT = os.getenv("MINIO_PRESIGNED_ENDPOINT", MINIO_ENDPOINT)


client = Minio(
    MINIO_ENDPOINT,
    access_key=MINIO_ACCESS_KEY,
    secret_key=MINIO_SECRET_KEY,
    secure=MINIO_SECURE )

# Separate client used ONLY for generating browser-facing
# presigned URLs.
presigned_client = Minio(
    MINIO_PRESIGNED_ENDPOINT,
    access_key=MINIO_ACCESS_KEY,
    secret_key=MINIO_SECRET_KEY,
    secure=MINIO_SECURE
)


try:

    if not client.bucket_exists(BUCKET_NAME):
        client.make_bucket(BUCKET_NAME)

except Exception as e:

    print(
        f"Failed to create bucket {BUCKET_NAME}: {e}"
    )


def get_presigned_url(
    object_name: str, expires_minutes: int = 2) -> str:

    return presigned_client.presigned_get_object(
        bucket_name=BUCKET_NAME,
        object_name=object_name,
        expires=timedelta(minutes=expires_minutes)
    )