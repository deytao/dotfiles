#!/usr/bin/env zsh

DOTFILES="$HOME/dotfiles"
LOG="$HOME/.dotfiles_update.log"
[[ -t 1 ]] && INTERACTIVE=true || INTERACTIVE=false

log() {
    echo "[$(date '+%Y-%m-%d %H:%M')] $*" >> "$LOG"
    $INTERACTIVE && echo "$*"
}

try() {
    local label=$1; shift
    if "$@" >> "$LOG" 2>&1; then
        log "$label: ok"
    else
        log "$label: failed"
    fi
}

log "--- update started ---"

# dotfiles
cd "$DOTFILES" || exit 1
try "dotfiles" git pull --rebase

# antidote (self)
try "antidote" git -C "$HOME/.antidote" pull --rebase

# antidote plugins
source "$HOME/.antidote/antidote.zsh"
try "antidote plugins" antidote update

# fzf (shallow clone — fetch + reset instead of pull --rebase)
try "fzf" git -C "$DOTFILES/fzf" fetch --depth=1 origin
git -C "$DOTFILES/fzf" reset --hard origin/HEAD >> "$LOG" 2>&1
try "fzf install" "$DOTFILES/fzf/install" --bin

# uv
try "uv" uv self update

# tmux plugins
try "tmux plugins" "$HOME/.tmux/plugins/tpm/bin/update_plugins" all

# neovim lazy plugins
try "neovim" nvim --headless -c "Lazy! sync" -c "qa"

# wipe completions so they regenerate on next shell open
[[ -d "$HOME/.zfunc" ]] && rip "$HOME/.zfunc" >> "$LOG" 2>&1 && log "completions: cleared"

# commit and push any updated lock files
cd "$DOTFILES"
git add common/nvim/lazy-lock.json >> "$LOG" 2>&1
if ! git diff --cached --quiet; then
    try "commit lock files" git commit -m "chore: update lock files"
    try "push" git push origin main
else
    log "lock files: no changes"
fi

date +%s > "$HOME/.dotfiles_last_update"
log "--- done ---"
