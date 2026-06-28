# Upgrade Guide

## Standard Upgrade

```bash
cd ai-forge

# Pull latest images
docker compose pull

# Recreate containers with new images
docker compose up -d

# Remove old images
docker image prune -a
```

## Major Version Upgrade

1. Backup your data:
```bash
./scripts/backup.sh
```

2. Review changelog:
```bash
cat CHANGELOG.md
```

3. Update .env.example changes:
```bash
# Check what's new
diff .env .env.example
```

4. Apply migration if needed:
```bash
docker compose down
docker compose up -d
```

## Rollback

```bash
# Revert to previous image tag
# Edit docker-compose.yml to pin specific version
docker compose up -d
```
