#!/bin/bash

set -e

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
# Install Modern CLI Tools
# =============================================================================

install_cli_tools() {
    echo "Installing modern CLI tools..."

    if [[ "$PLATFORM" == "mac" ]]; then
        TOOLS=(
            "eza"
            "bat"
            "zoxide"
            "fzf"
            "fd"
            "ripgrep"
            "zsh-autosuggestions"
            "zsh-syntax-highlighting"
        )

        for tool in "${TOOLS[@]}"; do
            if ! brew list "$tool" &> /dev/null; then
                echo "  Installing $tool..."
                brew install "$tool"
            else
                echo "  $tool already installed."
            fi
        done
    else
        # Linux (Debian/Ubuntu/RPi)
        sudo apt-get update
        sudo apt-get install -y \
            eza \
            bat \
            zoxide \
            fzf \
            fd-find \
            ripgrep \
            zsh-autosuggestions \
            zsh-syntax-highlighting

        # fd is named fd-find on Debian, create symlink
        if [[ ! -L /usr/local/bin/fd ]] && command -v fdfind &> /dev/null; then
            sudo ln -sf "$(which fdfind)" /usr/local/bin/fd
        fi

        # bat is named batcat on Debian, create symlink
        if [[ ! -L /usr/local/bin/bat ]] && command -v batcat &> /dev/null; then
            sudo ln -sf "$(which batcat)" /usr/local/bin/bat
        fi
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
}

# =============================================================================
# Set Zsh as default shell
# =============================================================================

set_default_shell() {
    if [[ "$SHELL" != *"zsh"* ]]; then
        echo "Setting Zsh as default shell..."
        chsh -s "$(which zsh)"
    else
        echo "Zsh is already the default shell."
    fi
}

# =============================================================================
# Install recommended fonts (for Powerlevel10k icons)
# =============================================================================

install_fonts() {
    echo ""
    read -p "Install MesloLGS NF fonts for Powerlevel10k? (y/n): " install_fonts
    if [[ "$install_fonts" == "y" || "$install_fonts" == "Y" ]]; then
        echo "Installing MesloLGS NF fonts..."

        FONT_DIR=""
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

        if [[ "$PLATFORM" == "linux" ]]; then
            fc-cache -fv
        fi

        echo "Fonts installed! Set your terminal font to 'MesloLGS NF'"
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
