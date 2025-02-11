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

