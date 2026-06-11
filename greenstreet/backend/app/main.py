from fastapi import FastAPI
from app.api.trees import router as tree_router

app = FastAPI()

app.include_router(tree_router)

@app.get("/")
def root():
    return {"status": "ok"}