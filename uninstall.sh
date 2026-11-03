#!/usr/bin/env bash
# ==============================================================================
# 🏰 Defense of the Grid — Uninstaller for Google Antigravity
#
# Usage:
#   ./uninstall.sh [--global] [--workspace [DIR]] [--plugin]
# ==============================================================================

set -euo pipefail

BOLD='\033[1m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

NAME="defense-of-the-grid"
MODE="global_skill"
WORKSPACE_DIR="$(pwd)"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --global)
      MODE="global_skill"
      shift
      ;;
    --plugin)
      MODE="global_plugin"
      shift
      ;;
    --workspace)
      MODE="workspace_skill"
      if [[ $# -gt 1 && ! "$2" =~ ^-- ]]; then
        WORKSPACE_DIR="$2"
        shift 2
      else
        shift
      fi
      ;;
    -h|--help)
      echo "Usage: uninstall.sh [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --global             Remove global skill (~/.gemini/config/skills/) [Default]"
      echo "  --workspace [DIR]    Remove workspace skill ([DIR]/.agents/skills/)"
      echo "  --plugin             Remove global plugin (~/.gemini/config/plugins/)"
      echo "  -h, --help           Show this help message"
      exit 0
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      exit 1
      ;;
  esac
done

if [ "$MODE" = "global_skill" ]; then
  TARGET="${HOME}/.gemini/config/skills/${NAME}"
elif [ "$MODE" = "global_plugin" ]; then
  TARGET="${HOME}/.gemini/config/plugins/${NAME}"
elif [ "$MODE" = "workspace_skill" ]; then
  TARGET="${WORKSPACE_DIR}/.agents/skills/${NAME}"
fi

echo -e "${BOLD}${CYAN}🏰 Defense of the Grid — Uninstaller${NC}"
echo -e "Target: ${BOLD}${TARGET}${NC}"

if [ -L "${TARGET}" ]; then
  # Symlink: safe single-file unlink
  rm "${TARGET}"
  echo -e "${GREEN}✓ Successfully removed symlink.${NC}"
elif [ -d "${TARGET}" ]; then
  # Real directory / git clone
  rm -rf "${TARGET}"
  echo -e "${GREEN}✓ Successfully removed directory.${NC}"
else
  echo -e "${YELLOW}ℹ Target '${TARGET}' not found. Nothing to remove.${NC}"
fi
