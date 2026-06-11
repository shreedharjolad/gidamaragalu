#!/bin/bash

set -e

PROJECT="greenstreet"

echo "Creating project structure..."

mkdir -p $PROJECT

cd $PROJECT

#########################################
# FRONTEND
#########################################

mkdir -p frontend/src/{components,layouts,pages/trees,services,styles}
mkdir -p frontend/public/{images,icons}

cat > frontend/package.json <<'EOF'
{
  "name": "greenstreet-frontend",
  "version": "0.1.0",
  "scripts": {
    "dev": "astro dev",
    "build": "astro build"
  }
}
EOF

cat > frontend/src/components/TreeCard.astro <<'EOF'
---
const {
  id,
  species,
  status,
  lastUpdate,
  guardian
} = Astro.props;
---

<div class="border rounded-lg p-4 shadow">
  <h2>🌳 Tree # {id}</h2>

  <p><strong>Species:</strong> {species}</p>

  <p>
    <strong>Status:</strong>
    {status}
  </p>

  <p>
    <strong>Last Update:</strong>
    {lastUpdate}
  </p>

  <p>
    <strong>Guardian:</strong>
    {guardian || "None"}
  </p>

  <button>
    I'll Check This Tree
  </button>
</div>
EOF

cat > frontend/src/pages/index.astro <<'EOF'
---
import TreeCard from "../components/TreeCard.astro";
---

<html>
  <body>
    <h1>GreenStreet</h1>

    <TreeCard
      id={1234}
      species="Neem"
      status="Needs Water"
      lastUpdate="15 days ago"
    />
  </body>
</html>
EOF

#########################################
# BACKEND
#########################################

mkdir -p backend/app/{api,models,schemas,database,services}

cat > backend/requirements.txt <<'EOF'
fastapi
uvicorn
sqlalchemy
psycopg2-binary
EOF

cat > backend/app/main.py <<'EOF'
from fastapi import FastAPI

app = FastAPI(title="GreenStreet API")

@app.get("/")
def root():
    return {"message": "GreenStreet API"}
EOF

cat > backend/app/api/trees.py <<'EOF'
from fastapi import APIRouter

router = APIRouter()

@router.get("/trees")
def get_trees():
    return [
        {
            "id": 1234,
            "species": "Neem",
            "status": "Needs Water"
        }
    ]
EOF

#########################################
# DATABASE
#########################################

mkdir -p database/{migrations,seed}

cat > database/schema.sql <<'EOF'
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(255) UNIQUE
);

CREATE TABLE trees (
    id SERIAL PRIMARY KEY,
    species VARCHAR(100),
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    status VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE guardians (
    id SERIAL PRIMARY KEY,
    tree_id INTEGER REFERENCES trees(id),
    user_id INTEGER REFERENCES users(id),
    adopted_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE health_reports (
    id SERIAL PRIMARY KEY,
    tree_id INTEGER REFERENCES trees(id),
    user_id INTEGER REFERENCES users(id),
    status VARCHAR(50),
    notes TEXT,
    image_url TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);
EOF

#########################################
# INFRA
#########################################

mkdir -p infra/{compose,docker/nginx}

cat > infra/compose/docker-compose.yml <<'EOF'
version: "3.9"

services:

  postgres:
    image: postgres:17

    environment:
      POSTGRES_USER: greenstreet
      POSTGRES_PASSWORD: greenstreet
      POSTGRES_DB: greenstreet

    ports:
      - "5432:5432"

  backend:
    build: ../../backend

    ports:
      - "8000:8000"

  frontend:
    build: ../../frontend

    ports:
      - "4321:4321"
EOF

#########################################
# GITHUB ACTIONS
#########################################

mkdir -p .github/workflows

cat > .github/workflows/backend.yml <<'EOF'
name: Backend CI

on:
  push:

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Python Version
        run: python --version
EOF

cat > .github/workflows/frontend.yml <<'EOF'
name: Frontend CI

on:
  push:

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Node Version
        run: node --version
EOF

#########################################
# DOCS
#########################################

mkdir -p docs

cat > docs/roadmap.md <<'EOF'
# GreenStreet Roadmap

Phase 1
- Add Tree
- Tree Details
- Tree Health

Phase 2
- Tree Guardians
- Photo Uploads

Phase 3
- Heat Map
- Shade Score
EOF

#########################################
# README
#########################################

cat > README.md <<'EOF'
# GreenStreet

Citizen-powered tree stewardship platform.

## Features

- Tree Registry
- Tree Guardians
- Health Reports
- Public Tree Map

## Tech Stack

Frontend:
- Astro
- Tailwind
- Leaflet

Backend:
- FastAPI

Database:
- PostgreSQL

Infra:
- Docker
EOF

echo ""
echo "================================="
echo "GreenStreet project created"
echo "================================="
echo ""
tree .
