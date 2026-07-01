# OPENSPEC:START
# OpenSpec shell completions configuration
fpath=("$HOME/.zsh/completions" $fpath)
autoload -Uz compinit
compinit
# OPENSPEC:END

# --- Functions ---
timestamp() {
    date +"%Y%m%d%H%M"
}

# --- macOS only (Homebrew lives in /opt/homebrew) ---
if [[ "$OSTYPE" == darwin* ]]; then
  # Terraform bash-style completion (Homebrew binary)
  autoload -U +X bashcompinit && bashcompinit
  complete -o nospace -C /opt/homebrew/bin/terraform terraform

  export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
fi

# --- PATH / env (machine paths use $HOME so they're portable; missing dirs are harmless) ---
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/development/flutter/bin:$PATH"
export PATH="$HOME/.codeium/windsurf/bin:$PATH"          # Windsurf
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"   # Antigravity
export PATH="$PATH:/opt/kongctl:/opt/bffs"

export GOOGLE_APPLICATION_CREDENTIALS="$HOME/Creatizens/dev/devtools/services/firebase.credentials.dev.json"
export VAULT_ADDR="https://secrets.psmnd.dev"

# --- pnpm ---
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Docker CLI completions
if [ -d "$HOME/.docker/completions" ]; then
  fpath=("$HOME/.docker/completions" $fpath)
  autoload -Uz compinit && compinit
fi

# --- Tool activations (guarded so a missing tool on Linux stays quiet) ---
command -v mise     >/dev/null && eval "$(mise activate zsh)"
command -v ng       >/dev/null && source <(ng completion script)

# --- Aliases (guarded so they no-op when the tool isn't installed) ---
command -v nvim >/dev/null && alias vi=nvim vim=nvim
if command -v eza >/dev/null; then
  alias ls="eza -l"    # eza is a better ls
  alias la="eza -la"
fi

command -v starship >/dev/null && eval "$(starship init zsh)"   # prompt — keep last
