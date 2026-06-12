from fastapi import APIRouter
from fastapi import HTTPException

from app.database.connection import SessionLocal
from app.models.tree import Tree
from app.schemas.tree import TreeRequest
from fastapi import UploadFile
from fastapi import File

from app.services.minio_service import client
from app.services.minio_service import BUCKET_NAME
from pydantic import BaseModel
from datetime import datetime

router = APIRouter()


@router.get("/trees")
def get_trees():

    db = SessionLocal()

    try:
        trees = db.query(Tree).all()

        return [
            {
                "id": tree.id,
                "species": tree.species,
                "status": tree.status,
                "guardian": tree.guardian,
                "latitude": tree.latitude,
                "longitude": tree.longitude,
                "last_reported_at": tree.last_reported_at
            }
            for tree in trees
        ]

    finally:
        db.close()


@router.get("/trees/{tree_id}")
def get_tree(tree_id: int):

    db = SessionLocal()

    try:
        tree = (
            db.query(Tree)
            .filter(Tree.id == tree_id)
            .first()
        )

        if not tree:
            raise HTTPException(
                status_code=404,
                detail="Tree not found"
            )

        return {
            "id": tree.id,
            "species": tree.species,
            "status": tree.status,
            "guardian": tree.guardian
        }

    finally:
        db.close()


@router.post("/trees")
def create_tree(payload: TreeRequest):

    db = SessionLocal()

    try:
        tree = Tree(
            species=payload.species,
            status="Healthy",
            guardian=None,
            latitude=payload.latitude,
            longitude=payload.longitude
        )

        db.add(tree)

        db.commit()

        db.refresh(tree)

        return {
            "id": tree.id,
            "species": tree.species,
            "status": tree.status,
            "guardian": tree.guardian
        }

    finally:
        db.close()

@router.post("/trees/{tree_id}/photo")
def upload_tree_photo(
    tree_id: int,
    file: UploadFile = File(...)
):

    object_name = f"tree-{tree_id}.jpg"

    client.put_object(
        bucket_name=BUCKET_NAME,
        object_name=object_name,
        data=file.file,
        length=-1,
        part_size=10 * 1024 * 1024,
        content_type=file.content_type
    )

    return {
        "message": "Photo uploaded",
        "file": object_name
    }

class AdoptRequest(BaseModel):
    guardian: str

class HealthReportRequest(BaseModel):
    status: str
    
@router.post("/trees/{tree_id}/adopt")
def adopt_tree(
    tree_id: int,
    payload: AdoptRequest
):
    db = SessionLocal()

    try:

        tree = (
            db.query(Tree)
            .filter(Tree.id == tree_id)
            .first()
        )

        if not tree:
            return {
                "error": "Tree not found"
            }

        tree.guardian = payload.guardian

        db.commit()

        return {
            "message": "Tree adopted",
            "guardian": tree.guardian
        }

    finally:
        db.close()

@router.post("/trees/{tree_id}/report")
def report_tree_health(
    tree_id: int,
    payload: HealthReportRequest
):

    db = SessionLocal()

    try:

        tree = (
            db.query(Tree)
            .filter(Tree.id == tree_id)
            .first()
        )

        if not tree:

            return {
                "error": "Tree not found"
            }

        tree.status = payload.status

        tree.last_reported_at = (
            datetime.utcnow()
        )

        db.commit()

        return {
            "message":
            "Health updated"
        }

    finally:

        db.close()