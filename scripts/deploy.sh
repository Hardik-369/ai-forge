#!/usr/bin/env bash
set -euo pipefail

# AI-Forge Deploy Script
# ============================================================================
# Usage:
#   ./scripts/deploy.sh core     # Core AI stack only
#   ./scripts/deploy.sh full     # Full stack with monitoring + SSL
#   ./scripts/deploy.sh status   # Check health of all services
# ============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$PROJECT_DIR"

case "${1:-help}" in
  core)
    echo "=== Deploying Core AI Stack ==="
    docker compose up -d
    echo "=== Done ==="
    echo "Open WebUI: http://localhost:${OPENWEBUI_PORT:-3000}"
    echo "n8n:        http://localhost:${N8N_PORT:-5678}"
    ;;

  full)
    echo "=== Deploying Full AI Stack ==="
    docker compose -f docker-compose.yml -f docker-compose.proxy.yml -f docker-compose.monitoring.yml up -d
    echo "=== Done ==="
    echo "Open WebUI:  http://localhost:${OPENWEBUI_PORT:-3000}"
    echo "n8n:         http://localhost:${N8N_PORT:-5678}"
    echo "Grafana:     http://localhost:${GRAFANA_PORT:-3001}"
    echo "Uptime Kuma: http://localhost:${UPTIME_KUMA_PORT:-3002}"
    ;;

  status)
    echo "=== Service Health ==="
    docker compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"
    ;;

  logs)
    docker compose logs -f "${2:-}"
    ;;

  stop)
    docker compose down
    ;;

  update)
    docker compose pull
    docker compose up -d
    echo "=== Updated ==="
    ;;

  clean)
    docker compose down -v
    echo "=== All data removed ==="
    ;;

  *)
    echo "AI-Forge Deploy Script"
    echo ""
    echo "Usage:"
    echo "  ./scripts/deploy.sh core     Start core AI stack"
    echo "  ./scripts/deploy.sh full     Start full stack with monitoring + SSL"
    echo "  ./scripts/deploy.sh status   Show service status"
    echo "  ./scripts/deploy.sh logs     Tail logs"
    echo "  ./scripts/deploy.sh stop     Stop all services"
    echo "  ./scripts/deploy.sh update   Update all images"
    echo "  ./scripts/deploy.sh clean    Remove everything (CAUTION)"
    ;;
esac
