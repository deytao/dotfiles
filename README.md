# dotfiles

Personal dotfiles for Arch/Manjaro Linux. Organized into shared config and per-machine profiles.

## Structure

```
dotfiles/
├── common/          # Applied on every machine
│   ├── zshrc
│   ├── gitconfig    # No identity — loaded from ~/.gitconfig.local
│   ├── nvim/
│   ├── alacritty/
│   ├── tmux.conf
│   ├── zsh_plugins.txt
│   ├── spaceship.zsh
│   └── ...
├── machines/
│   ├── arcanite/    # Work laptop
│   │   ├── localrc
│   │   ├── gitconfig.local
│   │   └── tmuxp/
│   └── personal/    # Personal laptop
│       ├── localrc
│       └── gitconfig.local
├── fzf/             # Submodule
├── install.sh
└── remove.sh
```

## Setup

```bash
git clone git@github.com:deytao/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh --machine=arcanite   # or --machine=personal
```

`install.sh` will:
1. Auto-detect the OS (Arch, Debian, macOS)
2. Symlink `common/` configs to `~/.*`
3. Symlink the machine profile's `localrc`, `gitconfig.local`, and `tmuxp/`
4. Install common and machine-specific packages
5. Set up pyenv, tmux plugin manager, and fzf

## Adding a new machine

1. Create `machines/<name>/localrc` with machine-specific env vars and paths
2. Create `machines/<name>/gitconfig.local` with your git identity
3. Run `./install.sh --machine=<name>`

## Stack

- **Shell**: zsh + [Antidote](https://github.com/mattmc3/antidote) + [Spaceship prompt](https://spaceship-prompt.sh)
- **Terminal**: [Alacritty](https://alacritty.org) with tmux auto-attach
- **Editor**: [Neovim](https://neovim.io) (lazy.nvim, LSP, Copilot, Claude Code)
- **Multiplexer**: [tmux](https://github.com/tmux/tmux) with [tmuxp](https://github.com/tmux-python/tmuxp) session layouts
- **Git**: delta pager, GPG signing, fzf-powered aliases
- **Python**: pyenv + pyenv-virtualenv
