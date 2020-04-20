alias git=hub

alias gco="git checkout"
alias gpr="git pull-request"


if [ -f "$(brew --prefix)/opt/zsh-git-prompt/zshrc.sh" ]; then
   source "$(brew --prefix)/opt/zsh-git-prompt/zshrc.sh"
fi

function gpo () {
    current_branch=`git rev-parse --abbrev-ref HEAD`
    git push origin $current_branch $1
}
