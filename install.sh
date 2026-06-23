#!/bin/sh
set -eu

MAID_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$HOME/.local/bin"
TARGET="$BIN_DIR/maid"

mkdir -p "$BIN_DIR"
chmod +x "$MAID_DIR/maid.sh"

_install_atomic() {
    local src="$1" dst="$2"
    local dstdir tmp
    dstdir="$(dirname "$dst")"
    mkdir -p "$dstdir"
    tmp="$(mktemp -d "$dstdir/.maid-tmp.XXXXXX")/maid"
    if cp -f "$src" "$tmp"; then
        chmod +x "$tmp"
        rm -f "$dst"
        mv -f "$tmp" "$dst" && printf '  ok  installed: %s\n' "$dst" || { printf '  ERROR: mv failed\n' >&2; exit 1; }
    else
        printf '  ERROR: cp failed\n' >&2; exit 1
    fi
    rm -rf "$(dirname "$tmp")" 2>/dev/null || true
}

_install_atomic "$MAID_DIR/maid.sh" "$TARGET"

case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *) printf '  !!  add to PATH: export PATH="%s:$PATH"\n' "$BIN_DIR" ;;
esac
