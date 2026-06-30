#!/bin/sh
# Stow dotfiles, choosing packages by OS.
# POSIX sh — runs under dash/ash/busybox/bash/zsh, no bash-only features.
# Usage: ./install.sh        # stow the right set for this machine
#        ./install.sh -n     # dry run (show what stow would do)
set -eu
cd "$(dirname "$0")"

DRY=""
[ "${1:-}" = "-n" ] && DRY="--no --verbose"

# Space-separated lists (POSIX sh has no arrays). Package names never contain spaces.
COMMON="nvim"
MACOS="skhd yabai sketchybar borders"
LINUX=""
WINDOWS=""

# $DRY and $pkgs are intentionally unquoted to word-split into separate args.
stow_pkgs() {
  for pkg in $1; do
    [ -d "$pkg" ] || continue
    echo "stow: $pkg"
    stow --restow --target="$HOME" $DRY "$pkg"
  done
}

os="$(uname -s)"
stow_pkgs "$COMMON"
case "$os" in
  Darwin)              stow_pkgs "$MACOS" ;;
  Linux)               stow_pkgs "$LINUX" ;;   # WSL also reports Linux
  MINGW*|MSYS*|CYGWIN*) stow_pkgs "$WINDOWS" ;;
  *)                   echo "Unknown OS: $os — only COMMON stowed" >&2 ;;
esac

echo "Done."
