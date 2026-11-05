#!/usr/bin/env bash
# ==============================================================================
# 🏰 Defense of the Code — Uninstaller for Google Antigravity & Claude Code
#
# Usage:
#   ./uninstall.sh [--global] [--workspace [DIR]] [--plugin] [--claude]
# ==============================================================================

set -euo pipefail

BOLD='\033[1m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

NAME="defense-of-the-code"
ALIAS_NAME="dotc"
ALIAS_MARKER="short alias of the **\`defense-of-the-code\`** skill"
PLATFORM="antigravity"
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
    --claude)
      PLATFORM="claude"
      shift
      ;;
    -h|--help)
      echo "Usage: uninstall.sh [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --global             Remove global skill [Default]"
      echo "                         Antigravity: ~/.gemini/config/skills/   Claude Code: ~/.claude/skills/"
      echo "  --workspace [DIR]    Remove workspace skill"
      echo "                         Antigravity: [DIR]/.agents/skills/      Claude Code: [DIR]/.claude/skills/"
      echo "  --plugin             Remove global plugin (~/.gemini/config/plugins/, Antigravity only)"
      echo "  --claude             Target Claude Code instead of Antigravity (also removes the /dotc alias skill)"
      echo "  -h, --help           Show this help message"
      exit 0
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      exit 1
      ;;
  esac
done

if [ "$PLATFORM" = "claude" ] && [ "$MODE" = "global_plugin" ]; then
  echo -e "${RED}❌ Error: --plugin is Antigravity-only. Use --claude (global) or --claude --workspace [DIR].${NC}"
  exit 1
fi

if [ "$PLATFORM" = "claude" ]; then
  if [ "$MODE" = "workspace_skill" ]; then
    TARGET="${WORKSPACE_DIR}/.claude/skills/${NAME}"
  else
    TARGET="${HOME}/.claude/skills/${NAME}"
  fi
elif [ "$MODE" = "global_skill" ]; then
  TARGET="${HOME}/.gemini/config/skills/${NAME}"
elif [ "$MODE" = "global_plugin" ]; then
  TARGET="${HOME}/.gemini/config/plugins/${NAME}"
elif [ "$MODE" = "workspace_skill" ]; then
  TARGET="${WORKSPACE_DIR}/.agents/skills/${NAME}"
fi

echo -e "${BOLD}${CYAN}🏰 Defense of the Code — Uninstaller${NC}"
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

# Remove the generated /dotc alias only if it is ours (never another skill named dotc)
if [ "$PLATFORM" = "claude" ]; then
  ALIAS_DIR="$(dirname "${TARGET}")/${ALIAS_NAME}"
  if [ -f "${ALIAS_DIR}/SKILL.md" ] && grep -qF "${ALIAS_MARKER}" "${ALIAS_DIR}/SKILL.md"; then
    rm -rf "${ALIAS_DIR}"
    echo -e "${GREEN}✓ Successfully removed /dotc alias skill.${NC}"
  fi
fi
