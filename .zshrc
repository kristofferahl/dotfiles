declare dotfiles_dir=~/develop/dotfiles

source ${dotfiles_dir:?}/.options
source ${dotfiles_dir:?}/.exports
source ${dotfiles_dir:?}/.aliases
source ${dotfiles_dir:?}/.completions
source ${dotfiles_dir:?}/.functions
source ${dotfiles_dir:?}/.tips
source ${dotfiles_dir:?}/.temp

eval "$(starship init zsh)"
eval "$(direnv hook zsh)"

if [[ -d ${dotfiles_dir:?}/addons/ ]]; then
  for filename in ${dotfiles_dir:?}/addons/.*; do
    echo "sourcing dotfiles addon ${filename:?}..."
    source "${filename:?}"
  done
fi