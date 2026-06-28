# Installation Guide

## Prerequisites

### System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| RAM | 8 GB | 16 GB |
| CPU | 4 cores | 8 cores |
| Disk Space | 20 GB | 50 GB SSD |
| Docker Engine | 24.0+ | 24.0+ |
| Docker Compose | v2.20+ | v2.20+ |
| OS | Linux, macOS, WSL2 | Linux (Ubuntu 22.04+) |

### Install Docker

**Linux (Ubuntu/Debian):**
```bash
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker $USER
# Log out and back in
```

**macOS:**
Download [Docker Desktop for Mac](https://docs.docker.com/desktop/install/mac-install/)

**Windows:**
Install [Docker Desktop for Windows](https://docs.docker.com/desktop/install/windows-install/) with WSL2 backend.

### Verify Installation

```bash
docker --version
docker compose version
```

## Install AI-Forge

### Step 1: Clone the Repository

```bash
git clone https://github.com/Hardik-369/ai-forge.git
cd ai-forge
```

### Step 2: Configure Environment

```bash
cp .env.example .env
```

Edit the `.env` file with your preferred editor:

```bash
nano .env
```

At minimum, set these values:

```env
OPENWEBUI_SECRET_KEY=<generate-a-random-string>
N8N_ENCRYPTION_KEY=<generate-another-random-key>
N8N_USER_MANAGEMENT_JWT_SECRET=<yet-another-random-key>
POSTGRES_PASSWORD=<strong-database-password>
REDIS_PASSWORD=<redis-password>
QDRANT_API_KEY=<vector-db-api-key>
```

You can generate random keys with:

```bash
openssl rand -base64 32
```

### Step 3: Start the Stack

```bash
docker compose up -d
```

### Step 4: Verify All Services

```bash
docker compose ps
```

All services should show `healthy` or `running`.

### Step 5: Pull an LLM Model

```bash
./scripts/pull-model.sh llama3.2
```

This downloads the Llama 3.2 model (approximately 2 GB).

### Step 6: Access the Web Interfaces

| Service | URL |
|---------|-----|
| Open WebUI | http://localhost:3000 |
| n8n | http://localhost:5678 |
| Qdrant Dashboard | http://localhost:6333/dashboard |

## NVIDIA GPU Support

If you have an NVIDIA GPU:

1. Install [NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)

2. The `docker-compose.yml` already includes GPU device reservations for Ollama.

3. Verify GPU access:
```bash
docker exec ai-forge-ollama nvidia-smi
```

## Next Steps

- [Configuration Guide](configuration.md) — Customize your setup
- [Quick Start Guide](quickstart.md) — First workflow in 5 minutes
- [Upgrade Guide](upgrade.md) — Update services safely
