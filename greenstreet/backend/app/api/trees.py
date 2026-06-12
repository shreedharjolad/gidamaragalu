from fastapi import APIRouter
from fastapi import HTTPException

from app.database.connection import SessionLocal
from app.models.tree import Tree
from app.schemas.tree import TreeRequest
from fastapi import UploadFile
from fastapi import File

from app.services.minio_service import client
from app.services.minio_service import BUCKET_NAME

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
                "longitude": tree.longitude
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