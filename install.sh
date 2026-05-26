#!/bin/sh
# install.sh — symlink maid into ~/.local/bin (idempotent)
set -eu

MAID_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$HOME/.local/bin"
TARGET="$BIN_DIR/maid"

mkdir -p "$BIN_DIR"
chmod +x "$MAID_DIR/maid.sh"

if [ -L "$TARGET" ] && [ "$(readlink "$TARGET")" = "$MAID_DIR/maid.sh" ]; then
  printf '  ok  already installed: %s\n' "$TARGET"
else
  ln -sf "$MAID_DIR/maid.sh" "$TARGET"
  printf '  ok  installed: %s -> %s\n' "$TARGET" "$MAID_DIR/maid.sh"
fi

case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *) printf '  !!  add to PATH: export PATH="%s:$PATH"\n' "$BIN_DIR" ;;
esac
