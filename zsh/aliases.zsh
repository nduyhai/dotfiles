# Load grouped aliases from subfiles.
# Add more files under $DOTFILES/zsh/aliases to organize aliases by topic.
for alias_file in "$DOTFILES/zsh/aliases"/*.zsh; do
  [ -f "$alias_file" ] && source "$alias_file"
done
