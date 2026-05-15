#!/usr/bin/env bash
set -euo pipefail

REPO="https://raw.githubusercontent.com/procloudify/gt/main"
INSTALL_DIR="/usr/local/bin"
BIN="gt"

RED='\033[0;31m'; GREEN='\033[0;32m'; CYAN='\033[0;36m'
YELLOW='\033[1;33m'; BOLD='\033[1m'; DIM='\033[2m'; RESET='\033[0m'

ok()   { echo -e "${GREEN}✓${RESET} $*"; }
info() { echo -e "${CYAN}→${RESET} $*"; }
warn() { echo -e "${YELLOW}!${RESET} $*"; }
die()  { echo -e "${RED}✗${RESET} $*" >&2; exit 1; }

echo ""
echo -e "${BOLD}${CYAN}"
echo "   ██████╗ ████████╗"
echo "  ██╔════╝╚══██╔══╝ "
echo "  ██║  ███╗  ██║    "
echo "  ██║   ██║  ██║    "
echo "  ╚██████╔╝  ██║    "
echo "   ╚═════╝   ╚═╝    "
echo -e "${RESET}"
echo -e "  ${BOLD}gt${RESET} — simple git flow CLI"
echo -e "  ${DIM}Built by Pro Cloudify · github.com/procloudify/gt${RESET}"
echo -e "  ${DIM}Open source · MIT License · Contributions welcome${RESET}"
echo ""
echo -e "${DIM}  ──────────────────────────────────────────────${RESET}"
echo ""

OS="$(uname -s)"
case "$OS" in
  Darwin)               PLATFORM="mac" ;;
  Linux)                PLATFORM="linux" ;;
  MINGW*|MSYS*|CYGWIN*) PLATFORM="windows" ;;
  *) die "Unsupported OS: $OS" ;;
esac

info "Platform: ${BOLD}$PLATFORM${RESET}"

if [ "$PLATFORM" = "windows" ]; then
  INSTALL_DIR="$HOME/.local/bin"
elif [ ! -w "$INSTALL_DIR" ]; then
  INSTALL_DIR="$HOME/.local/bin"
fi

mkdir -p "$INSTALL_DIR"

info "Downloading gt..."
if command -v curl &>/dev/null; then
  curl -fsSL "$REPO/bin/gt" -o "$INSTALL_DIR/$BIN"
elif command -v wget &>/dev/null; then
  wget -qO "$INSTALL_DIR/$BIN" "$REPO/bin/gt"
else
  die "curl or wget is required."
fi

chmod +x "$INSTALL_DIR/$BIN"

if ! echo "$PATH" | grep -q "$INSTALL_DIR"; then
  SHELL_RC=""
  case "${SHELL:-}" in
    */zsh)  SHELL_RC="$HOME/.zshrc" ;;
    */bash) SHELL_RC="$HOME/.bashrc" ;;
    */fish) SHELL_RC="$HOME/.config/fish/config.fish" ;;
  esac
  if [ -n "$SHELL_RC" ]; then
    echo "export PATH=\"$INSTALL_DIR:\$PATH\"" >> "$SHELL_RC"
    warn "Added $INSTALL_DIR to PATH in $SHELL_RC"
    warn "Run: source $SHELL_RC  or open a new terminal"
  else
    warn "Add ${BOLD}$INSTALL_DIR${RESET} to your PATH manually."
  fi
fi

echo ""
ok "${BOLD}gt installed!${RESET}  →  $INSTALL_DIR/$BIN"
echo ""
echo -e "  ${BOLD}Get started:${RESET}"
echo -e "  ${CYAN}gt help${RESET}          show all commands"
echo -e "  ${CYAN}gt init${RESET}          init a project"
echo -e "  ${CYAN}gt push${RESET}          bump version + push main"
echo ""
echo -e "  ${DIM}Contribute: github.com/procloudify/gt${RESET}"
echo ""
