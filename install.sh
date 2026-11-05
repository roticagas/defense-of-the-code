#!/usr/bin/env bash
# ==============================================================================
# 🏰 Defense of the Code — Installer for Google Antigravity & Claude Code
#
# Quick Install:
#   curl -fsSL https://raw.githubusercontent.com/roticagas/defense-of-the-code/main/install.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/roticagas/defense-of-the-code/main/install.sh | bash -s -- --claude
#
# Options:
#   --global             Install globally (Default)
#                          Antigravity: ~/.gemini/config/skills/   Claude Code: ~/.claude/skills/
#   --workspace [DIR]    Install to workspace in DIR (Default: current directory)
#                          Antigravity: [DIR]/.agents/skills/      Claude Code: [DIR]/.claude/skills/
#   --plugin             Install globally as a plugin to ~/.gemini/config/plugins/ (Antigravity only)
#   --claude             Target Claude Code instead of Antigravity (also installs the /dotc alias skill)
# ==============================================================================

set -euo pipefail

# ANSI color codes
BOLD='\033[1m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

REPO_URL="https://github.com/roticagas/defense-of-the-code.git"
NAME="defense-of-the-code"
ALIAS_NAME="dotc"
ALIAS_MARKER="short alias of the **\`defense-of-the-code\`** skill"
PLATFORM="antigravity"
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
    --claude)
      PLATFORM="claude"
      shift
      ;;
    -h|--help)
      echo "Usage: install.sh [OPTIONS]"
      echo ""
      echo "Options:"
      echo "  --global             Install globally for all projects [Default]"
      echo "                         Antigravity: ~/.gemini/config/skills/   Claude Code: ~/.claude/skills/"
      echo "  --workspace [DIR]    Install to specific project workspace"
      echo "                         Antigravity: [DIR]/.agents/skills/      Claude Code: [DIR]/.claude/skills/"
      echo "  --plugin             Install globally as a plugin bundle (~/.gemini/config/plugins/, Antigravity only)"
      echo "  --claude             Target Claude Code instead of Antigravity (adds the /dotc alias skill)"
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

echo -e "${BOLD}${CYAN}"
echo "  🏰 Defense of the Code — Installer"
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
if [ "$PLATFORM" = "claude" ]; then
  if [ "$MODE" = "workspace_skill" ]; then
    TARGET_PARENT="${WORKSPACE_DIR}/.claude/skills"
  else
    TARGET_PARENT="${HOME}/.claude/skills"
  fi
elif [ "$MODE" = "global_skill" ]; then
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

# Claude Code registers one slash command per skill, so /dotc needs its own alias skill.
# It is generated (not symlinked) so the absolute path to the main skill is baked in.
if [ "$PLATFORM" = "claude" ]; then
  ALIAS_DIR="${TARGET_PARENT}/${ALIAS_NAME}"
  ALIAS_FILE="${ALIAS_DIR}/SKILL.md"
  TEMPLATE="${TARGET_DIR}/templates/claude-dotc-alias.md"
  if [ -e "${ALIAS_FILE}" ] && ! grep -qF "${ALIAS_MARKER}" "${ALIAS_FILE}"; then
    echo -e "${YELLOW}⚠️ '${ALIAS_FILE}' belongs to another skill. Skipping the /dotc alias.${NC}"
  else
    mkdir -p "${ALIAS_DIR}"
    ESCAPED_DIR="$(printf '%s' "${TARGET_DIR}" | sed 's/[&|\\]/\\&/g')"
    sed "s|{{SKILL_DIR}}|${ESCAPED_DIR}|g" "${TEMPLATE}" > "${ALIAS_FILE}"
    echo -e "${GREEN}✓ /dotc alias skill written to ${ALIAS_FILE}${NC}"
  fi
fi

echo ""
echo -e "${BOLD}${GREEN}🎉 Installation Complete!${NC}"
echo ""
if [ "$PLATFORM" = "claude" ]; then
  echo "How to use in Claude Code (start a new session to load the skill):"
else
  echo "How to use in Antigravity:"
fi
echo -e "  ${BOLD}/dotc ช่วยออกแบบ...${NC}                  (🔨 Top Lane: Architectural Blueprint — Elder Titan & 4 Plan Squads)"
echo -e "  ${BOLD}/dotc รีวิวโค้ดให้หน่อย${NC}              (🔮 Mid Lane: Standard Review — Oracle & 6 Review Squads)"
echo -e "  ${BOLD}/dotc รีวิวละเอียด ขอ fresh eyes${NC}      (🔮 Mid Lane: Deep Review via Parallel Squad Subagents)"
echo -e "  ${BOLD}/dotc เขียนเอกสาร / สรุป PR นี้ให้ที${NC}   (📖 Bot Lane: Documentation & Sync — Invoker & 3 Doc Squads)"
if [ "$PLATFORM" = "claude" ]; then
  echo -e "  ${CYAN}(หรือใช้คำสั่งเต็ม: ${BOLD}/defense-of-the-code${CYAN} — Claude Code ไม่มี /blueprint, /review, /doc)${NC}"
else
  echo -e "  ${CYAN}(หรือใช้คำสั่งเต็ม/ย่อ: ${BOLD}/defense-of-the-code${CYAN}, ${BOLD}/blueprint${CYAN}, ${BOLD}/review${CYAN}, ${BOLD}/review deep${CYAN}, ${BOLD}/doc${CYAN})${NC}"
fi
echo ""
