#!/usr/bin/env bash
# ==============================================================================
# 🏰 Defense of the Grid — Installer for Google Antigravity
#
# Quick Install:
#   curl -fsSL https://raw.githubusercontent.com/roticagas/defense-of-the-grid/main/install.sh | bash
#
# Options:
#   --global             Install globally to ~/.gemini/config/skills/ (Default)
#   --workspace [DIR]    Install to workspace .agents/skills/ in DIR (Default: current directory)
#   --plugin             Install globally as a plugin to ~/.gemini/config/plugins/
# ==============================================================================

set -euo pipefail

# ANSI color codes
BOLD='\033[1m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

REPO_URL="https://github.com/roticagas/defense-of-the-grid.git"
NAME="defense-of-the-grid"
MODE="global_skill"
WORKSPACE_DIR="$(pwd)"

# Parse flags
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
      echo "Usage: install.sh [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --global             Install globally for all projects (~/.gemini/config/skills/) [Default]"
      echo "  --workspace [DIR]    Install to specific project workspace ([DIR]/.agents/skills/)"
      echo "  --plugin             Install globally as a plugin bundle (~/.gemini/config/plugins/)"
      echo "  -h, --help           Show this help message"
      exit 0
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      exit 1
      ;;
  esac
done

echo -e "${BOLD}${CYAN}"
echo "  🏰 Defense of the Grid — Installer"
echo "  ==================================="
echo -e "${NC}"

# Check git dependency
if ! command -v git >/dev/null 2>&1; then
  echo -e "${RED}❌ Error: 'git' is required but not installed.${NC}"
  exit 1
fi

# Detect whether script is executed from a local clone
LOCAL_DIR=""
if [ -n "${BASH_SOURCE[0]:-}" ] && [ "${BASH_SOURCE[0]}" != "bash" ] && [ -f "${BASH_SOURCE[0]}" ]; then
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  if [ -f "${SCRIPT_DIR}/SKILL.md" ]; then
    LOCAL_DIR="${SCRIPT_DIR}"
  fi
fi

# Determine target directory
if [ "$MODE" = "global_skill" ]; then
  TARGET_PARENT="${HOME}/.gemini/config/skills"
elif [ "$MODE" = "global_plugin" ]; then
  TARGET_PARENT="${HOME}/.gemini/config/plugins"
elif [ "$MODE" = "workspace_skill" ]; then
  TARGET_PARENT="${WORKSPACE_DIR}/.agents/skills"
fi

TARGET_DIR="${TARGET_PARENT}/${NAME}"
mkdir -p "${TARGET_PARENT}"

echo -e "📍 Target: ${BOLD}${TARGET_DIR}${NC}"

if [ -n "${LOCAL_DIR}" ]; then
  # Local repo mode: create or refresh symlink
  echo -e "🔗 Linking local repository (${LOCAL_DIR}) -> ${TARGET_DIR}..."
  ln -sfn "${LOCAL_DIR}" "${TARGET_DIR}"
  echo -e "${GREEN}✓ Successfully symlinked!${NC}"
else
  # Remote curl mode: clone or pull git repository
  if [ -d "${TARGET_DIR}/.git" ]; then
    echo -e "🔄 Existing installation detected. Pulling latest changes..."
    git -C "${TARGET_DIR}" pull --ff-only
    echo -e "${GREEN}✓ Successfully updated to latest version!${NC}"
  elif [ -d "${TARGET_DIR}" ]; then
    echo -e "${YELLOW}⚠️ Directory '${TARGET_DIR}' exists and is not a git repository.${NC}"
    echo "Backing up to ${TARGET_DIR}.bak before cloning..."
    mv "${TARGET_DIR}" "${TARGET_DIR}.bak.$(date +%s)"
    git clone "${REPO_URL}" "${TARGET_DIR}"
    echo -e "${GREEN}✓ Successfully installed!${NC}"
  else
    echo -e "📥 Cloning repository from GitHub..."
    git clone "${REPO_URL}" "${TARGET_DIR}"
    echo -e "${GREEN}✓ Successfully installed!${NC}"
  fi
fi

echo ""
echo -e "${BOLD}${GREEN}🎉 Installation Complete!${NC}"
echo ""
echo "How to use in Antigravity:"
echo -e "  ${BOLD}/defense-of-the-grid ช่วยออกแบบ...${NC}             (Mode A: Architectural Blueprint)"
echo -e "  ${BOLD}/defense-of-the-grid รีวิวโค้ดให้หน่อย${NC}         (Mode B: Standard In-Context Review)"
echo -e "  ${BOLD}/defense-of-the-grid รีวิวละเอียด ขอ fresh eyes${NC} (Mode B: Deep Review via Subagents)"
echo ""
