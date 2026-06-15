from datetime import datetime
from datetime import timedelta

from jose import jwt
from jose import JWTError

import os

SECRET_KEY = os.getenv(
    "JWT_SECRET_KEY",
    "dev-secret"
)

ALGORITHM = "HS256"

def create_access_token(data):

    payload = data.copy()

    payload["exp"] = (
        datetime.utcnow()
        + timedelta(hours=24)
    )

    return jwt.encode(
        payload,
        SECRET_KEY,
        algorithm=ALGORITHM
    )

def decode_token(token):

    try:
        return jwt.decode(
            token,
            SECRET_KEY,
            algorithms=[ALGORITHM]
        )

    except JWTError:
        return None