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

block_title2() {
    echo "├─┬─ ${clr_cyan}${1}${clr_reset}"
}

block_entry() {
    echo "│ $1"
}

block_entry2() {
    echo "│ │ $1"
}

block_error() {
    block_entry "${clr_red}${1}${clr_reset}"
    return 1
}

block_error2() {
    block_entry2 "${clr_red}${1}${clr_reset}"
    return 1
}

block_end() {
    if [[ $1 == 0 ]] ; then
        echo "└─ ${clr_green}OK${clr_reset}"
    else
        echo "└─ ${clr_red}ERR${clr_reset}"
    fi

    echo ''
    return $1
}

block_end2() {
    if [[ $1 == 0 ]] ; then
        echo "│ └─ ${clr_green}OK${clr_reset}"
    else
        echo "│ └─ ${clr_red}ERR${clr_reset}"
    fi
    return $1
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

