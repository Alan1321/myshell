# =============================================================================
# MyShell - Zsh Configuration
# =============================================================================

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# =============================================================================
# Oh-My-Zsh Configuration
# =============================================================================

export ZSH="$HOME/.oh-my-zsh"

# Theme (powerlevel10k is sourced separately at the bottom)
ZSH_THEME=""

# Plugins
plugins=(git)

source $ZSH/oh-my-zsh.sh

# =============================================================================
# Powerlevel10k
# =============================================================================

source ~/powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# =============================================================================
# Modern CLI Tools & Aliases
# =============================================================================

# eza - better ls with icons and git status
alias ls="eza --icons"
alias ll="eza -la --icons --git"
alias la="eza -a --icons"
alias lt="eza --tree --icons --level=2"

# bat - better cat with syntax highlighting
alias cat="bat --paging=never"
alias catp="bat"  # with paging

# zoxide - smarter cd that learns your habits
eval "$(zoxide init zsh)"
alias cd="z"

# fzf - fuzzy finder (Ctrl+R for history search)
source <(fzf --zsh)

# fd - better find
alias find="fd"

# ripgrep - better grep
alias grep="rg"

# =============================================================================
# Zsh Plugins
# =============================================================================

# Determine plugin path based on OS
if [[ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    # macOS with Homebrew (Apple Silicon)
    source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    # macOS with Homebrew (Intel)
    source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
    # Debian/Ubuntu/RPi (apt installed)
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# =============================================================================
# Custom Aliases & Functions
# Add your custom aliases below
# =============================================================================

