autoload -U colors && colors

alias ll='ls -AlF'
alias la='ls -alF'

function git_branch {
    git status 2>/dev/null >/dev/null || return

    local branch prefix='' has_untracked has_unstaged has_staged

    while read -r line
    do
        if [[ $line == "##"* ]]; then
            branch=`echo $line | sed -e 's/\.\.\..*$//' -e 's/## //'`
        elif [[ $line == "??"* ]]; then
            has_untracked=true
        elif [[ $line == "M  "* || $line == "A  "* || $line == "D  "* ]]; then
            has_staged=true
        elif [[ $line == "M "* || $line == "A "* || $line == "D "* ]]; then
            has_unstaged=true
        fi
    done < <(git status --porcelain --branch 2>/dev/null)

    if [ "$has_untracked" = true ]; then
        prefix+='? '
    fi
    if [ "$has_unstaged" = true ]; then
        prefix+='U '
    fi
    if [ "$has_staged" = true ]; then
        prefix+='S '
    fi
    if [ -n "$branch" ]; then
        echo "($prefix$branch) "
    fi
}

setopt PROMPT_SUBST
export PROMPT='$(git_branch)%B%F{cyan}%2~%b%F{white} %# %f%k'

setopt histignorealldups sharehistory

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

