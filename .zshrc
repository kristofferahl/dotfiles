export DOTFILES_DIR=${DOTFILES_DIR:-~/develop/dotfiles}
echo "sourcing dotfiles from ${DOTFILES_DIR:?}"

source ${DOTFILES_DIR:?}/.options
source ${DOTFILES_DIR:?}/.exports
source ${DOTFILES_DIR:?}/.aliases
source ${DOTFILES_DIR:?}/.completions
source ${DOTFILES_DIR:?}/.functions
source ${DOTFILES_DIR:?}/.temp

if [[ -d ${DOTFILES_DIR:?}/addons/ ]]; then
  for filename in ${DOTFILES_DIR:?}/addons/.*; do
    echo "sourcing dotfiles addon ${filename:?}"
    source "${filename:?}"
  done
fi

eval "$(starship init zsh)"
eval "$(direnv hook zsh)"

source ${DOTFILES_DIR:?}/.splash
