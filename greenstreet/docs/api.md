# API Documentation

Base URL

```text
http://localhost:8000
```

---

# Health Check

## GET /

Response

```json
{
  "status": "ok"
}
```

---

# Trees

## Get All Trees

GET /trees

Response

```json
[
  {
    "id": 1,
    "species": "Neem",
    "status": "Healthy",
    "latitude": 17.3297,
    "longitude": 76.8343
  }
]
```

---

## Get Tree

GET /trees/{id}

---

## Create Tree

POST /trees

Request

```json
{
  "species": "Neem",
  "latitude": 17.3297,
  "longitude": 76.8343
}
```

Response

```json
{
  "id": 1,
  "species": "Neem",
  "status": "Healthy"
}
```

---

# Photos

## Upload Photo

POST /trees/{id}/photo

Multipart form upload.

---

# Adoptions

## Adopt Tree

POST /trees/{id}/adopt

Response

```json
{
  "message": "Tree adopted"
}
```