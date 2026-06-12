# Deployment Guide

## Local Development

### PostgreSQL

```bash
cd infra/compose
docker compose up postgres
```

### Backend

```bash
cd backend

source venv/bin/activate

uvicorn app.main:app --reload
```

### Frontend

```bash
cd frontend

npm install

npm run dev
```

---

# Docker Deployment

```bash
cd infra/compose

docker compose up --build
```

---

# Kubernetes Deployment (Future)

Components

```text
frontend deployment
backend deployment
postgres statefulset
minio statefulset
ingress
```

Apply

```bash
kubectl apply -f k8s/
```

---

# GitOps Deployment

Repository

```text
GitHub
```

Deployment

```text
ArgoCD
```

Flow

```text
Git Push
   |
   v
ArgoCD Sync
   |
   v
Kubernetes
```

---

# Monitoring

Future

```text
Prometheus
Grafana
AlertManager
```

Metrics

- Tree Count
- Adoption Count
- API Latency
- Photo Upload Count