#!/usr/bin/env bash

dotfiles() {
    local repo_root=$( cd -- "$( dirname -- "$0" )" &> /dev/null && pwd )
    source ${repo_root}/utility/io.sh
    source ${repo_root}/utility/os.sh

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

    local dotf_lnk="${HOME}/.dotfiles"
    local dotf_dir="$repo_root/dotfiles"

    dotfiles_symlink() {
        local dotf_cur=""

        block_title "dotfiles link $dotf_lnk"
        if [[ ! -e $dotf_lnk && ! -L $dotf_lnk ]]; then
            block_error "not installed"
        elif [[ ! -L $dotf_lnk ]]; then
            dotf_cur="$dotf_lnk"
            block_error "is not a symlink"
        else
            dotf_cur=$(readlink "$dotf_lnk" 2>/dev/null)
            if [[ $dotf_cur == $dotf_dir ]]; then
                block_entry "-> $dotf_cur"
            else
                block_error "-> $dotf_cur"
            fi
        fi

        case "$action" in
            deploy)
                if [[ $dotf_cur == $dotf_dir ]]; then
                    block_entry "nothing to do"
                elif [[ -e $dotf_lnk && ! -L $dotf_lnk ]]; then
                    block_error "unable to install the link: path already exist and is not a link"
                    block_error "in order to continue remove it manually"
                else
                    block_entry "installing -> $dotf_dir ..."
                    ln -shf "$dotf_dir" "$dotf_lnk"
                fi
                ;;

            remove)
                if [[ ! -e $dotf_lnk && ! -L $dotf_lnk ]]; then
                    block_entry "nothing to do"
                elif [[ ! -L $dotf_lnk ]]; then
                    block_error "path is not a link, skipping"
                else
                    block_entry "removing ..."
                    rm "$dotf_lnk"
                fi
                ;;
        esac

        block_end $?
    }

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

        local group_result=0
        local os=$(os_type)

        for os_file in "${files[@]}"; do
            local target_os=$([[ "$os_file" == *:* ]] && echo "${os_file%%:*}" || echo "")
            local file="${os_file#*:}"
            if [[ -n $target_os && $target_os != $os ]]; then
                continue
            fi

            local source="$HOME/.$file"
            local backup="$HOME/.$file.bak"
            local target="$dotf_lnk/$file"
            local current=""

            block_title2 "$source"
            if [[ ! -e $source && ! -L $source ]]; then
                block_error2 "not installed"
            elif [[ ! -L $source ]]; then
                block_error2 "is not a symlink"
            else
                current=$(readlink "$source" 2>/dev/null)
                if [[ $current == $target ]]; then
                    block_entry2 "-> $current"
                else
                    block_error2 "-> $current"
                fi
            fi

            local entry_result=0

            case "$action" in
                deploy)
                    if [[ -f $source && ! -L $source ]]; then
                        block_entry2 "creating backup $backup ..."
                        mv "$source" "$backup"
                        entry_result=$?
                    fi

                    if [[ $entry_result == 0 ]]; then
                        block_entry2 "installing -> $dotf_dir ..."
                        ln -shf "$target" "$source"
                        entry_result=$?
                    fi
                    ;;

                remove)
                    if [[ ! -e $source && ! -L $source ]]; then
                        block_entry2 "nothing to do"
                    elif [[ ! -L $source ]]; then
                        block_error2 "path is not a link, skipping"
                        entry_result=$?
                    else
                        block_entry2 "removing ..."
                        rm "$source"
                        entry_result=$?
                    fi

                    if [[ $entry_result == 0 && -f $backup ]]; then
                      block_entry2 "restoring original from $backup ..."
                      mv "$backup" "$source"
                      entry_result=$?
                    fi
                    ;;
            esac

            block_end2 $entry_result || result=1
        done

        block_end $result
    }

    if [[ $action != remove ]]; then
        dotfiles_symlink
    fi

    dotfiles_group bash --files linux:bash_profile bashrc
    #dotfiles_group zsh --files zshrc
    #dotfiles_group tmux --files tmux.conf

    if [[ $action == remove ]]; then
        dotfiles_symlink
    fi
}

dotfiles $@

