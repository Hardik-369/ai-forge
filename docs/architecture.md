# Architecture

## Overview

AI-Forge is a modular, event-driven architecture designed for local AI inference and workflow automation. Each component runs in its own container with single responsibility.

## Component Details

### Ollama (Local LLM Engine)

- **Role:** Runs open-source large language models locally
- **API:** OpenAI-compatible REST API at `/api/generate` and `/api/chat`
- **Storage:** Models stored in `ollama_data` volume
- **GPU:** Optional NVIDIA GPU passthrough via container toolkit
- **Networking:** Internal on `ai-forge-network`, port `11434`

### Open WebUI (Chat Interface)

- **Role:** ChatGPT-compatible web UI for interacting with LLMs
- **Auth:** Local authentication with signup disabled by default
- **Storage:** User data, conversations, and settings in `openwebui_data`
- **Integration:** Connects to Ollama via `OLLAMA_BASE_URL`

### n8n (Workflow Automation)

- **Role:** Visual workflow automation (Zapier/Make alternative)
- **Database:** PostgreSQL for persistent storage
- **Cache:** Redis for queue management and caching
- **Vector Store:** Qdrant for AI-powered semantic search nodes
- **Execution:** 168-hour execution retention with auto-pruning

### Qdrant (Vector Database)

- **Role:** High-performance vector similarity search
- **API:** REST + gRPC interfaces
- **Storage:** On-disk with `qdrant_data` volume
- **Integration:** n8n Qdrant nodes for semantic search workflows

### PostgreSQL (Primary Database)

- **Role:** Persistent storage for n8n and other services
- **Version:** PostgreSQL 17 Alpine (lightweight)
- **Backup:** Automated via `scripts/backup.sh`

### Redis (Cache & Message Broker)

- **Role:** n8n caching, rate limiting, and message queue
- **Security:** Password-protected with `REQUIREPASS`
- **Persistence:** AOF (Append-Only File) enabled

## Network Architecture

```
┌─────────────────────────────────────────────────────────┐
│                  ai-forge-network                       │
│                   172.20.0.0/16                         │
│                                                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌────────┐ │
│  │  Ollama  │  │Open WebUI│  │   n8n    │  │ Qdrant │ │
│  │ :11434   │  │ :8080    │  │ :5678    │  │ :6333  │ │
│  └────┬─────┘  └────┬─────┘  └────┬─────┘  └───┬────┘ │
│       │             │             │             │       │
│       └─────────────┼─────────────┼─────────────┘       │
│                     │             │                     │
│              ┌──────▼──────┐ ┌────▼──────┐             │
│              │ PostgreSQL  │ │   Redis   │             │
│              │ :5432       │ │ :6379     │             │
│              └─────────────┘ └───────────┘             │
│                                                         │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐             │
│  │  Traefik │  │ Grafana  │  │Prometheus│             │
│  │ :443     │  │ :3000    │  │ :9090    │             │
│  └──────────┘  └──────────┘  └──────────┘             │
└─────────────────────────────────────────────────────────┘
```

## Data Flow

### Chat Request Flow
```
User → Open WebUI → Ollama API → Model Inference → Response
```

### Automation Flow
```
n8n Trigger → (PostgreSQL Load) → AI Node (Ollama) → 
Vector Search (Qdrant) → Action Node → Response
```

### Monitoring Flow
```
Ollama/n8n/Traefik → Prometheus Metrics → Grafana Dashboard
Containers → Loki Logs → Grafana Explore
```

## Security Model

- **Network Isolation:** All services on internal bridge network
- **Secret Management:** Environment variables for credentials
- **Database Auth:** Password-protected PostgreSQL and Redis
- **Vector DB Auth:** API key for Qdrant access
- **Web UI Auth:** Local authentication with disabled signup
- **No Default Credentials:** All secrets require explicit configuration
