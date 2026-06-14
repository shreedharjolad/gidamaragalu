from sqlalchemy import Column
from sqlalchemy import Integer
from sqlalchemy import String
from sqlalchemy import Float
from sqlalchemy import DateTime

from app.database.connection import Base

class Tree(Base):

    __tablename__ = "trees"

    id = Column(Integer, primary_key=True)

    species = Column(String)

    status = Column(String)

    guardian = Column(String, nullable=True)
    
    photo = Column(String, nullable=True)

    latitude = Column(Float)

    longitude = Column(Float)

    last_reported_at = Column(DateTime)