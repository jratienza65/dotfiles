# OPENSPEC:START
# OpenSpec shell completions configuration
if [ -d "/home/jonas/.local/share/bash-completion/completions" ]; then
  for f in "/home/jonas/.local/share/bash-completion/completions"/*; do
    [ -f "$f" ] && . "$f"
  done
fi
# OPENSPEC:END

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# --- Aliases / prompt ---
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

# --- PATH ---
export PATH="$PATH:/opt/kongctl"
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# --- Machine-local secrets + aliases (untracked, per-machine) ---
[[ -f ~/.env ]] && . ~/.env
[[ -f ~/.aliases ]] && . ~/.aliases

# --- Tool activations (guarded so a missing tool stays quiet) ---
command -v mise     >/dev/null && eval "$(mise activate bash)"
command -v luarocks >/dev/null && eval "$(luarocks path --bin)"
command -v starship >/dev/null && eval "$(starship init bash --print-full-init)"  # prompt — keep last
