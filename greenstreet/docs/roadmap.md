# GreenStreet Roadmap

## Phase 1 - MVP

Target: Kalaburagi

Features

- Tree CRUD
- Leaflet Map
- PostgreSQL
- MinIO
- Photo Upload
- Tree Adoption

Status

- [x] Backend
- [x] Frontend
- [x] PostgreSQL
- [ ] MinIO Integration
- [ ] Adoption Workflow

---

## Phase 2

Target: Karnataka

Features

- User Registration
- Authentication
- Tree Search
- Tree Health Reports
- Tree Timelines

---

## Phase 3

Target: India

Features

- Multi-city support
- Heat Maps
- Tree Analytics
- Public Dashboard

---

## Phase 4

Features

- Kubernetes
- ArgoCD
- Grafana
- Prometheus
- Disaster Recovery

---

## Long-Term Goals

- Tree census
- Citizen science
- Biodiversity tracking
- Urban cooling analytics

## Technical Debt / Enhancements

### Validation

- Prevent creating trees with empty species names
- Validate minimum species length
- Prevent invalid coordinates

### Adoption Workflow

- Once adopted, disable "Adopt Tree" button
- Show "Adopted by <guardian>"
- Allow admin reassignment
- Maintain adoption history

### Security

- Authentication
- Admin role
- Moderator role

### Data Quality

- Duplicate tree detection
- Species autocomplete
- GPS accuracy indicator

# Future Enhancement:
Replace public MinIO bucket access with FastAPI-generated presigned URLs.