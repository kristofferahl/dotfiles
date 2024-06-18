source ~/develop/dotfiles/.options
source ~/develop/dotfiles/.exports
source ~/develop/dotfiles/.aliases
source ~/develop/dotfiles/.completions
source ~/develop/dotfiles/.functions
source ~/develop/dotfiles/.tips
source ~/develop/dotfiles/.temp

eval "$(starship init zsh)"
eval "$(direnv hook zsh)"

if [[ -d ~/develop/dotfiles/addons/ ]]; then
  for filename in ~/develop/dotfiles/addons/.*; do
    echo "sourcing dotfiles addon ${filename:?}..."
    source "${filename:?}"
  done
fi