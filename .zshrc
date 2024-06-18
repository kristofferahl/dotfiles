export DOTFILES_DIR=~/develop/dotfiles

source ${DOTFILES_DIR:?}/.options
source ${DOTFILES_DIR:?}/.exports
source ${DOTFILES_DIR:?}/.aliases
source ${DOTFILES_DIR:?}/.completions
source ${DOTFILES_DIR:?}/.functions
source ${DOTFILES_DIR:?}/.tips
source ${DOTFILES_DIR:?}/.temp

eval "$(starship init zsh)"
eval "$(direnv hook zsh)"

if [[ -d ${DOTFILES_DIR:?}/addons/ ]]; then
  for filename in ${DOTFILES_DIR:?}/addons/.*; do
    echo "sourcing dotfiles addon ${filename:?}..."
    source "${filename:?}"
  done
fi