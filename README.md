# dotfiles

## Install development tool

### Home brew

https://docs.brew.sh/Installation

### Developer tools

```bash
xcode-select --install                 # Install Xcode Command Line Tools
brew install --cask iterm2             # Iterm2
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

# Another's
brew install glow       # Markdown
brew install lazydocker # Dokcer UI
brew install stern      # Tail multiple Kubernetes pods & their containers
brew install tmux       # Terminal multiplexer
brew install fd         # Alternative to find
brew install wrk        # Benchmarking tool
brew install k9s        # K9s
brew install colima     # Container runtimes

# SDK Man
curl -s "https://get.sdkman.io" | zsh

```

### How to check which ones you installed manually

```bash
brew leaves
```

## Install dotfile

```bash
mkdir ~/workspace
cd workspace
git clone https://github.com/nduyhai/dotfiles.git
```
```bash
bootstrap
cd dotfiles
chmod +x scripts/bootstrap.sh
make bootstrap

```
```bash
cd dotfiles
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
cd dotfiles
chmod +x scripts/uninstall.sh
make uninstall

```


## Git config

### Extra local config 

.gitconfig.local
```
[user]
    name = hai.nguyen.duy
    email = hai.nguyen.duy@vieon.vn

[includeIf "gitdir:~/workspace/"]
    path = ~/.gitconfig-personal

[includeIf "gitdir:~/mycompany/"]
    path = ~/.gitconfig-mycompany

[include]
    path = ~/.main.gitconfig

[url "git@git.mycompany.vn:"]
	insteadOf = https://git.mycompany.vn/
```

.gitconfig-personal
```
[user]
    name = nduyhai
    email = nduyhai@users.noreply.github.com
```

.gitconfig-mycompany
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

