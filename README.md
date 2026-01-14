# myshell

Shell setup script that replicates my terminal environment on any machine.

## What it installs

- Zsh + Oh-My-Zsh
- Powerlevel10k theme
- Modern CLI tools: eza, bat, zoxide, fzf, fd, ripgrep
- zsh-autosuggestions & zsh-syntax-highlighting

## Usage

```bash
git clone git@github.com:Alan1321/myshell.git ~/myshell
cd ~/myshell
./setup.sh
```

Add this to your `~/.bashrc` to auto-switch to zsh on login:

```bash
source ~/myshell/auto-zsh.sh
```

Then run `source ~/.bashrc` or log out and back in.

## Supported platforms

- macOS (Apple Silicon & Intel)
- Linux (Debian/Ubuntu)
- Raspberry Pi
