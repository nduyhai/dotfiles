# Dotfiles

Opinionated macOS dotfiles with a simple bootstrap, install flow.

## Table of contents

- [Install development tools](#install-development-tools)
    - [Homebrew](#homebrew)
    - [Developer tools](#developer-tools)
    - [Check manual installs](#check-manual-installs)
- [Install dotfiles](#install-dotfiles)
- [Doctor](#doctor)
- [Uninstall](#uninstall)
- [Git config](#git-config)
    - [Extra local config](#extra-local-config)
    - [Verify Git config](#verify-git-config)

## Install development tools

### Homebrew

Follow the official guide: <https://docs.brew.sh/Installation>


### Developer tools

```bash
xcode-select --install                 # Install Xcode Command Line Tools
brew install --cask iterm2             # iTerm2
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

# Other utilities
brew install glow       # Markdown viewer
brew install lazydocker # Docker UI
brew install stern      # Tail multiple Kubernetes pods & their containers
brew install tmux       # Terminal multiplexer
brew install fd         # Alternative to find
brew install wrk        # Benchmarking tool
brew install k9s        # Kubernetes terminal UI
brew install colima     # Container runtimes

# SDKMAN
curl -s "https://get.sdkman.io" | zsh

```

### Check manual installs

```bash
brew leaves
```

## Install dotfiles

```bash
mkdir -p ~/workspace
cd ~/workspace
git clone https://github.com/nduyhai/dotfiles.git
```

```bash
bootstrap
cd ~/workspace/dotfiles
chmod +x scripts/bootstrap.sh
make bootstrap

```

```bash
cd ~/workspace/dotfiles
chmod +x scripts/install.sh
make install
```

## Doctor

```bash
cd dotfiles
chmod +x scripts/doctor.sh
make doctor
```

## Uninstall

```bash
cd ~/workspace/dotfiles
chmod +x scripts/uninstall.sh
make uninstall

```

## Git config

### Extra local config

`.gitconfig.local`

```
[user]
    name = nduyhai
    email = nduyhai@mycompany

[includeIf "gitdir:~/workspace/"]
    path = ~/.gitconfig-personal

[includeIf "gitdir:~/mycompany/"]
    path = ~/.gitconfig-mycompany

[include]
    path = ~/.main.gitconfig

[url "git@git.mycompany.vn:"]
	insteadOf = https://git.mycompany.vn/
```

`.gitconfig-personal`

```
[user]
    name = nduyhai
    email = nduyhai@users.noreply.github.com
```

`.gitconfig-mycompany`

```
[user]
    name = nduyhai
    email = nduyhai@mycompany.com
```

### Verify Git config

```bash 
cd ~/workspace/some-repo && git config --show-origin user.email
cd ~/mycompany/some-repo && git config --show-origin user.email

```

