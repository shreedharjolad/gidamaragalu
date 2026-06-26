import os
from minio import Minio

client = Minio(
    os.getenv("MINIO_ENDPOINT", "minio:9000"),
    access_key=os.getenv("MINIO_ACCESS_KEY", "admin"),
    secret_key=os.getenv("MINIO_SECRET_KEY", "password123"),
    secure=os.getenv("MINIO_SECURE", "false").lower() == "true"
)

BUCKET_NAME = os.getenv("MINIO_BUCKET_NAME", "tree-photos")

MINIO_PUBLIC_URL = os.getenv(
    "MINIO_PUBLIC_URL",
    "http://localhost:9000"
)

try:
    if not client.bucket_exists(BUCKET_NAME):
        client.make_bucket(BUCKET_NAME)
except Exception as e:
    print(f"Failed to create bucket {BUCKET_NAME}: {e}")
