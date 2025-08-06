source "$HOME/.dotfiles/shell/interactive.sh"


###############################################################################
# Prompt
###############################################################################
prompt_command() {
    local last_ret=$?

    local RESET="\[$(tput sgr0)\]"
    local BLUE="\[$(tput setaf 4)\]"
    local CIAN="\[$(tput setaf 6)\]"
    local GREEN="\[$(tput setaf 2)\]"
    local RED="\[$(tput setaf 1)\]"
    local YELLOW="\[$(tput setaf 3)\]"

    if [[ $last_ret == 0 ]]; then
        local carrot="${GREEN}>"
    else
        local carrot="${RED} ${last_ret}>"
    fi

    if [[ -z $CONDA_PREFIX ]]; then
        local conda_info=""
    else
        local conda_info="(${CONDA_PREFIX##*/}) "
    fi

    if git rev-parse --is-inside-work-tree &> /dev/null ; then
        local git_branch="$( git rev-parse --abbrev-ref HEAD )"
        if git status --porcelain &>/dev/null ; then
            local git_info="${BLUE} ${git_branch}"
        else
            local git_info="${YELLOW} *${git_branch}"
        fi
    else
        local git_info=""
    fi

    export PS1="${conda_info}${GREEN}${HOSTNAME%%.huron*}:${CIAN}\w${git_info}${carrot}${RESET} "
}

export PROMPT_DIRTRIM=2
PROMPT_COMMAND=prompt_command


###############################################################################
# Key Bindings
###############################################################################
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'


###############################################################################
# Utils Integration
###############################################################################
[[ ! -f "$HOME/.fzf.bash" ]] || source "$HOME/.fzf.bash"

