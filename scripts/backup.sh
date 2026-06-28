#!/usr/bin/env bash
set -euo pipefail

# AI-Forge Backup Script
# ============================================================================
# Usage: ./scripts/backup.sh
# Creates timestamped backups of all persistent volumes.
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BACKUP_DIR="$PROJECT_DIR/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_PATH="$BACKUP_DIR/ai-forge-backup-$TIMESTAMP"

echo "=== AI-Forge Backup: $TIMESTAMP ==="

mkdir -p "$BACKUP_PATH"

backup_volume() {
    local volume_name="$1"
    local container_name="$2"
    local volume_path="$3"
    local backup_file="$BACKUP_PATH/${volume_name}.tar.gz"

    echo "  Backing up $volume_name..."
    if docker ps --format '{{.Names}}' | grep -q "^${container_name}$"; then
        docker exec "$container_name" tar czf - "$volume_path" > "$backup_file" 2>/dev/null || {
            echo "  [!] Warning: Failed to backup $volume_name (container may not have tar)"
        }
    else
        echo "  [!] Container $container_name is not running, skipping."
    fi
}

backup_volume "postgres" "ai-forge-postgres" "/var/lib/postgresql/data"
backup_volume "ollama" "ai-forge-ollama" "/root/.ollama"
backup_volume "qdrant" "ai-forge-qdrant" "/qdrant/storage"

echo ""
echo "Backup completed: $BACKUP_PATH"
echo "Total size: $(du -sh "$BACKUP_PATH" | cut -f1)"
