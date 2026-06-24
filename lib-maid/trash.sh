# trash.sh -- trash/restore/list/empty
# Requires: MAID_TRASH
_TENSHI=".tenshi-sama"

maid_trash() {
  [ $# -eq 0 ] && { echo "maid trash: specify file(s)" >&2; return 1; }
  mkdir -p "$MAID_TRASH"
  for f in "$@"; do
    [ -e "$f" ] || { printf "maid trash: not found: %s
" "$f" >&2; continue; }
    orig="$(realpath "$f")"
    name="$(basename "$f")"
    dest="$MAID_TRASH/$name"
    n=1
    while [ -e "$dest" ] || [ -e "${dest}${_TENSHI}" ]; do
      dest="$MAID_TRASH/${name}.${n}"; n=$((n+1))
    done
    mv "$orig" "$dest"
    printf "%s" "$orig" > "${dest}${_TENSHI}"
    printf "  ok  trashed: %s
" "$name"
  done
}

maid_restore() {
  [ $# -eq 0 ] && { echo "maid restore: specify filename" >&2; return 1; }
  src="$MAID_TRASH/$1"
  meta="${src}${_TENSHI}"
  [ -e "$src" ] || { printf "maid restore: not in trash: %s
" "$1" >&2; return 1; }
  [ -f "$meta" ] || { printf "maid restore: no metadata for: %s
" "$1" >&2; return 1; }
  orig="$(cat "$meta")"
  mkdir -p "$(dirname "$orig")"
  mv "$src" "$orig"
  rm -f "$meta"
  printf "  ok  restored: %s -> %s
" "$1" "$orig"
}

maid_list() {
  [ -d "$MAID_TRASH" ] || { echo "  (trash empty)"; return 0; }
  count=0
  for meta in "$MAID_TRASH/"*; do
    case "$meta" in *"${_TENSHI}") continue ;; esac
    [ -e "$meta" ] || continue
    name="$(basename "$meta")"
    orig=""
    [ -f "${meta}${_TENSHI}" ] && orig="$(cat "${meta}${_TENSHI}")"
    printf "  %-32s  <- %s
" "$name" "$orig"
    count=$((count+1))
  done
  [ "$count" -eq 0 ] && echo "  (trash empty)"
}

maid_empty() {
  [ -d "$MAID_TRASH" ] || { echo "  (trash already empty)"; return 0; }
  printf "Empty trash permanently? [y/N] "
  read -r ans
  case "$ans" in
    y|Y) rm -rf "$MAID_TRASH" && mkdir -p "$MAID_TRASH" && echo "  ok  trash emptied" ;;
    *)   echo "  aborted" ;;
  esac
}
