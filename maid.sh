#!/bin/sh
# maid — file trash and zsh history manager
# Usage: maid <command> [args]
set -e
MAID_TRASH="${MAID_TRASH:-$HOME/.Maid-Trash}"
MAID_DIR="$(cd "$(dirname "$(readlink -f "$0")")" && pwd)"
. "$MAID_DIR/lib-maid/trash.sh"
. "$MAID_DIR/lib-maid/history.sh"

_usage() {
  cat << EOF
maid -- file trash and zsh history manager

TRASH
  maid trash <file...>     move file(s) to ~/.Maid-Trash/
  maid restore <name>      restore to original path
  maid list                list trash contents
  maid empty               permanently delete all trash

HISTORY
  maid history dedup       deduplicate zsh history in-place
  maid history search      interactive fzf search over history
EOF
}

cmd="${1:-}"
[ -z "$cmd" ] && { _usage; exit 0; }
shift
case "$cmd" in
  trash)   maid_trash "$@" ;;
  restore) maid_restore "$@" ;;
  list)    maid_list ;;
  empty)   maid_empty ;;
  history)
    sub="${1:-}"; [ -z "$sub" ] && { _usage; exit 1; }; shift
    case "$sub" in
      dedup)  maid_history_dedup ;;
      search) maid_history_search ;;
      *) printf "maid history: unknown subcommand: %s
" "$sub" >&2; exit 1 ;;
    esac ;;
  *) printf "maid: unknown command: %s
" "$cmd" >&2; _usage; exit 1 ;;
esac
