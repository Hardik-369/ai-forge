#!/usr/bin/env bash
set -euo pipefail

# AI-Forge One-Line Install
# ============================================================================
# curl -fsSL https://raw.githubusercontent.com/Hardik-369/ai-forge/main/install.sh | bash
# ============================================================================

REPO="Hardik-369/ai-forge"
BRANCH="main"

echo "=== AI-Forge Installer ==="
echo ""

# Check Docker
if ! command -v docker &>/dev/null; then
    echo "ERROR: Docker not found. Install it first:"
    echo "  curl -fsSL https://get.docker.com | sh"
    exit 1
fi

# Clone repo
if [ -d "ai-forge" ]; then
    echo "Updating existing installation..."
    cd ai-forge
    git pull origin main
else
    echo "Downloading AI-Forge..."
    git clone --depth 1 "https://github.com/$REPO.git"
    cd ai-forge
fi

# Create .env if needed
if [ ! -f ".env" ]; then
    cp .env.example .env
    echo ""
    echo "=== IMPORTANT ==="
    echo "Edit .env to set secure passwords before continuing:"
    echo "  nano .env"
    echo ""
    read -p "Press Enter after editing .env (or Ctrl+C to edit manually)..."
fi

# Deploy
echo ""
echo "Deploying AI-Forge..."
echo "Options:"
echo "  1) Core stack (AI services only)"
echo "  2) Full stack (AI + monitoring + SSL)"
read -p "Choose [1/2]: " choice

case $choice in
  2)
    docker compose -f docker-compose.yml -f docker-compose.proxy.yml -f docker-compose.monitoring.yml up -d
    ;;
  *)
    docker compose up -d
    ;;
esac

echo ""
echo "=== AI-Forge is running! ==="
echo ""
echo "Pull a model:  ./scripts/pull-model.sh llama3.2"
echo "View status:   docker compose ps"
echo "View logs:     docker compose logs -f"
echo ""
echo "Support the project: https://github.com/sponsors/Hardik-369"
