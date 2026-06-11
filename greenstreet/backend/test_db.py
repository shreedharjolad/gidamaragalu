from app.database.connection import engine

conn = engine.connect()

print("Connected successfully")

conn.close()