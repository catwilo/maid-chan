# maid

File trash and zsh history manager for terminal workflows.

## Commands

### Trash
```sh
maid trash <file...>   # move to ~/.Maid-Trash/
maid restore <name>    # restore to original path
maid list              # list trash contents
maid empty             # permanently delete all trash
```

### History
```sh
maid history dedup     # deduplicate zsh history in-place
maid history search    # fzf search over history
```

## Trash format
Each trashed file gets a `.tenshi-sama` companion with the original path,
enabling safe restore even after renames or moves.

## Config
- `MAID_TRASH` — override trash location (default: `~/.Maid-Trash`)
- `HISTFILE` — zsh history file (default: `~/.zsh_history`)
