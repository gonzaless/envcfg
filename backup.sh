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


# Parse command line
action=backup

while [[ $# > 0 ]]; do
    case $1 in
        -b|--backup)
            shift
            ;;
        -d|--deploy)
            action=deploy
            shift
            ;;
        --git)
            git=1
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


# Utils
repo_root=`git rev-parse --show-toplevel`

cfg_sync_begin() {
    echo ""
    echo "Syncing $1 ..."
}

cfg_sync_end() {
    echo "Done"
}

set_dir() {
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

sync_dir() {
    if [[ -z $1 ]]; then
        src=$src_root
        dst=$dst_root
    else
        src=$src_root/$1
        dst=$dst_root/$1
    fi
 
    printf "${src} -> ${dst} "
    if [[ ! -d $src ]]; then
        printf "- source directory doesn't exist, skipping"
        return
    fi

    printf "..."
    mkdir -p "${dst}"
    rsync -ah --delete "${src}/" "${dst}/" && printf "\b\b\b- Done\n"
}

sync_file() {
    src=$src_root/$1
    dst=$dst_root/$1

    printf "${src} -> ${dst} "
    if [[ ! -f $src ]]; then
        printf "- source file doesn't exist, skipping"
        return
    fi

    printf "..."
    mkdir -p "${dst_root}"
    cp "${src}" "${dst}" && printf "\b\b\b- Done\n"
}


# Perform action
echo "Performing $action ..."
echo "Config repo: $repo_root"


cfg_sync_begin 'Alacrity'
set_dir        '~/.config/alacritty'
sync_dir
cfg_sync_end


cfg_sync_begin 'Neofetch'
set_dir        '~/.config/neofetch'
sync_dir
cfg_sync_end


cfg_sync_begin 'Neovim'
set_dir        '~/.config/nvim'
sync_file      'init.lua'
sync_dir       'lua'
cfg_sync_end


cfg_sync_begin 'Powerline10k'
set_dir        '~' 'zsh'
sync_file      '.p10k.zsh'
cfg_sync_end


cfg_sync_begin 'ZSH'
set_dir        '~' 'zsh'
sync_file      '.zshrc'
cfg_sync_end


# Git settings
if [[ ! -z ${git+x} && $action = deploy ]]; then
    cfg_sync_begin 'git'

    if command -v nvim &> /dev/null; then
        git config --global core.editor nvim
    elif command -v vim &> /dev/null; then
        git config --global core.editor vim
    fi

    cfg_sync_end
fi


# Backup status and prompt
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

