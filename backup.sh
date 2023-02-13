#!/usr/bin/env sh


error() {
    echo "$@" 1>&2
}

fatal_error() {
    echo "$@" 1>&2
    exit 1
}

print_help() {
    echo "Usage: ${0##*/} [--backup | --deploy | --help]"
}


#
# Parse command line
#
action=backup

while [[ $# -gt 0 ]]; do
    case $1 in
        -b|--backup)
            shift
            ;;
        -d|--deploy)
            action=deploy
            shift
            ;;
        --install-missing)
            install_missing=1
            shift
            ;;
        -h|--help)
            print_help
            exit 0
            ;;
        *)
            error "Unknown option $1"
            print_help
            exit 1
            ;;
    esac
done


#
# Environment
#
repo_root=`git rev-parse --show-toplevel`

if command -v brew &> /dev/null; then
    package_manager=brew
else
    package_manager=aptitude
fi



#
# Utils
#

package() {
    if [[ $# -lt 3 ]]; then
        fatal_error "Invalid ${FUNCNAME[0]} arguments: $@"
    fi

    name=$1
    shift

    unset command
    unset install_cb
    unset is_installed_cb
    unset sync_cb

    while [[ $# -gt 0 ]]; do
        case $1 in
            --command)
                command=$2
                shift
                shift
                ;;
            --install)
                install_cb=$2
                shift
                shift
                ;;
            --is-installed)
                is_installed_cb=$2
                shift
                shift
                ;;
            --sync)
                sync_cb=$2
                shift
                shift
                ;;
            *)
                echo "Unknown option $1"
                return 1
                ;;
        esac
    done

    echo ""
    echo "┌ Package $name ..."

    if [[ ! -z $install_cb ]]; then
        if [[ $action = deploy && $install_missing = 1 ]]; then
            is_installed_def() {
                command -v $command &> /dev/null
            }

            if [[ -z $is_installed_cb ]]; then
                is_installed_cb=is_installed_def
            fi

            if $is_installed_cb; then
                echo "├── Package is already installed"
                echo "│   └ Skip"
            else
                printf "├── Package is missing, install $name? (y/n): "
                read yn
                case $yn in
                    [Yy]*)
                        echo "├── Installing"
                        $install_cb
                        echo "│   └ Done"
                        ;;
                    *)
                        echo "├── Installation declined"
                        echo "│   └ Skip"
                        ;;
                esac
            fi
        fi
    fi

    if [[ ! -z $sync_cb ]]; then
        if [[ $action = deploy || $action = backup ]]; then
            echo "├── Synchronizing"
            $sync_cb
            echo "│   └ Done"
        fi
    fi

    echo "└ Done"
}

install_os_package() {
    if [[ ! $# = 1 ]]; then
        fatal_error "Invalid ${FUNCNAME[0]} arguments: $@"
    fi

    case $package_manager in
        aptitude)
            sudo apt install $1
            ;;
        brew)
            brew install $1
            ;;
        *)
            error "Unknown package manager $package_manager"
    esac
}

sync_root() {
    config_dir=${1/#\~/$HOME}
    case $# in
        1)
            backup_dir=${repo_root}/${1##*/}
            ;;
        2)
            backup_dir=$2
            ;;
        *)
            fatal_error "Invalid ${FUNCNAME[0]} argument number $#"
            ;;
    esac

    if [[ -z $backup_dir || -z $config_dir ]]; then
        fatal_error "Invalid ${FUNCNAME[0]} arguments: $@"
    fi

    case $action in
        'backup')
            src_root=$config_dir
            dst_root=$backup_dir
            ;;
        'deploy')
            src_root=$backup_dir
            dst_root=$config_dir
            ;;
        *)
            fatal_error "Unknown action=${action}"
            ;;
    esac
}

sync_item() {
    if [[ -z $1 ]]; then
        fatal_error "Invalid ${FUNCNAME[0]} arguments: $@"
    fi

    if [[ $1 = "." ]]; then
        src=$src_root
        dst=$dst_root
    else
        src=$src_root/$1
        dst=$dst_root/$1
    fi
 
    printf "│   ├ $src -> $dst "
    if [[ -d $src ]]; then
        printf "..."
        rsync -ah --delete "${src}/" "${dst}/" && printf "\b\b\b- Done\n"
    elif [[ -f $src ]]; then
        printf "..."
        mkdir -p "${dst_root}"
        cp "${src}" "${dst}" && printf "\b\b\b- Done\n"
    else
        printf "- source doesn't exist, skipping"
    fi

}


#
# Perform action
#
echo "Performing $action ..."
echo "Config repo: $repo_root"


#
# Git
#
install_git() {
    install_os_package git
}

sync_git() {
    if [[ $action = deploy ]]; then
        if command -v nvim &> /dev/null; then
            git config --global core.editor nvim
        elif command -v vim &> /dev/null; then
            git config --global core.editor vim
        fi
    fi
}

package Git --command git --install install_git --sync sync_git


#
# Alacritty
#
install_alacritty() {
    install_os_package alacritty
}

sync_alacritty() {
    sync_root '~/.config/alacritty'
    sync_item .
}

package Alacritty --command alacritty --install install_alacritty --sync sync_alacritty


#
# Neofetch
#
sync_neofetch() {
    sync_root '~/.config/neofetch'
    sync_item .
}

package Neofetch --command neofetch --sync sync_neofetch


#
# Neovim
#
install_nvim() {
    install_os_package neovim
}

sync_nvim() {
    sync_root '~/.config/nvim'
    sync_item 'init.lua'
    sync_item 'lua'
}

package Neovim --command nvim --install install_nvim --sync sync_nvim


#
# ZSH
#
is_installed_zsh() {
    if command -v zsh &> /dev/null; then
        if [[ -d ~/.oh-my-zsh ]]; then
            return 0
        fi
    fi
    return 1
}

install_zsh() {
    if command -v zsh &> /dev/null; then
        echo "│   ├ zsh is already installed"
    else
        install_os_package zsh
    fi
 
    if [[ -d ~/.oh-my-zsh ]]; then
        echo "│   ├ oh-my-zsh is already installed"
    else
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
}

sync_zsh() {
    sync_root '~' 'zsh'
    sync_item '.zshrc'
    sync_item '.p10k.zsh'
}

package Zsh --command zsh --is-installed is_installed_zsh --install install_zsh --sync sync_zsh


#
# Backup status and prompt
#
if [[ ! $action = backup ]]; then
   exit 0
fi

echo ''
echo Changes:
git -C $repo_root status

echo ''
echo 'Choose action'
while true; do
    read -p 'Commit [c], Diff [d], Reset [r]: ' choice
    case "$choice" in 
        c|C ) 
            now=`date -u +'%Y-%m-%d %H:%M:%S'`
            git -C $repo_root add -A
            git -C $repo_root commit -am "${now} backup"
            break
            ;;
        d|D )
            git -C $repo_root diff
            ;;
        r|R )
            git -C $repo_root reset --hard
            break
            ;;
        * ) echo 'Invalid option "' $choice '"'
            ;;
    esac
done

