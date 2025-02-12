#!/usr/bin/env bash

dotfiles() {
    local repo_root=$( cd -- "$( dirname -- "$0" )" &> /dev/null && pwd )
    source ${repo_root}/utility/core.sh

    dotfiles_print_help() {
        echo "Usage: ${0##*/} [-s|--status] [-d|--deploy] [-r|--remove] [-h|--help] [groups ...]"
    }

    local action=status
    unset groups

    while [[ $# -gt 0 ]]; do
        case $1 in
            -d|--deploy)
                action=deploy
                shift
                ;;
            -r|--remove)
                action=remove
                shift
                ;;
            -s|--status)
                action=status
                shift
                ;;
            -h|--help)
                dotfiles_print_help
                return 0
                ;;
            -*)
                error "Unknown option $1"
                dotfiles_print_help
                return 1
                ;;
            *)
                groups=("$@")
                break
                ;;
        esac
    done

    local dotf_link="${HOME}/.dotfiles"
    local dotf_repo="$repo_root/dotfiles"

    dotfiles_symlink() {
        local dotf_curr=$(realpath "$dotf_link" 2>/dev/null)

        block_title "dotfiles link $dotf_link"
        block_entry "target: $dotf_repo"
        block_entry "actual: ${dotf_curr:-not installed}"

        if [[ $action == deploy ]]; then
            if [[ $dotf_curr == $dotf_repo ]]; then
                block_end 0
                return
            fi

            if [[ -n $dotf_curr ]]; then
                block_error "link already exist and does not reference this repo"
                block_end $?
                return
            fi

            block_entry "installing ..."
            ln -shf "$dotf_repo" "$dotf_link"
            block_end $?
            return
        fi

        if [[ $action == remove ]]; then
            if [[ -z $dotf_curr ]]; then
                block_end 0
                return
            fi

            if [[ $dotf_curr != $dotf_repo ]]; then
                block_error "link exists but does not reference this repo, skipping"
                block_end $?
                return
            fi

            block_entry "removing ..."
            rm "$dotf_link"
            block_end $?
            return
        fi

        block_end 0
    }
    dotfiles_symlink

    dotfiles_group() {
        block_title $1
        local files=()
        shift

        while [[ $# -gt 0 ]]; do
            case $1 in
                --files)
                    shift
                    while [[ $# -gt 0 && "$1" != --* ]]; do
                        files+=("$1")
                        shift
                    done
                    ;;
                *)
                    echo "Unknown option $1"
                    return 1
                    ;;
            esac
        done

        for file in "${files[@]}"; do
            local source="$HOME/.$file"
            local target="$dotf_repo/$file"
            block_entry "$source -> $target"
        done

        block_end $?
    }

    dotfiles_group bash --files bash_profile bashrc
    dotfiles_group zsh --files zshrc
    dotfiles_group tmux --files tmux.conf
}

dotfiles $@

