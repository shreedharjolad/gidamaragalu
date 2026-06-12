# GreenStreet Architecture

## Vision

GreenStreet is a citizen-powered urban tree stewardship platform.

The objective is to create a public registry of trees that citizens can:

- Discover
- Monitor
- Adopt
- Protect
- Document

while helping cities become greener, cooler, and healthier.

---

# High-Level Architecture

```text
+------------------+
|    Citizen       |
|  Web Browser     |
+--------+---------+
         |
         v
+------------------+
| Astro Frontend   |
| Leaflet Map UI   |
+--------+---------+
         |
         v
+------------------+
| FastAPI Backend  |
| REST API         |
+--------+---------+
         |
         +------------------+
         |                  |
         v                  v

+----------------+   +----------------+
| PostgreSQL     |   | MinIO          |
| Tree Metadata  |   | Tree Photos    |
+----------------+   +----------------+
```

---

# Component Responsibilities

## Frontend

Technology:

- Astro
- Leaflet
- OpenStreetMap

Responsibilities:

- Display map
- Display trees
- Add new trees
- Upload photos
- Adopt trees
- Search trees

Future:

- Mobile-first UI
- PWA support
- Offline capability

---

## Backend

Technology:

- FastAPI
- SQLAlchemy

Responsibilities:

- CRUD operations
- Authentication
- Validation
- Adoption workflow
- Health reporting

Future:

- JWT Authentication
- Rate limiting
- Audit logging

---

## Database

Technology:

- PostgreSQL

Stores:

- Tree records
- Users
- Adoptions
- Reports

Does NOT store:

- Images

Images are stored in MinIO.

---

## Object Storage

Technology:

- MinIO

Stores:

```text
tree-photos/

├── tree-1-photo1.jpg
├── tree-1-photo2.jpg
├── tree-2-photo1.jpg
└── ...
```

Purpose:

- Growth tracking
- Health monitoring
- Historical records

---

# Current Data Model

## Trees

```text
trees

id
species
status
guardian
latitude
longitude
created_at
```

Example:

```json
{
  "id": 1,
  "species": "Neem",
  "status": "Healthy",
  "guardian": null,
  "latitude": 17.3297,
  "longitude": 76.8343
}
```

---

# Recommended Future Data Model

## trees

```text
id
species
status
latitude
longitude
created_at
updated_at
```

---

## tree_photos

```text
id
tree_id
photo_url
uploaded_at
```

Relationship:

```text
Tree
 |
 +----< TreePhotos
```

---

## users

```text
id
name
email
joined_at
```

---

## tree_adoptions

```text
id
tree_id
user_id
adopted_at
```

Relationship:

```text
User
 |
 +----< TreeAdoptions >----+
                           |
                           v
                         Tree
```

---

## tree_reports

Citizen-reported issues.

```text
id
tree_id
user_id
report_type
description
created_at
```

Examples:

- Needs Water
- Broken Branch
- Pest Infection
- Illegal Cutting

---

# API Architecture

## Tree APIs

```http
GET    /trees
GET    /trees/{id}
POST   /trees
PUT    /trees/{id}
DELETE /trees/{id}
```

---

## Photo APIs

```http
POST /trees/{id}/photo
GET  /trees/{id}/photos
```

---

## Adoption APIs

```http
POST /trees/{id}/adopt
DELETE /trees/{id}/adopt
```

---

## Health Report APIs

```http
POST /trees/{id}/report
GET  /trees/{id}/reports
```

---

# Map Architecture

Current:

```text
OpenStreetMap
       |
       v
    Leaflet
       |
       v
   Tree Marker
```

Future:

```text
OpenStreetMap
       |
       v
    Leaflet
       |
       +--------------------+
       |                    |
       v                    v

 Tree Markers         Heat Maps
```

---

# Marker Popup Design

Example:

```text
🌳 Neem Tree

Status:
Needs Water

Guardian:
Shree

Photos:
12

Last Update:
2 days ago

[View]
[Adopt]
```

---

# Deployment Architecture (Future)

## Local Development

```text
Laptop

├── Astro
├── FastAPI
├── PostgreSQL
└── MinIO
```

---

## Docker

```text
Docker Compose

├── frontend
├── backend
├── postgres
└── minio
```

---

## Kubernetes

```text
Kubernetes Cluster

├── frontend deployment
├── backend deployment
├── postgres statefulset
├── minio statefulset
└── ingress
```

---

# GitOps Architecture

Future:

```text
GitHub
   |
   v
ArgoCD
   |
   v
Kubernetes
```

Purpose:

- Automatic deployment
- Version control
- Rollback capability

---

# Monitoring Architecture

Future:

```text
Application
      |
      v
Prometheus
      |
      v
Grafana
```

Metrics:

- API response time
- Number of trees
- Active users
- Upload count
- Adoption count

---

# Long-Term Vision

Phase 1

- Kalaburagi Tree Registry

Phase 2

- Karnataka Tree Registry

Phase 3

- India Tree Registry

Phase 4

- Citizen Environmental Platform

Features:

- Trees
- Lakes
- Biodiversity
- Air Quality
- Heat Mapping

---

# Core Principle

Every tree should have:

- A location
- A history
- A guardian
- A story

If a citizen can discover a tree, understand its condition,
and contribute to its well-being, the platform is succeeding.