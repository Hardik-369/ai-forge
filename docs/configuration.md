# Configuration Guide

## Environment Variables

### Core Configuration

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `DOMAIN` | No | `ai-forge.local` | Base domain for Traefik routing |
| `TZ` | No | `UTC` | Container timezone |
| `DOCKER_NETWORK` | No | `ai-forge-network` | Internal Docker network name |

### Security

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `OPENWEBUI_SECRET_KEY` | **Yes** | — | Session encryption (generate with `openssl rand -base64 32`) |
| `N8N_ENCRYPTION_KEY` | **Yes** | — | Workflow encryption key (32+ chars) |
| `N8N_USER_MANAGEMENT_JWT_SECRET` | **Yes** | — | JWT signing secret |
| `POSTGRES_PASSWORD` | **Yes** | — | Database superuser password |
| `REDIS_PASSWORD` | **Yes** | — | Redis requirepass |
| `QDRANT_API_KEY` | No | — | Vector DB API key |

### Ollama

| Variable | Default | Description |
|----------|---------|-------------|
| `OLLAMA_PORT` | `11434` | API port |
| `OLLAMA_KEEP_ALIVE` | `5m` | Model stay-alive duration |
| `OLLAMA_NUM_PARALLEL` | `4` | Concurrent request threads |
| `OLLAMA_MAX_LOADED_MODELS` | `2` | Models kept in memory |

### n8n

| Variable | Default | Description |
|----------|---------|-------------|
| `N8N_PORT` | `5678` | Web UI port |
| `EXECUTIONS_DATA_PRUNE` | `true` | Auto-delete old executions |
| `EXECUTIONS_DATA_MAX_AGE` | `168` | Keep executions (hours) |

### Resource Limits

| Variable | Default | Description |
|----------|---------|-------------|
| `MEMORY_LIMIT_AI` | `4g` | Max memory for AI services |
| `MEMORY_LIMIT_DB` | `1g` | Max memory for databases |
| `MEMORY_LIMIT_AUTOMATION` | `512m` | Max memory for n8n |
| `MEMORY_LIMIT_PROXY` | `256m` | Max memory for Traefik |

## Port Conflicts

If any default port is in use, change it in `.env`:

```env
OPENWEBUI_PORT=8080
N8N_PORT=5679
POSTGRES_PORT=5433
```

## Custom Domain with SSL

To expose services on the internet with automatic SSL:

1. Set your domain in `.env`:
```env
DOMAIN=ai.example.com
CERT_EMAIL=admin@example.com
```

2. Deploy the Traefik stack (Premium):
```bash
docker compose -f docker-compose.yml -f stacks/proxy/traefik.yml up -d
```

3. Access services at:
   - `https://chat.ai.example.com` — Open WebUI
   - `https://n8n.ai.example.com` — n8n
   - `https://monitor.ai.example.com` — Grafana

## Memory Tuning

For systems with limited RAM:

```env
MEMORY_LIMIT_AI=2g
OLLAMA_NUM_PARALLEL=2
OLLAMA_MAX_LOADED_MODELS=1
```

For production systems with ample RAM:

```env
MEMORY_LIMIT_AI=8g
OLLAMA_NUM_PARALLEL=8
OLLAMA_KEEP_ALIVE=30m
```
