###############################################################################
# ZSH Configuration
###############################################################################

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f $HOME/.p10k.zsh ]]; then
    P10K_IS_AVAILABLE=1
fi

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
if [[ ${P10K_IS_AVAILABLE} = 1 ]]; then
    ZSH_THEME="powerlevel10k/powerlevel10k"
else
    ZSH_THEME="agnoster"
    #ZSH_THEME="robbyrussell"
fi


# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Autosuggest settings
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"
# ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20


###############################################################################
# ZSH Plugins
###############################################################################
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(
    git
    vi-mode
    zsh-autosuggestions
    # syntax-highlighting must be the last plugin in the list
    zsh-syntax-highlighting
)

# Syntax Highlighting Config
(( ${+ZSH_HIGHLIGHT_STYLES} )) || typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[path]=none
ZSH_HIGHLIGHT_STYLES[path_prefix]=none


source $ZSH/oh-my-zsh.sh


###############################################################################
# Prompt Configuration
###############################################################################
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Default prompt symbol
# >
# <
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION=''

# Prompt symbol in command vi mode.
typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION=''


#typeset -g POWERLEVEL9K_DIR_BACKGROUND='black'
#typeset -g POWERLEVEL9K_DIR_HOME_BACKGROUND='black'
#typeset -g POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='black'


###############################################################################
# USER Configuration
###############################################################################
# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if command -v nvim &> /dev/null; then
    PREFERRED_EDITOR='nvim'
else
    PREFERRED_EDITOR='vim'
fi

if [[ -z $PREFERRED_EDITOR ]]; then
    export EDITOR=$PREFERRED_EDITOR
fi

# VI Mode line editor
bindkey -v


###############################################################################
# PATH
###############################################################################
envcfg_add_path_if_exists() {
    if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
        if [[ $2 == prepend ]]; then
            PATH="$1${PATH:+":$PATH"}"
        else
            PATH="${PATH:+"$PATH:"}$1"
        fi
    fi
}

envcfg_add_path_if_exists "$HOME/bin" prepend
envcfg_add_path_if_exists "$HOME/.local/bin" prepend


###############################################################################
# USER Aliases
###############################################################################

# ls aliases
if command -v lsd &> /dev/null; then
    alias ls='lsd'
    alias lt='lsd --tree'
elif command -v tree &> /dev/null; then
    alias lt='tree'
else
    alias lt='find . -not -path "*/.*" | sed -e "s/[^-][^\/]*\// |/g" -e "s/|\([^ ]\)/|-\1/"'
fi


###############################################################################
# External Utils Integration
###############################################################################
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

