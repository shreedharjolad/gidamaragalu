from sqlalchemy import Column
from sqlalchemy import Integer
from sqlalchemy import String

from app.database.connection import Base


class Tree(Base):

    __tablename__ = "trees"

    id = Column(
        Integer,
        primary_key=True,
        index=True
    )

    species = Column(String)

    status = Column(String)

    guardian = Column(
        String,
        nullable=True
    )