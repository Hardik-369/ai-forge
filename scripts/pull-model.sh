#!/usr/bin/env bash
set -euo pipefail

# AI-Forge Model Pull Script
# ============================================================================
# Usage: ./scripts/pull-model.sh [model_name]
# Default: llama3.2
# Examples:
#   ./scripts/pull-model.sh llama3.2
#   ./scripts/pull-model.sh mistral
#   ./scripts/pull-model.sh codellama
# ============================================================================

MODEL="${1:-llama3.2}"

echo "=== Pulling Ollama Model: $MODEL ==="
echo ""

if ! docker ps --format '{{.Names}}' | grep -q "^ai-forge-ollama$"; then
    echo "ERROR: Ollama container is not running."
    echo "Start the stack first: docker compose up -d"
    exit 1
fi

echo "Pulling $MODEL (this may take a while depending on model size)..."
docker exec ai-forge-ollama ollama pull "$MODEL"

echo ""
echo "=== Model $MODEL pulled successfully! ==="
echo ""
echo "Available models:"
docker exec ai-forge-ollama ollama list
