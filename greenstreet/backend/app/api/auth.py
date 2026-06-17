from fastapi import APIRouter, Depends

from app.models.user import User

from app.database.connection import SessionLocal

from app.auth.security import hash_password

from app.auth.dependencies import get_current_user

from fastapi import HTTPException

router = APIRouter()

@router.post("/register")
def register(payload: dict):

    db = SessionLocal()

    try:

        existing = (
            db.query(User)
            .filter(
                User.username ==
                payload["username"]
            )
            .first()
        )

        if existing:
            return {
                "error":
                "User already exists"
            }

        user = User(
            username=payload["username"],
            password_hash=hash_password(
                payload["password"]
            ),
            role="user"
        )

        db.add(user)

        db.commit()

        return {
            "message":
            "User created"
        }

    finally:

        db.close()

from app.auth.security import verify_password
from app.auth.jwt import create_access_token

@router.post("/login")
def login(payload: dict):

    db = SessionLocal()

    try:

        user = (
            db.query(User)
            .filter(
                User.username ==
                payload["username"]
            )
            .first()
        )

        if not user:
            raise HTTPException(
            status_code=401,
            detail="Invalid username or password")

        if not verify_password(
            payload["password"],
            user.password_hash
        ):
            raise HTTPException(
            status_code=401,
            detail="Invalid username or password")

        token = create_access_token({
            "user_id": user.id,
            "role": user.role
        })

        return {
            "access_token": token
        }

    finally:

        db.close()

@router.get("/me")
def me(
    current_user = Depends(
        get_current_user
    )
):

    return current_user