# dotfiles

## Install development tool

### Home brew

https://docs.brew.sh/Installation

### Developer tools

```bash
xcode-select --install                 # Install Xcode Command Line Tools
brew install --cask iterm2             #Iterm2
brew install git                       # Git
brew install --cask visual-studio-code # VS Code
brew install --cask docker             # Docker
brew install --cask jetbrains-toolbox  # JetBrains Toolbox
brew install tree                      # Directory tree
brew install fzf                       # Fuzzy finder
brew install ripgrep                   # Better grep
brew install tldr                      # Simplified man pages
brew install gh                        # GitHub CLI
brew install jq                        # JSON processor
brew install htop                      # Process viewer

# Cloud platform CLIs
brew install awscli
brew install azure-cli
brew install google-cloud-sdk

# SDK Man
curl -s "https://get.sdkman.io" | zsh

```

## Install dotfile

```bash
mkdir ~/workspace
cd workspace
git clone https://github.com/nduyhai/dotfiles.git
```

```bash
cd dotfiles
chmod +x scripts/install.sh
make install
```

## Uninstall

```bash
cd dotfiles
chmod +x scripts/uninstall.sh
make uninstall

```

