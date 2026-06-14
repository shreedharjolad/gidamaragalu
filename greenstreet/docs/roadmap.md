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


# Tree Adoption
Admin ability to un-adopt a tree
Admin ability to change guardian
Adoption history/audit log
Prevent duplicate guardian names (optional)

# Tree Health
Fixed status dropdown instead of prompt()
Health report history
Reporter name tracking
Severity levels for incidents

# Tree Photos
Placeholder image when no photo exists
File type validation (jpg/png/webp)
File size validation
Photo upload timestamp
Multiple photos per tree
Photo gallery in popup
Photo deletion by admin
Photo replacement confirmation
Search & Filter
Filter by guardian
Filter by adoption status
Filter by health status
Search by tree ID
Clear filters button
Persist filters across page refresh

# Dashboard
Trees by status chart
Trees adopted vs unadopted
Recent health reports
Recently added trees
Trees added per month

# Map
Marker clustering
Fit map to all trees
Current location button
Different marker sizes by importance
Heatmap view
Security
Authentication
User roles (Citizen/Admin)
Tree edit permissions
Rate limiting
Input validation hardening

# Storage
Replace public MinIO access with FastAPI-generated presigned URLs
Automatic image resizing/thumbnails
Image compression
Backup strategy

# Admin Features
Edit tree details
Delete tree
Bulk tree import
Bulk status updates
Admin activity log
Community Features
Guardian leaderboard
Points/badges
Tree contribution statistics
Volunteer rankings

# Future Integrations
Weather API
Tree species database
GIS/OpenStreetMap enrichment
Mobile-friendly PWA