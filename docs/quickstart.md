# Quick Start Guide

## First Run: 5 Minutes

```bash
# 1. Clone and configure
git clone https://github.com/Hardik-369/ai-forge.git
cd ai-forge
cp .env.example .env

# 2. Edit .env with secure passwords
nano .env

# 3. Start everything
docker compose up -d

# 4. Pull a model (3-5 minutes)
./scripts/pull-model.sh llama3.2

# 5. Open the UI
open http://localhost:3000
```

## Create Your First AI Workflow

### In Open WebUI

1. Open http://localhost:3000
2. Create an admin account
3. Select `llama3.2` from model dropdown
4. Start chatting

### In n8n

1. Open http://localhost:5678
2. Create an admin account
3. Create a new workflow
4. Add an "Ollama Chat" node
5. Connect to `http://ollama:11434`
6. Add a "Respond to Webhook" node
7. Activate the workflow

## Next Steps

- Integrate with Slack, email, or Discord
- Build RAG pipelines with Qdrant
- Create automated AI agents
- Set up monitoring dashboards
- Schedule automated backups
