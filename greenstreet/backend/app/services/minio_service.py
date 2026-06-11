import os
from minio import Minio

client = Minio(
    os.getenv("MINIO_ENDPOINT", "localhost:9000"),
    access_key=os.getenv("MINIO_ACCESS_KEY", "admin"),
    secret_key=os.getenv("MINIO_SECRET_KEY", "password123"),
    secure=os.getenv("MINIO_SECURE", "false").lower() == "true"
)

BUCKET_NAME = os.getenv("MINIO_BUCKET_NAME", "tree-photos")