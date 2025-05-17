# silpharin theme - fork of robbyrussell with workspace indicator
# Based on the robbyrussell theme but with support for workspace indicators

# Helper function to show workspace indicator
function workspace_indicator() {
  if [ -n "$WORKSPACE_NAME" ]; then
    echo "%{$fg_bold[cyan]%}[workspace-${WORKSPACE_NAME}]%{$reset_color%} "
  fi
}

# Main prompt with workspace indicator if WORKSPACE_NAME is set
PROMPT='$(workspace_indicator)%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%c%{$reset_color%}'
PROMPT+=' $(git_prompt_info)'

# Git prompt styling - same as robbyrussell
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"