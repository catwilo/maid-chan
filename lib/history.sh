# history.sh -- zsh history dedup and fzf search

maid_history_dedup() {
  hfile="${HISTFILE:-$HOME/.zsh_history}"
  [ -f "$hfile" ] || { printf "maid history: HISTFILE not found: %s
" "$hfile" >&2; return 1; }
  cp "$hfile" "${hfile}.bak"
  cp "$hfile" "${hfile}.bak"
  tmp="$(mktemp)"
  awk '
    /^: [0-9]+:[0-9]+;/ { cmd = substr($0, index($0,";")+1) }
    !/^: [0-9]+:[0-9]+;/ { cmd = $0 }
    { lines[NR] = $0; keys[NR] = cmd }
    END {
      for (i=1; i<=NR; i++) last[keys[i]] = i
      for (i=1; i<=NR; i++) if (last[keys[i]] == i) print lines[i]
    }
  ' "$hfile" > "$tmp"
  before="$(wc -l < "$hfile")"
  after="$(wc -l < "$tmp")"
  cp "$tmp" "$hfile"; rm "$tmp"
  printf "  ok  deduped: %s -> %s lines (removed %s duplicates)
" \
    "$before" "$after" "$((before-after))"
}

maid_history_search() {
  command -v fzf >/dev/null 2>&1 || { echo "maid history: fzf not found" >&2; return 1; }
  hfile="${HISTFILE:-$HOME/.zsh_history}"
  [ -f "$hfile" ] || { printf "maid history: HISTFILE not found: %s
" "$hfile" >&2; return 1; }
  awk '/^: [0-9]+:[0-9]+;/ { print substr($0, index($0,";")+1) }
       !/^: [0-9]+:[0-9]+;/ { print }' "$hfile" \
    | sort -u \
    | fzf --tac --no-sort --height=40% --prompt="history> "
}
