from fastapi import FastAPI
from app.api.trees import router as tree_router
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "http://localhost:4321"
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)
app.include_router(tree_router)

@app.get("/")
def root():
    return {"status": "ok"}