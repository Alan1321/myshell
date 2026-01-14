#!/usr/bin/env bash

# Only run in interactive terminals
if [[ -t 1 ]]; then
  # Only run if zsh exists
  if command -v zsh >/dev/null 2>&1; then
    # Only run if we are not already in zsh
    if [[ -z "$ZSH_VERSION" ]]; then
      exec zsh
    fi
  fi
fi