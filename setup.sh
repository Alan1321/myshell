#!/bin/bash

echo "======================================"
echo "       MyShell Setup Script"
echo "======================================"
echo ""

# Detect OS
OS="$(uname -s)"
case "$OS" in
    Linux*)     PLATFORM="linux";;
    Darwin*)    PLATFORM="mac";;
    *)          echo "Unsupported OS: $OS"; exit 1;;
esac

echo "Detected platform: $PLATFORM"
echo ""

# =============================================================================
# Install Homebrew (macOS only)
# =============================================================================

install_homebrew() {
    if [[ "$PLATFORM" != "mac" ]]; then
        return
    fi

    if ! command -v brew &> /dev/null; then
        echo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo "Homebrew already installed."
    fi
}

# =============================================================================
# Install Zsh
# =============================================================================

install_zsh() {
    if ! command -v zsh &> /dev/null; then
        echo "Installing Zsh..."
        if [[ "$PLATFORM" == "mac" ]]; then
            brew install zsh
        else
            sudo apt-get update && sudo apt-get install -y zsh
        fi
    else
        echo "Zsh already installed."
    fi
}

# =============================================================================
# Install Oh-My-Zsh
# =============================================================================

install_ohmyzsh() {
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        echo "Installing Oh-My-Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo "Oh-My-Zsh already installed."
    fi
}

# =============================================================================
# Install Powerlevel10k
# =============================================================================

install_p10k() {
    if [[ ! -d "$HOME/powerlevel10k" ]]; then
        echo "Installing Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
    else
        echo "Powerlevel10k already installed."
    fi
}

# =============================================================================
# Install Zsh Plugins (autosuggestions & syntax-highlighting)
# =============================================================================

install_zsh_plugins() {
    echo "Installing zsh plugins..."

    if [[ "$PLATFORM" == "mac" ]]; then
        brew install zsh-autosuggestions zsh-syntax-highlighting 2>/dev/null || true
    else
        sudo apt-get install -y zsh-autosuggestions zsh-syntax-highlighting 2>/dev/null || true
    fi
}

# =============================================================================
# Install CLI Tools (optional - skip if unavailable)
# =============================================================================

install_cli_tools() {
    echo "Installing CLI tools..."

    if [[ "$PLATFORM" == "mac" ]]; then
        for tool in eza bat zoxide fzf fd ripgrep; do
            brew install "$tool" &>/dev/null || true
        done
    else
        sudo apt-get install -y bat zoxide fzf fd-find ripgrep eza &>/dev/null || true

        # Symlinks for Debian naming
        command -v fdfind &>/dev/null && sudo ln -sf "$(which fdfind)" /usr/local/bin/fd &>/dev/null || true
        command -v batcat &>/dev/null && sudo ln -sf "$(which batcat)" /usr/local/bin/bat &>/dev/null || true
    fi
}

# =============================================================================
# Setup .zshrc
# =============================================================================

setup_zshrc() {
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

    if [[ -f "$HOME/.zshrc" ]]; then
        echo "Backing up existing .zshrc to .zshrc.backup"
        cp "$HOME/.zshrc" "$HOME/.zshrc.backup"
    fi

    echo "Installing .zshrc..."
    cp "$SCRIPT_DIR/zshrc" "$HOME/.zshrc"

    if [[ -f "$SCRIPT_DIR/p10k.zsh" ]]; then
        echo "Installing p10k config..."
        cp "$SCRIPT_DIR/p10k.zsh" "$HOME/.p10k.zsh"
    fi
}

# =============================================================================
# Install fonts
# =============================================================================

install_fonts() {
    echo "Installing MesloLGS NF fonts..."

    if [[ "$PLATFORM" == "mac" ]]; then
        FONT_DIR="$HOME/Library/Fonts"
    else
        FONT_DIR="$HOME/.local/share/fonts"
        mkdir -p "$FONT_DIR"
    fi

    FONTS=(
        "MesloLGS%20NF%20Regular.ttf"
        "MesloLGS%20NF%20Bold.ttf"
        "MesloLGS%20NF%20Italic.ttf"
        "MesloLGS%20NF%20Bold%20Italic.ttf"
    )

    for font in "${FONTS[@]}"; do
        curl -fsSL "https://github.com/romkatv/powerlevel10k-media/raw/master/$font" -o "$FONT_DIR/$(echo $font | sed 's/%20/ /g')"
    done

    # Refresh font cache on Linux
    if [[ "$PLATFORM" == "linux" ]]; then
        fc-cache -f &>/dev/null || true
    fi
}

# =============================================================================
# Set Zsh as default shell
# =============================================================================

set_default_shell() {
    if [[ "$SHELL" != *"zsh"* ]]; then
        echo "Setting Zsh as default shell..."
        chsh -s "$(which zsh)" &>/dev/null || true
    else
        echo "Zsh is already the default shell."
    fi
}

# =============================================================================
# Main
# =============================================================================

main() {
    install_homebrew
    echo ""
    install_zsh
    echo ""
    install_ohmyzsh
    echo ""
    install_p10k
    echo ""
    install_zsh_plugins
    echo ""
    install_cli_tools
    echo ""
    setup_zshrc
    echo ""
    install_fonts
    echo ""
    set_default_shell

    echo ""
    echo "======================================"
    echo "        Setup Complete!"
    echo "======================================"
    echo ""
    echo "Next steps:"
    echo "  1. Restart your terminal (or run: exec zsh)"
    echo "  2. Run 'p10k configure' to customize your prompt"
    echo "  3. Set your terminal font to 'MesloLGS NF'"
    echo ""
}

main "$@"
