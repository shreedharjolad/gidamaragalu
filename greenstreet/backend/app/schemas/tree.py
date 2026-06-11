from pydantic import BaseModel

class TreeRequest(BaseModel):
    species: str