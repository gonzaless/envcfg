envcfg_add_path_if_exists() {
    if [[ -d "$1" ]] && [[ ":$PATH:" != *":$1:"* ]]; then
        if [[ $2 == prepand ]]; then
            export PATH="$1${PATH:+":$PATH"}"
        else
            export PATH="${PATH:+"$PATH:"}$1"
        fi
    fi
}

envcfg_add_path_if_exists "$HOME/bin" prepend
envcfg_add_path_if_exists "$HOME/.local/bin" prepend

setup_mamba_env() {
    export MAMBA_ROOT_PREFIX="${HOME}/.mamba"

    local p=`which micromamba`
    if [[ -f $p ]]; then
       export MAMBA_EXE="$p"
    fi

    local possible_paths=(
        "${HOME}/.local/bin/micromamba"
        "/usr/local/bin/micromamba"
    )

    for p in "${possible_paths[@]}" ; do
        if [[ -f $p ]]; then
            export MAMBA_EXE="$p"
            return
        fi
    done
}

setup_mamba_env

