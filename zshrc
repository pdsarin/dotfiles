alias git=hub

alias gco="git checkout"
alias gpr="git pull-request"


plugins=(... git-prompt)

function gpo () {
    current_branch=`git rev-parse --abbrev-ref HEAD`
    git push origin $current_branch $1
}

ssh-add -K
