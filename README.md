# AI-Forge

**Production-grade self-hosted AI infrastructure. One command. Full stack. Zero lock-in.**

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Docker](https://img.shields.io/badge/docker-24.0+-2496ED?logo=docker)](https://docker.com)
[![Ollama](https://img.shields.io/badge/ollama-0.5+-000?logo=ollama)](https://ollama.ai)
[![n8n](https://img.shields.io/badge/n8n-1.80+-EA4C71?logo=n8n)](https://n8n.io)
[![Maintenance](https://img.shields.io/badge/maintenance-active-brightgreen)]()
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen)]()

---

- [Overview](#overview)
- [Stack](#stack)
- [Quick Start](#quick-start)
- [Deployment Profiles](#deployment-profiles)
- [Configuration](#configuration)
- [Management](#management)
- [Architecture](#architecture)
- [Requirements](#requirements)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)

---

## Overview

AI-Forge deploys a complete local AI platform — LLM inference, workflow automation, vector search, monitoring, and reverse proxy — on any Docker host.

It replaces the typical 2-hour manual setup with a single `docker compose up`.

**What you get:**

- Local LLM inference via Ollama (GPU-accelerated when available)
- ChatGPT-compatible interface via Open WebUI
- Visual workflow automation via n8n with PostgreSQL + Redis
- Vector search via Qdrant
- Optional Grafana dashboards, Prometheus metrics, Loki logs, and Uptime Kuma status
- Optional Traefik reverse proxy with automatic Let's Encrypt SSL

**What you don't get:**

- Vendor lock-in
- Per-token API costs
- Data leaving your network
- License keys or premium tiers

---

## Stack

| Service | Role | Default Port | Image |
|---|---|---|---|
| **Ollama** | LLM inference (GPU/CPU) | 11434 | `ollama/ollama` |
| **Open WebUI** | ChatGPT-compatible web UI | 3000 | `open-webui` |
| **n8n** | Workflow automation engine | 5678 | `n8nio/n8n` |
| **Qdrant** | Vector similarity search | 6333 | `qdrant/qdrant` |
| **PostgreSQL** | Primary database (n8n, Qdrant) | 5432 | `postgres:17-alpine` |
| **Redis** | Cache and message broker | 6379 | `redis:7-alpine` |
| **Traefik** | Reverse proxy with auto SSL | 443 | `traefik:v3.3` |
| **Grafana** | Visualization and dashboards | 3001 | `grafana/grafana` |
| **Prometheus** | Metrics collection and alerting | 9090 | `prom/prometheus` |
| **Loki** | Log aggregation and querying | 3100 | `grafana/loki` |
| **Uptime Kuma** | Uptime monitoring and status pages | 3002 | `louislam/uptime-kuma` |

---

## Quick Start

### Prerequisites

- Docker Engine 24.0+
- Docker Compose v2.20+
- 8 GB RAM (16 GB for full stack with LLMs)
- NVIDIA GPU with CUDA 11+ (recommended, not required)

### Install

```bash
git clone https://github.com/Hardik-369/ai-forge.git
cd ai-forge
cp .env.example .env
```

Edit `.env` and set at minimum:

```
OPENWEBUI_SECRET_KEY=$(openssl rand -base64 32)
N8N_ENCRYPTION_KEY=$(openssl rand -base64 32)
POSTGRES_PASSWORD=$(openssl rand -base64 24)
```

Then deploy your chosen profile:

```bash
# Core stack (AI services only)
docker compose up -d
```

```bash
# Full stack (AI + monitoring + SSL)
docker compose \
  -f docker-compose.yml \
  -f docker-compose.proxy.yml \
  -f docker-compose.monitoring.yml \
  up -d
```

### First Run

```bash
docker compose ps                                          # Verify health
./scripts/pull-model.sh llama3.2                           # Download an LLM
curl http://localhost:3000                                  # Open WebUI
curl http://localhost:5678                                  # n8n
```

Full stack endpoints:

| Service | URL | Default Credentials |
|---|---|---|
| Open WebUI | `http://localhost:3000` | Create on first login |
| n8n | `http://localhost:5678` | Set via `.env` |
| Grafana | `http://localhost:3001` | `admin` / `admin` |
| Uptime Kuma | `http://localhost:3002` | Create on first login |
| API (Ollama) | `http://localhost:11434` | — |

---

## Deployment Profiles

| Profile | Services | Command |
|---|---|---|
| **Core** | Ollama, WebUI, n8n, Qdrant, PostgreSQL, Redis | `docker compose up -d` |
| **Full** | Core + Traefik, Grafana, Prometheus, Loki, Uptime Kuma | See [full stack](#install) |
| **Custom** | Any subset | Use `--profile` flags |

### Deploy Script

```bash
./scripts/deploy.sh core     # Core stack
./scripts/deploy.sh full     # Full stack
./scripts/deploy.sh status   # Health check
./scripts/deploy.sh logs     # Tail logs
./scripts/deploy.sh stop     # Stop all services
./scripts/deploy.sh update   # Pull latest images
./scripts/deploy.sh clean    # Remove everything (data loss)
```

---

## Configuration

All configuration lives in `.env`. Key variables:

| Variable | Default | Required | Description |
|---|---|---|---|
| `DOMAIN` | `ai-forge.local` | No | Base domain for Traefik routing |
| `CERT_EMAIL` | — | For SSL | Let's Encrypt notification email |
| `OPENWEBUI_SECRET_KEY` | — | **Yes** | Session encryption (32+ chars) |
| `N8N_ENCRYPTION_KEY` | — | **Yes** | n8n credential encryption (32+ chars) |
| `N8N_USER_MANAGEMENT_JWT_SECRET` | — | **Yes** | n8n JWT signing secret |
| `POSTGRES_PASSWORD` | — | **Yes** | Database superuser password |
| `POSTGRES_USER` | `ai_forge` | No | Database user |
| `POSTGRES_DB` | `ai_forge` | No | Database name |
| `QDRANT_API_KEY` | — | No | Vector DB access key |
| `REDIS_PASSWORD` | — | No | Redis password (set for production) |
| `GRAFANA_PORT` | `3001` | No | Grafana host port |
| `UPTIME_KUMA_PORT` | `3002` | No | Uptime Kuma host port |
| `MEMORY_LIMIT_AI` | `4g` | No | Memory cap for AI services |
| `TZ` | `UTC` | No | Container timezone |

Generate secure values:

```bash
cat > .env <<EOF
OPENWEBUI_SECRET_KEY=$(openssl rand -base64 32)
N8N_ENCRYPTION_KEY=$(openssl rand -base64 32)
N8N_USER_MANAGEMENT_JWT_SECRET=$(openssl rand -base64 32)
POSTGRES_PASSWORD=$(openssl rand -base64 24)
POSTGRES_USER=ai_forge
POSTGRES_DB=ai_forge
EOF
```

---

## Management

### Model Management

```bash
# List available models
ollama list

# Pull a model
./scripts/pull-model.sh llama3.2

# Pull from API
curl -X POST http://localhost:11434/api/pull -d '{"name": "mistral"}'

# Remove a model
ollama rm llama3.2
```

### Backup

```bash
# Stop services writing to volumes
docker compose stop postgres redis qdrant

# Backup volumes
docker run --rm -v ai-forge_postgres_data:/source -v $(pwd)/backups:/dest alpine \
  tar czf /dest/postgres-$(date +%Y%m%d).tar.gz -C /source .

# Restart
docker compose start postgres redis qdrant
```

### Update

```bash
docker compose pull
docker compose up -d
```

### Logs

```bash
docker compose logs -f           # All services
docker compose logs -f n8n       # Specific service
```

---

## Architecture

```
                    ┌──────────────────────┐
                    │    Traefik :443       │
                    │  SSL / Routing / WAF  │
                    └──────────┬───────────┘
                               │
         ┌─────────────────────┼─────────────────────┐
         │                     │                     │
    ┌────▼────┐         ┌─────▼─────┐         ┌─────▼────┐
    │ Open     │         │   n8n     │         │  Grafana  │
    │ WebUI    │         │ Workflow  │         │  Dashbrd  │
    │ :3000    │         │ :5678     │         │ :3001     │
    └────┬────┘         └─────┬─────┘         └─────┬────┘
         │                    │                     │
    ┌────▼────┐         ┌─────▼─────┐              │
    │ Ollama  │         │  Qdrant   │              │
    │ :11434  │◄────────┤ :6333     │              │
    └─────────┘         └─────┬─────┘              │
                              │                    │
                         ┌────▼─────┐        ┌─────▼────┐
                         │PostgreSQL │        │Prometheus │
                         │ :5432     │        │ + Loki    │
                         │ + Redis   │        │ :9090     │
                         │ :6379     │        │ :3100     │
                         └───────────┘        └───────────┘
```

All services communicate over the `ai-forge-network` bridge. Sensitive services (database, vector store) are not exposed to the host unless explicitly configured.

---

## Requirements

| Resource | Core | Full |
|---|---|---|
| RAM | 8 GB | 16 GB |
| Disk | 20 GB | 50 GB |
| CPU | 4 cores | 8 cores |
| GPU | Optional (CUDA 11+) | Recommended |
| Docker | 24.0+ | 24.0+ |

**GPU passthrough** is configured automatically if NVIDIA Container Toolkit is installed. Verify:

```bash
docker run --rm --gpus all nvidia/cuda:12.0-base nvidia-smi
```

---

## Roadmap

- [x] Core AI stack (Ollama, WebUI, n8n, Qdrant, PostgreSQL, Redis)
- [x] Monitoring and observability (Grafana, Prometheus, Loki)
- [x] Reverse proxy with automatic SSL (Traefik)
- [x] Uptime monitoring (Uptime Kuma)
- [x] Deploy automation (`scripts/deploy.sh`, `install.sh`)
- [ ] Pre-built n8n workflow templates (RAG, email agents, Slack bots)
- [ ] Docker health dashboard (container-level metrics in Grafana)
- [ ] Kubernetes Helm chart (K3s-optimized)
- [ ] Terraform module (single-node and cluster deployments)
- [ ] Automated volume backup to S3/SCP
- [ ] SSO/OIDC authentication for WebUI and Grafana

---

## Contributing

PRs are welcome. For structural changes, open an issue first.

This project follows:

- Conventional commits (`feat:`, `fix:`, `docs:`, `chore:`)
- Semantic versioning
- Docker label schema for service discovery

---

## Support

If this project saves you time or money:

- [GitHub Sponsors](https://github.com/sponsors/Hardik-369)
- [Buy Me a Coffee](https://www.buymeacoffee.com/hardikkawale)

Maintenance and development are funded entirely by community sponsors.

---

## License

MIT. See [LICENSE](LICENSE).
