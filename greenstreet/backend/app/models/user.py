from sqlalchemy import Column
from sqlalchemy import Integer
from sqlalchemy import String

from app.database.connection import Base

class User(Base):

    __tablename__ = "users"

    id = Column(Integer, primary_key=True)

    username = Column(String, unique=True)

    password_hash = Column(String)

    role = Column(String, default="user")