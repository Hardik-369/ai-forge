# AI-Forge 🏗️

> Self-hosted AI automation stack — local LLMs, workflow automation, vector search, and monitoring in minutes.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Docker](https://img.shields.io/badge/docker-ready-2496ED?logo=docker)](https://docker.com)
[![Ollama](https://img.shields.io/badge/ollama-powered-000?logo=ollama)](https://ollama.ai)
[![n8n](https://img.shields.io/badge/n8n-automation-EA4C71?logo=n8n)](https://n8n.io)

---

## What It Does

AI-Forge gives you a complete, production-ready local AI platform in under 5 minutes.

Stop wrestling with complex setups. Stop paying for cloud AI APIs. Start building.

| Instead of | AI-Forge does it in |
|------------|-------------------|
| 2 hours of Docker research | 2 minutes of config |
| 30 minutes of n8n setup | Pre-configured with DB |
| 20 minutes of Ollama config | One `docker compose up` |
| Paying per-token for APIs | Run locally, free inference |

## The Problem

Setting up a local AI stack is painful:
- Ollama needs GPU passthrough config
- n8n needs PostgreSQL and Redis
- Qdrant needs vector store setup
- Monitoring requires separate tools
- Reverse proxy needs SSL configuration
- Every guide assumes different infrastructure

## The Solution

One command. Full stack. Zero configuration guesswork.

```bash
git clone https://github.com/Hardik-369/ai-forge.git
cd ai-forge
cp .env.example .env
docker compose up -d
```

---

## Architecture

```
                   ┌──────────────────────┐
                   │    Traefik (Proxy)    │
                   │  SSL / Routing / WAF  │
                   └──────────┬───────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
   ┌────▼────┐         ┌─────▼─────┐         ┌─────▼────┐
   │ Open     │         │   n8n     │         │  Grafana  │
   │ WebUI    │         │ Workflow  │         │  Monitor  │
   │ Chat UI  │         │ Automate  │         │          │
   └────┬────┘         └─────┬─────┘         └─────┬────┘
        │                    │                     │
   ┌────▼────┐         ┌─────▼─────┐              │
   │ Ollama  │         │  Qdrant   │              │
   │ LLMs    │◄────────┤ Vector DB │              │
   └─────────┘         └─────┬─────┘              │
                             │                    │
                        ┌────▼─────┐        ┌─────▼────┐
                        │PostgreSQL │        │Prometheus│
                        │  + Redis  │        │ + Loki   │
                        └───────────┘        └──────────┘
```

---

## Quick Start (Free Edition)

### Prerequisites

- Docker Engine 24.0+ and Docker Compose v2.20+
- 8 GB RAM minimum (16 GB recommended for LLMs)
- NVIDIA GPU recommended (optional, CPU mode works)

### Install

```bash
git clone https://github.com/Hardik-369/ai-forge.git
cd ai-forge
cp .env.example .env
# Edit .env with your settings
docker compose up -d
```

### First Run

```bash
# Check all services are healthy
docker compose ps

# Pull your first LLM
./scripts/pull-model.sh llama3.2

# Open the UI
open http://localhost:3000  # Open WebUI
open http://localhost:5678  # n8n
```

---

## Services

| Service | Role | Default Port | Image |
|---------|------|-------------|-------|
| **Ollama** | Local LLM inference | 11434 | `ollama/ollama` |
| **Open WebUI** | ChatGPT-compatible UI | 3000 | `open-webui` |
| **n8n** | Workflow automation | 5678 | `n8nio/n8n` |
| **Qdrant** | Vector database | 6333 | `qdrant/qdrant` |
| **PostgreSQL** | Primary database | 5432 | `postgres:17-alpine` |
| **Redis** | Cache & message broker | 6379 | `redis:7-alpine` |

---

## Premium Edition

The premium edition adds production-ready infrastructure:

| Component | Free | Premium |
|-----------|------|---------|
| Core AI Stack (Ollama + WebUI + n8n) | ✅ | ✅ |
| PostgreSQL + Redis | ✅ | ✅ |
| Qdrant Vector DB | ✅ | ✅ |
| **Traefik Reverse Proxy (SSL)** | ❌ | ✅ |
| **Grafana Dashboards** | ❌ | ✅ |
| **Prometheus + Loki Monitoring** | ❌ | ✅ |
| **Uptime Kuma Status** | ❌ | ✅ |
| **Automated Backups** | ❌ | ✅ |
| **20+ n8n Workflow Templates** | ❌ | ✅ |
| **Pre-built AI Agent Templates** | ❌ | ✅ |
| **Security Hardening Guide** | ❌ | ✅ |
| **Email/Vector/Web Search Integrations** | ❌ | ✅ |
| **Priority Support** | ❌ | ✅ |

---

## Environment Variables

See `.env.example` for all options. Key variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `DOMAIN` | `ai-forge.local` | Base domain for services |
| `OPENWEBUI_SECRET_KEY` | *(required)* | Session encryption key |
| `N8N_ENCRYPTION_KEY` | *(required)* | n8n encryption key |
| `POSTGRES_PASSWORD` | *(required)* | Database password |
| `OLLAMA_NUM_PARALLEL` | `4` | Concurrent model requests |
| `MEMORY_LIMIT_AI` | `4g` | AI service memory limit |

---

## Common Tasks

```bash
# View logs
docker compose logs -f

# Update all services
docker compose pull
docker compose up -d

# Stop the stack
docker compose down

# Full cleanup (removes volumes)
docker compose down -v

# Run a model query via API
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.2",
  "prompt": "Hello!"
}'
```

---

## Directory Structure

```
ai-forge/
├── docker-compose.yml         # Core stack definition
├── .env.example               # Environment template
├── stacks/
│   ├── proxy/
│   │   └── traefik.yml        # Reverse proxy (premium)
│   └── monitoring/
│       ├── monitoring.yml     # Monitoring stack (premium)
│       ├── prometheus.yml     # Metrics config
│       ├── loki-config.yml    # Log aggregation config
│       └── grafana-datasources.yml
├── scripts/
│   ├── setup.sh               # Initial setup
│   ├── backup.sh              # Volume backup
│   └── pull-model.sh          # Download Ollama models
├── docs/
│   ├── installation.md
│   ├── configuration.md
│   ├── upgrade.md
│   ├── troubleshooting.md
│   └── architecture.md
└── examples/
    ├── n8n-workflows/         # Automation templates
    └── api-examples/          # REST API examples
```

---

## Requirements

| Resource | Free | Premium |
|----------|------|---------|
| RAM | 8 GB | 16 GB |
| Disk | 20 GB | 50 GB |
| CPU | 4 cores | 8 cores |
| GPU | Optional | Recommended |
| Docker | 24.0+ | 24.0+ |

---

## Roadmap

- [x] Core AI stack
- [x] n8n automation with PostgreSQL
- [x] Qdrant vector database
- [ ] Traefik reverse proxy
- [ ] Monitoring stack
- [ ] Pre-built AI agent workflows
- [ ] Kubernetes Helm chart
- [ ] Terraform deployment module

---

## License

MIT — see [LICENSE](LICENSE)

Built with ❤️ for the self-hosted community.
