###############################################################################
# Preferred Editor
###############################################################################
if command -v nvim &> /dev/null; then
    PREFERRED_EDITOR='nvim'
else
    PREFERRED_EDITOR='vim'
fi

if [[ -z $PREFERRED_EDITOR ]]; then
    export EDITOR=$PREFERRED_EDITOR
    export VISUAL=$PREFERRED_EDITOR
fi


###############################################################################
# Micromamba
###############################################################################
if [[ -f $MAMBA_EXE ]] ; then
    __mamba_setup="$("$MAMBA_EXE" shell hook --shell $SHELL --root-prefix "$MAMBA_ROOT_PREFIX" 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__mamba_setup"
    else
        alias micromamba="$MAMBA_EXE"  # Fallback on help from micromamba activate
    fi
    unset __mamba_setup
fi


###############################################################################
# Aliases
###############################################################################
if command -v lsd &> /dev/null; then
    alias ls='lsd'
    alias lt='lsd --tree'
elif command -v tree &> /dev/null; then
    alias lt='tree'
else
    alias lt='find . -not -path "*/.*" | sed -e "s/[^-][^\/]*\// |/g" -e "s/|\([^ ]\)/|-\1/"'
fi

alias nv=nvim
alias mm=micromamba


