# Marketing Assets

## Product Hunt Description

**Tagline:** Self-hosted AI automation stack — Ollama, n8n, Qdrant, Open WebUI in one command.

**Description:**
AI-Forge gives developers, homelabbers, and small teams a complete local AI platform in under 5 minutes. Stop wrestling with Docker configs and start building AI workflows.

Includes:
- Ollama for local LLM inference
- Open WebUI as ChatGPT-compatible chat interface
- n8n for visual workflow automation
- Qdrant for vector search and RAG pipelines
- PostgreSQL + Redis out of the box
- Optional monitoring, SSL, and backups

Free edition on GitHub. Premium with monitoring + templates available.

## Reddit Announcement (r/selfhosted, r/devops)

**Title:** I built a self-hosted AI stack that deploys in under 5 minutes

**Body:**
Hey r/selfhosted! I got tired of setting up Ollama, n8n, Qdrant, and databases separately every time. So I built AI-Forge — a complete Docker Compose stack that bundles everything together.

What you get:
- Ollama (local LLMs)
- Open WebUI (chat interface)
- n8n (workflow automation)
- Qdrant (vector DB for RAG)
- PostgreSQL + Redis
- Optional: Traefik SSL, Grafana monitoring, backups

One command to deploy:
```
git clone https://github.com/Hardik-369/ai-forge
cd ai-forge
cp .env.example .env
docker compose up -d
```

Free and open source. Premium edition with monitoring and workflow templates available.

Would love your feedback!

## X/Twitter Thread

**Tweet 1:**
I built AI-Forge. A self-hosted AI stack that deploys in 5 minutes.

Ollama + Open WebUI + n8n + Qdrant.
One git clone. One docker compose up.

Free on GitHub.

**Tweet 2:**
The problem: Setting up local AI takes hours.
- Ollama needs GPU config
- n8n needs Postgres/Redis
- Qdrant for vector search
- Monitoring separate
- SSL separate

AI-Forge bundles it all.

**Tweet 3:**
Free edition:
✓ Ollama LLM inference
✓ Open WebUI chat interface
✓ n8n workflow automation
✓ Qdrant vector database
✓ PostgreSQL + Redis

Premium adds:
→ Traefik SSL proxy
→ Grafana monitoring
→ 20+ workflow templates
→ Automated backups

**Tweet 4:**
Self-hosted AI is the future.
Your data stays on your machine.
No per-token API costs.
Full control.

AI-Forge makes it accessible to everyone.

GitHub: github.com/Hardik-369/ai-forge

## LinkedIn Post

**Headline:** 5 minutes to a complete self-hosted AI infrastructure

**Body:**
Every developer I know is experimenting with local AI, but the setup friction is real. Multiple Docker images, database configs, GPU passthrough, and none of it works together out of the box.

So I built AI-Forge — an open-source Docker Compose stack that bundles Ollama, Open WebUI, n8n, and Qdrant into one command.

Why this matters:
- Your data never leaves your machine
- No per-token API bills
- Full control over models and infrastructure
- Production-ready with health checks and persistence

Free edition on GitHub. Premium with monitoring and workflow automation templates available.

What would you build with a local AI stack? Drop your ideas in the comments.

## Dev.to Article Draft

# Self-Host Your Own AI Stack in 5 Minutes (No Cloud Required)

## Introduction
Cloud AI APIs are expensive and your data leaves your machine. But setting up a local alternative has been painful...

## The Stack
- Ollama for LLM inference
- Open WebUI for the chat interface
- n8n for workflow automation
- Qdrant for vector search (RAG)
- PostgreSQL + Redis

## One-Command Setup
```bash
git clone https://github.com/Hardik-369/ai-forge
cd ai-forge
cp .env.example .env
# Edit .env with passwords
docker compose up -d
```

## What You Can Build
- AI chat with local documents
- Automated email responses
- Slack bots with RAG
- Code review assistants
- Customer support automation

## Conclusion
Self-hosted AI is accessible now. Clone the repo and start building.
