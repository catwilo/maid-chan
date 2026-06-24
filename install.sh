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

# R9.9: copy lib-maid/ alongside the binary (never symlink). Required because
# maid.sh resolves MAID_DIR via readlink -f of its own copied path, which
# after atomic-copy install resolves to BIN_DIR, not MAID_DIR -- so lib-maid/
# must physically exist next to the installed binary. Namespaced (not lib/)
# to avoid collision with other tools (e.g. mkit) sharing ~/.local/bin.
LIB_SRC="$MAID_DIR/lib-maid"
LIB_DST="$BIN_DIR/lib-maid"
if [ -d "$LIB_SRC" ]; then
    mkdir -p "$LIB_DST"
    cp -RfL "$LIB_SRC"/. "$LIB_DST"/
    printf '  ok  installed: %s\n' "$LIB_DST"
fi

case ":$PATH:" in
  *":$BIN_DIR:"*) ;;
  *) printf '  !!  add to PATH: export PATH="%s:$PATH"\n' "$BIN_DIR" ;;
esac
