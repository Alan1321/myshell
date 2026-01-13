# myshell

Shell setup script that replicates my terminal environment on any machine.

## What it installs

- Zsh + Oh-My-Zsh
- Powerlevel10k theme
- Modern CLI tools: eza, bat, zoxide, fzf, fd, ripgrep
- zsh-autosuggestions & zsh-syntax-highlighting

## Usage

```bash
git clone git@github.com:Alan1321/myshell.git
cd myshell
./setup.sh
```

After setup, run `p10k configure` to customize your prompt.

## Supported platforms

- macOS (Apple Silicon & Intel)
- Linux (Debian/Ubuntu)
- Raspberry Pi
