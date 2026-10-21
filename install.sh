#!/bin/sh
set -eu

MAID_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$HOME/.local/bin"
TARGET="$BIN_DIR/maid"

mkdir -p "$BIN_DIR"
chmod +x "$MAID_DIR/maid.sh"

# Symlink, never copy: installers link repo binaries. maid.sh resolves
# MAID_DIR via readlink -f of its own path, so the symlink resolves back
# into this repo and lib-maid/ is found in place -- no separate copy of
# the libs is needed or wanted.
rm -f "$TARGET"
ln -s "$MAID_DIR/maid.sh" "$TARGET"
printf '  ok  linked: %s -> %s\n' "$TARGET" "$MAID_DIR/maid.sh"

case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *) printf '  !!  add to PATH: export PATH="%s:$PATH"\n' "$BIN_DIR" ;;
esac
