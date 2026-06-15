from fastapi import Depends
from fastapi import HTTPException

from fastapi.security import HTTPBearer
from fastapi.security import HTTPAuthorizationCredentials

from app.auth.jwt import decode_token

security = HTTPBearer()

def get_current_user(
    credentials: HTTPAuthorizationCredentials = Depends(security)
):

    payload = decode_token(
        credentials.credentials
    )

    if not payload:
        raise HTTPException(
            status_code=401,
            detail="Invalid token"
        )

    return payload

def require_admin(
    current_user = Depends(get_current_user)
):

    if current_user["role"] != "admin":
        raise HTTPException(
            status_code=403,
            detail="Forbidden"
        )

    return current_user