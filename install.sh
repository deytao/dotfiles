#!/bin/bash

set -e

DOTFILES="$HOME/dotfiles"
MACHINE=""
REMOVE=false
FORCE=false

for arg in "$@"; do
    case $arg in
        --machine=*) MACHINE="${arg#*=}" ;;
        --remove) REMOVE=true ;;
        --force) FORCE=true ;;
    esac
done

# --- Remove mode ---
if [[ "$REMOVE" == true ]]; then
    echo "==> Removing dotfile symlinks..."
    for path in \
        "$HOME/.zshrc" "$HOME/.gitconfig" "$HOME/.gitconfig.local" \
        "$HOME/.zsh_plugins.txt" "$HOME/.localrc" "$HOME/.psqlrc" \
        "$HOME/.pythonrc.py" "$HOME/.sbclrc" "$HOME/.tmux.conf" \
        "$HOME/.config/alacritty" "$HOME/.config/nvim" \
        "$HOME/.config/spaceship.zsh" "$HOME/.tmuxp" \
        "$HOME/.claude/CLAUDE.md" "$HOME/.claude/settings.json"; do
        [[ -L "$path" ]] && rip "$path" && echo "  removed $path"
    done
    echo "==> Done."
    exit 0
fi

if [[ -z "$MACHINE" ]]; then
    echo "Usage: $0 --machine=<name> [--force]"
    echo "       $0 --remove"
    echo "Available machines: $(ls "$DOTFILES/machines/")"
    exit 1
fi

if [[ ! -d "$DOTFILES/machines/$MACHINE" ]]; then
    echo "Machine '$MACHINE' not found in $DOTFILES/machines/"
    exit 1
fi

# Detect OS
if [[ -f /etc/arch-release ]]; then
    OS="arch"
elif [[ -f /etc/debian_version ]]; then
    OS="debian"
elif [[ "$(uname)" == "Darwin" ]]; then
    OS="osx"
else
    echo "Unsupported OS"
    exit 1
fi

pkg_install() {
    for item in "$@"; do
        case "$OS" in
            debian) sudo apt -y install "$item" ;;
            osx)    brew install "$item" ;;
            arch)   sudo pacman -S --noconfirm "$item" ;;
        esac
    done
}

yay_install() {
    for item in "$@"; do
        yay -S --noconfirm "$item"
    done
}

link() {
    local src=$1 dst=$2
    if [[ "$FORCE" == true ]] && [[ -e "$dst" ]] && [[ ! -L "$dst" ]]; then
        rip "$dst"
    fi
    [[ -L "$dst" ]] || ln -s "$src" "$dst"
}

echo "==> Setting up dotfiles for machine: $MACHINE (OS: $OS)"

# --- fzf ---
[[ ! -d "$DOTFILES/fzf" ]] && git clone --depth=1 https://github.com/junegunn/fzf.git "$DOTFILES/fzf"

# --- antidote ---
[[ -d "$HOME/.antidote" ]] || git clone --depth=1 https://github.com/mattmc3/antidote.git "$HOME/.antidote"

# --- uv ---
if ! command -v uv &>/dev/null; then
    curl -LsSf https://astral.sh/uv/install.sh | sh
fi

# --- claude code ---
if ! command -v claude &>/dev/null; then
    curl -fsSL https://claude.ai/install.sh | bash
fi

# --- tmux plugin manager ---
[[ ! -d "$HOME/.tmux/plugins/tpm" ]] && git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

# --- Common symlinks ---
link "$DOTFILES/common/zshrc"              "$HOME/.zshrc"
link "$DOTFILES/common/gitconfig"          "$HOME/.gitconfig"
link "$DOTFILES/common/zsh_plugins.txt"    "$HOME/.zsh_plugins.txt"
link "$DOTFILES/common/psqlrc"             "$HOME/.psqlrc"
link "$DOTFILES/common/pythonrc.py"        "$HOME/.pythonrc.py"
link "$DOTFILES/common/sbclrc"             "$HOME/.sbclrc"
link "$DOTFILES/common/tmux.conf"          "$HOME/.tmux.conf"
link "$DOTFILES/common/alacritty"          "$HOME/.config/alacritty"
link "$DOTFILES/common/nvim"               "$HOME/.config/nvim"
link "$DOTFILES/common/spaceship.zsh"      "$HOME/.config/spaceship.zsh"
link "$DOTFILES/common/claude/CLAUDE.md"   "$HOME/.claude/CLAUDE.md"

# --- Machine-specific symlinks ---
link "$DOTFILES/machines/$MACHINE/localrc" "$HOME/.localrc"
local_gitconfig="$DOTFILES/machines/$MACHINE/gitconfig.local"
if [[ ! -f "$local_gitconfig" ]]; then
    echo "==> Git identity not found for machine '$MACHINE'. Please fill in the following:"
    read -rp "    Git name:  " git_name
    read -rp "    Git email: " git_email

    git_signingkey=""
    if command -v gpg &>/dev/null; then
        mapfile -t gpg_key_ids < <(gpg --list-secret-keys --keyid-format LONG 2>/dev/null | grep "^sec" | awk '{print $2}' | cut -d'/' -f2)
        if [[ ${#gpg_key_ids[@]} -gt 0 ]]; then
            echo "    Available GPG keys:"
            for i in "${!gpg_key_ids[@]}"; do
                uid=$(gpg --list-secret-keys "${gpg_key_ids[$i]}" 2>/dev/null | grep "^uid" | head -1 | sed 's/uid[[:space:]]*\[.*\][[:space:]]*//')
                echo "      $((i+1))) ${gpg_key_ids[$i]}  $uid"
            done
            echo "      0) Skip"
            read -rp "    Pick a key [0-${#gpg_key_ids[@]}]: " key_choice
            if [[ "$key_choice" =~ ^[1-9][0-9]*$ ]] && (( key_choice <= ${#gpg_key_ids[@]} )); then
                git_signingkey="${gpg_key_ids[$((key_choice-1))]}"
            fi
        fi
    fi

    {
        echo "[user]"
        echo "    name = $git_name"
        echo "    email = $git_email"
        [[ -n "$git_signingkey" ]] && echo "    signingKey = $git_signingkey"
    } > "$local_gitconfig"
    echo "==> Created $local_gitconfig"
fi
link "$local_gitconfig" "$HOME/.gitconfig.local"
[[ -d "$DOTFILES/machines/$MACHINE/tmuxp" ]] && \
    link "$DOTFILES/machines/$MACHINE/tmuxp" "$HOME/.tmuxp"
[[ -f "$DOTFILES/machines/$MACHINE/claude/settings.json" ]] && \
    link "$DOTFILES/machines/$MACHINE/claude/settings.json" "$HOME/.claude/settings.json"

# --- fzf ---
"$DOTFILES/fzf/install" --all

# --- Common packages ---
pkg_install \
    alacritty \
    bat \
    bison \
    fakeroot \
    gcc \
    httpie \
    make \
    patch \
    ripgrep \
    tmux \
    tmuxp \
    wl-clipboard \
    neovim

yay_install \
    fd \
    git-absorb \
    git-delta \
    ttf-fira-code

# --- Machine-specific packages ---
if [[ "$MACHINE" == "arcanite" ]]; then
    pkg_install \
        networkmanager-openvpn \
        smartmontools \
        tlp \
        tlpui

    yay_install \
        glab \
        mattermost \
        pgadmin4-desktop
fi

# --- Shell ---
sudo chsh -s "$(which zsh)" "$USER"

echo "==> Done. Open a new shell to apply changes."
