import os
from datetime import timedelta
from minio import Minio


MINIO_ENDPOINT = os.getenv("MINIO_ENDPOINT", "minio:9000")
MINIO_ACCESS_KEY = os.getenv("MINIO_ACCESS_KEY", "admin")
MINIO_SECRET_KEY = os.getenv("MINIO_SECRET_KEY", "password123")
MINIO_SECURE = os.getenv("MINIO_SECURE", "false").lower() == "true"
MINIO_BUCKET_NAME = os.getenv("MINIO_BUCKET_NAME", "tree-photos")

MINIO_PRESIGNED_ENDPOINT = os.getenv("MINIO_PRESIGNED_ENDPOINT")

if not MINIO_PRESIGNED_ENDPOINT:
    raise RuntimeError("MINIO_PRESIGNED_ENDPOINT is not set")

client = Minio(
    MINIO_ENDPOINT,
    access_key=MINIO_ACCESS_KEY,
    secret_key=MINIO_SECRET_KEY,
    secure=MINIO_SECURE)


def get_presigned_url(
    object_name: str,
    expires_minutes: int = 2) -> str:

    url = client.presigned_get_object(
        bucket_name=MINIO_BUCKET_NAME,
        object_name=object_name,
        expires=timedelta(minutes=expires_minutes)
    )

    return url.replace(
        f"http://{MINIO_ENDPOINT}",
        f"http://{MINIO_PRESIGNED_ENDPOINT}"
    )