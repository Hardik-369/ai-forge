# Troubleshooting Guide

## Common Issues

### Containers crash on startup

**Symptoms:** `docker compose ps` shows `Exit 1` or `unhealthy`

**Solutions:**

1. Check logs:
```bash
docker compose logs <service-name>
```

2. Ensure all secrets are set in `.env`:
```bash
grep -r "change-me" .env
```
If any secrets still contain `change-me`, replace them with secure values.

3. Check port conflicts:
```bash
# Linux/macOS
sudo lsof -i :3000 -i :5678 -i :11434

# Windows (PowerShell)
netstat -ano | findstr ":3000 :5678 :11434"
```

### Ollama: "no GPU available"

**Symptoms:** Ollama runs but model inference is slow.

**Solutions:**

1. Verify NVIDIA drivers:
```bash
nvidia-smi
```

2. Check NVIDIA Container Toolkit:
```bash
docker run --rm --gpus all nvidia/cuda:12.0-base nvidia-smi
```

3. If no GPU, remove GPU reservation from `docker-compose.yml`:
```yaml
# Comment out or remove:
# deploy:
#   resources:
#     reservations:
#       devices:
#         - driver: nvidia
#           count: all
#           capabilities: [gpu]
```

### n8n: "database connection failed"

**Symptoms:** n8n container exits with database connection error.

**Solutions:**

1. Wait for PostgreSQL to be ready (it can take 30s on first start):
```bash
docker compose logs postgres
```

2. Verify credentials match between n8n and postgres in `.env`.

3. Restart n8n after PostgreSQL is healthy:
```bash
docker compose restart n8n
```

### PostgreSQL: "role does not exist"

**Symptoms:** Service cannot connect to database.

**Solution:** Recreate the database volume:
```bash
docker compose down -v
docker compose up -d
```
**Warning:** This destroys all existing data.

### "Address already in use"

**Symptom:** Port conflicts with existing services.

**Solution:** Change ports in `.env`:
```env
OPENWEBUI_PORT=8080
N8N_PORT=5679
```

Then restart:
```bash
docker compose up -d
```

## Debug Mode

Enable verbose logging for any service:

```bash
docker compose logs -f <service-name>
```

For Ollama specifically:
```bash
docker exec ai-forge-ollama ollama list
docker exec ai-forge-ollama cat /root/.ollama/logs/server.log
```

## Reset Everything

```bash
# Stop and remove containers
docker compose down

# Remove all data (CAUTION: irreversible)
docker compose down -v
rm -rf data/

# Fresh start
cp .env.example .env
docker compose up -d
```

## Getting Help

- Check [GitHub Issues](https://github.com/Hardik-369/ai-forge/issues)
- Review logs: `docker compose logs`
- Premium support: Email support included with Premium license
