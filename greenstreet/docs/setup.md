# GreenStreet Developer Guide

## Overview

GreenStreet is a citizen-powered tree stewardship platform.

Goals:

* Map trees in Indian cities
* Track tree health
* Allow citizens to adopt trees
* Upload photos and monitor growth
* Build a public tree registry

---

# Tech Stack

Frontend

* Astro
* Leaflet
* OpenStreetMap

Backend

* FastAPI
* SQLAlchemy

Database

* PostgreSQL

Object Storage

* MinIO

Infrastructure

* Docker
* Kubernetes (future)
* ArgoCD (future)

---

# Project Structure

```text
greenstreet/

├── frontend/
├── backend/
├── database/
├── docs/
├── infra/
├── k8s/
├── argocd/
└── README.md
```

---

# Prerequisites

Install:

* Git
* Python 3.12+
* NodeJS 22+
* Docker

Verify:

```bash
python3 --version
node --version
docker --version
```

---

# Start PostgreSQL

Location:

```text
greenstreet/infra/compose
```

Run:

```bash
docker compose up postgres
```

or

```bash
docker-compose up postgres
```

Verify:

```bash
docker ps
```

---

# Connect to PostgreSQL

Find container:

```bash
docker ps
```

Connect:

```bash
docker exec -it <postgres-container> psql \
-U greenstreet \
-d greenstreet
```

Exit:

```sql
\q
```

---

# Backend Setup

Location:

```text
greenstreet/backend
```

Create virtual environment:

```bash
python3 -m venv venv
```

Activate:

```bash
source venv/bin/activate
```

Install packages:

```bash
pip install -r requirements.txt
```

Run API:

```bash
uvicorn app.main:app --reload
```

API URL:

```text
http://localhost:8000
```

Swagger:

```text
http://localhost:8000/docs
```

---

# Frontend Setup

Location:

```text
greenstreet/frontend
```

Install packages:

```bash
npm install
```

Start:

```bash
npm run dev
```

Open:

```text
http://localhost:4321
```

---

# Database Schema Changes

When adding new columns:

1. Update model

Location:

```text
backend/app/models/
```

2. Connect to PostgreSQL

```bash
docker exec -it <postgres-container> psql \
-U greenstreet \
-d greenstreet
```

3. Execute ALTER TABLE statements

Example:

```sql
ALTER TABLE trees
ADD COLUMN latitude DOUBLE PRECISION;

ALTER TABLE trees
ADD COLUMN longitude DOUBLE PRECISION;
```

Verify:

```sql
\d trees
```

---

# Tree API

Create Tree

```http
POST /trees
```

Example:

```json
{
  "species": "Neem",
  "latitude": 17.3297,
  "longitude": 76.8343
}
```

---

Get All Trees

```http
GET /trees
```

---

Get Single Tree

```http
GET /trees/{id}
```

---

# Upload Photos

MinIO Console:

```text
http://localhost:9001
```

Credentials:

```text
Username: admin
Password: password123
```

Bucket:

```text
tree-photos
```

Upload Endpoint:

```http
POST /trees/{id}/photo
```

Example:

```bash
curl -X POST \
-F "file=@sample.jpg" \
http://localhost:8000/trees/1/photo
```

---

# Testing

Backend

```bash
curl http://localhost:8000
```

Expected:

```json
{
  "status": "ok"
}
```

Trees

```bash
curl http://localhost:8000/trees
```

---

# Common Commands

Start Backend

```bash
cd backend
source venv/bin/activate
uvicorn app.main:app --reload
```

Start Frontend

```bash
cd frontend
npm run dev
```

Start PostgreSQL

```bash
cd infra/compose
docker compose up postgres
```

Start MinIO

```bash
cd infra/compose
docker compose up minio
```

---

# Current Roadmap

Phase 1

* Tree CRUD
* Leaflet Map
* PostgreSQL
* Photo Upload

Phase 2

* Tree Adoption
* Health Reports
* Guardian Leaderboard

Phase 3

* Heat Map
* Tree Timeline
* Mobile Friendly UI

Phase 4

* Kubernetes
* ArgoCD
* Prometheus
* Grafana

---

# Definition of Done (MVP)

A citizen should be able to:

1. Open the map
2. Add a tree
3. Upload a photo
4. View tree details
5. Adopt a tree
6. Report health issues

Once those six features work, GreenStreet becomes a usable community platform.
