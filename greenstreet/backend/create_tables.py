from app.database.connection import Base
from app.database.connection import engine

import app.models.tree
import app.models.user

Base.metadata.create_all(bind=engine)

print("Tables created")