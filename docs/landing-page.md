# AI-Forge — Your Local AI Infrastructure in 5 Minutes

## Headline
**Stop paying for AI APIs. Run everything locally.**

## Subtitle
One command to deploy Ollama, n8n, Qdrant, and Open WebUI — with monitoring, backups, and automatic SSL.

## Problem
Setting up a self-hosted AI stack is frustrating:
- 5+ separate Docker images to configure
- PostgreSQL and Redis for n8n
- GPU passthrough for Ollama
- Vector database for RAG pipelines
- Reverse proxy with SSL
- Monitoring and backups

This takes hours of reading docs and debugging configs.

## Solution
AI-Forge bundles everything into one production-ready stack.

## Benefits
- **5-minute setup** — One git clone, one `cp .env.example .env`, one `docker compose up`
- **Privacy-first** — All models run locally. Your data never leaves your machine.
- **GPU accelerated** — NVIDIA GPU support built in
- **Production-ready** — Health checks, persistence, auto-restart, structured logging
- **Extensible** — Add services, create workflows, integrate with anything
- **Well documented** — Architecture guide, troubleshooting, configuration reference

## Features
- Local LLM inference with Ollama
- ChatGPT-compatible UI with Open WebUI
- Visual workflow automation with n8n
- Vector database for semantic search with Qdrant
- PostgreSQL for persistent storage
- Redis for caching and messaging
- Traefik reverse proxy with auto SSL (Premium)
- Grafana + Prometheus + Loki monitoring (Premium)
- Uptime Kuma status page (Premium)
- Automated backups (Premium)
- 20+ pre-built n8n workflow templates (Premium)
- AI agent templates (Premium)

## Use Cases
- **Developer** — Local AI coding assistant with code context
- **Homelabber** — Self-hosted AI for home automation
- **Small Business** — Customer support automation, document processing
- **Researcher** — Run experiments with open-source models
- **Privacy Advocate** — Complete data control, no cloud dependency

## Pricing

### Free Edition — $0
- Core AI stack: Ollama, Open WebUI, n8n, Qdrant
- PostgreSQL + Redis
- Community support

### Premium Edition — $29
- Everything in Free
- Traefik reverse proxy with auto SSL
- Grafana dashboards + Prometheus + Loki
- Uptime Kuma status monitoring
- Automated backup scripts
- 20+ n8n workflow templates
- AI agent templates
- Priority email support
- Lifetime updates

## Testimonials

> "I set up AI-Forge in 5 minutes. It took me longer to read this sentence."
> — *Early adopter*

> "Finally, a self-hosted AI stack that just works. The n8n + Ollama integration is game-changing."
> — *AI Engineer*

## FAQ
**Q: Do I need a GPU?**
A: No. CPU mode works, but GPU is recommended for better performance.

**Q: Can I expose it to the internet?**
A: Yes. Premium edition includes Traefik with automatic Let's Encrypt SSL.

**Q: What models can I use?**
A: Any Ollama-compatible model: Llama 3.2, Mistral, CodeLlama, Mixtral, etc.

**Q: Is it production-ready?**
A: Yes. All services have health checks, restart policies, and persistent volumes.

**Q: Can I contribute?**
A: Absolutely. PRs welcome via GitHub.

## Call to Action
[Get Started Free](https://github.com/Hardik-369/ai-forge)

## SEO Metadata
- Title: AI-Forge — Self-hosted AI Automation Stack
- Description: One-command deployment of Ollama, n8n, Qdrant, Open WebUI with monitoring and SSL
- Keywords: self-hosted ai, ollama, n8n, qdrant, docker compose, local llm, ai automation, open webui
- OG Title: AI-Forge — Your Local AI Infrastructure
- OG Description: Run Ollama, n8n, Qdrant, and Open WebUI locally. One command. Five minutes.
- Twitter Card: AI-Forge — Self-hosted AI Automation Stack
