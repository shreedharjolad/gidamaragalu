from fastapi import FastAPI
from app.api.trees import router as tree_router
from fastapi.middleware.cors import CORSMiddleware
from app.api.auth import router as auth_router
from app.database.connection import Base, engine
from app.models.tree import Tree
from app.models.user import User

app = FastAPI()


Base.metadata.create_all(bind=engine)

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:4321",
        "http://greenstreet.local:8080"
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)
app.include_router(tree_router)

@app.get("/")
def root():
    return {"status": "ok"}

app.include_router(auth_router)