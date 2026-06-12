# Database Design

## PostgreSQL

Database Name

```text
greenstreet
```

---

# Trees

```sql
CREATE TABLE trees (
    id SERIAL PRIMARY KEY,
    species VARCHAR(255),
    status VARCHAR(100),
    guardian VARCHAR(255),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    created_at TIMESTAMP DEFAULT NOW()
);
```

---

# Tree Photos

```sql
CREATE TABLE tree_photos (
    id SERIAL PRIMARY KEY,
    tree_id INTEGER REFERENCES trees(id),
    photo_url TEXT,
    uploaded_at TIMESTAMP DEFAULT NOW()
);
```

---

# Users

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    joined_at TIMESTAMP DEFAULT NOW()
);
```

---

# Tree Adoptions

```sql
CREATE TABLE tree_adoptions (
    id SERIAL PRIMARY KEY,
    tree_id INTEGER REFERENCES trees(id),
    user_id INTEGER REFERENCES users(id),
    adopted_at TIMESTAMP DEFAULT NOW()
);
```

---

# Relationships

```text
Users
  |
  +---- TreeAdoptions ----+
                           |
                           v
                         Trees
                           |
                           v
                      TreePhotos
```