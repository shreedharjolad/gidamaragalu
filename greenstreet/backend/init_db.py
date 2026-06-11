from app.database.connection import Base
from app.database.connection import engine

from app.models.tree import Tree

Base.metadata.create_all(bind=engine)

print("Tables created")