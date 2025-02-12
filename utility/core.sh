#!/usr/bin/env bash

clr_reset=$(tput sgr0)
clr_red=$(tput setaf 1)
clr_green=$(tput setaf 2)
clr_yellow=$(tput setaf 3)
clr_magenta=$(tput setaf 5)
clr_cyan=$(tput setaf 6)
clr_gray=$(tput setaf 8)

error() {
    echo "${clr_red}$@${clr_reset}" 1>&2
    return 1
}

fatal_error() {
    echo "${clr_red}$@${clr_reset}" 1>&2
    exit 1
}

block_title() {
    echo "┌─ ${clr_cyan}${1}${clr_reset}"
}

block_entry() {
    echo "│ $1"
}

block_error() {
    echo "│ ${clr_red}${1}${clr_reset}"
    return 1
}

block_end() {
    if [[ $action == "status" ]]; then
        echo "└────"
    elif [[ $1 ]] ; then
        echo "└─ ${clr_green}OK${clr_reset}"
    else
        echo "└─ ${clr_red}Error${clr_reset}"
    fi

    echo ''
    return $1
}

to_lower() {
    echo "$@" | tr '[:upper:]' '[:lower:]'
}

version_lte() {
    if [[ -z $1 || -z $2 ]]; then
        fatal_error "version_lte is called with '$1' and '$2' while two non empty version arguments are expected"
    fi
    printf '%s\n' "$1" "$2" | sort -C -V
}

input_prompt() {
    local prompt="$1"
    local defval="$2"
    local result="$2"

    if [[ $BASH_VERSION == 3* ]]; then
        read -p "${prompt}${result:+" (default $result)"}: " result
        [[ -z $result ]] && result="$defval"
    elif [[ ! -z $BASH_VERSION ]]; then
        read -e -p "$prompt: " -i "$result" result
    elif [[ ! -z $ZSH_VERSION ]]; then
        vared -p "$prompt: " result
    else
        fatal_error Unsupported shell $SHELL
    fi

    echo "$result"
}

