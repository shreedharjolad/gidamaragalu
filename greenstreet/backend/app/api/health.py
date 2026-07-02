from fastapi import APIRouter
from sqlalchemy import text
from fastapi import HTTPException

from app.database.connection import engine

router = APIRouter()


@router.get("/health/live")
def liveness():
    return {
        "status": "alive"
    }

@router.get("/health/ready")
def readiness():
    try:
        with engine.connect() as conn:
            conn.execute(text("SELECT 1"))

        return {
            "status": "ready"
        }

    except Exception:
        raise HTTPException(
            status_code=503,
            detail="Database unavailable"
        )