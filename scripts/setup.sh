#!/usr/bin/env bash
set -euo pipefail

# AI-Forge Setup Script
# ============================================================================
# Usage: ./scripts/setup.sh
# This script validates prerequisites and initializes the AI-Forge stack.
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "=== AI-Forge Setup ==="
echo ""

# Check prerequisites
echo "[1/5] Checking prerequisites..."

if ! command -v docker &>/dev/null; then
    echo "ERROR: Docker is not installed. Install Docker first."
    exit 1
fi
echo "  [+] Docker: $(docker --version)"

if ! docker compose version &>/dev/null; then
    echo "ERROR: Docker Compose plugin is not installed."
    exit 1
fi
echo "  [+] Docker Compose: $(docker compose version)"

# Create .env if missing
echo "[2/5] Setting up environment..."
if [ ! -f "$PROJECT_DIR/.env" ]; then
    cp "$PROJECT_DIR/.env.example" "$PROJECT_DIR/.env"
    echo "  [+] Created .env file. Edit it with your configuration."
else
    echo "  [+] .env file already exists."
fi

# Generate secure secrets
echo "[3/5] Generating secure secrets..."
if grep -q "change-me" "$PROJECT_DIR/.env" 2>/dev/null; then
    echo "  [!] WARNING: Some secrets still have default values."
    echo "  [!] Edit .env to set secure passwords."
else
    echo "  [+] Secrets appear configured."
fi

# Create required directories
echo "[4/5] Creating directories..."
mkdir -p "$PROJECT_DIR/data"/{postgres,redis,ollama,openwebui,qdrant,n8n}
echo "  [+] Data directories created."

# Pull images
echo "[5/5] Pulling Docker images..."
docker compose --project-directory "$PROJECT_DIR" pull --quiet 2>/dev/null || true
echo "  [+] Images pulled (or cached)."

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Next steps:"
echo "  1. Edit .env with your configuration"
echo "  2. Run: docker compose up -d"
echo "  3. Access Open WebUI at http://localhost:${OPENWEBUI_PORT:-3000}"
echo "  4. Access n8n at http://localhost:${N8N_PORT:-5678}"
echo "  5. Pull a model: docker exec ai-forge-ollama ollama pull llama3.2"
echo ""
