from pydantic import BaseModel

class TreeRequest(BaseModel):
    species: str
    latitude: float
    longitude: float