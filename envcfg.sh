#!/usr/bin/env bash

error() {
    echo "$@" 1>&2
    return 1
}

fatal_error() {
    echo "$@" 1>&2
    exit 1
}

print_help() {
    echo "Usage: ${0##*/} [-b|--backup] [-d|--deploy [--install-missing]] [-h|--help] [-s|--status] [packages ...]"
}

to_lower() {
    echo "$@" | tr '[:upper:]' '[:lower:]'
}


#
# Parse command line
#
action=status
unset packages
unhandled_packages=()

while [[ $# -gt 0 ]]; do
    case $1 in
        -b|--backup)
            action=backup
            shift
            ;;
        -d|--deploy)
            action=deploy
            shift
            ;;
        -h|--help)
            print_help
            exit 0
            ;;
        --install-missing)
            install_missing=1
            shift
            ;;
        -s|--status)
            action=status
            shift
            ;;
        -*)
            error "Unknown option $1"
            print_help
            exit 1
            ;;
        *)
            packages=("$@")
            unhandled_packages=("$@")
            break
            ;;
    esac
done


#
# Environment
#
is_in_path() {
    [[ ":$PATH:" == *":$1:"* ]]
}

is_known_command() {
    command -v $1 &> /dev/null
}

repo_root=$( cd -- "$( dirname -- "$0" )" &> /dev/null && pwd )

found_package_managers=()
known_package_managers=("aptitude@apt-get" "brew" "snap")

find_package_managers() {
    for package_manager_info in ${known_package_managers[@]}; do
        local package_manager=${package_manager_info%@*}
        local package_manager_command=${package_manager_info#*@}
        if is_known_command $package_manager_command; then
            found_package_managers+=($package_manager)
        fi
    done
}
find_package_managers

is_package_manager_found() {
    [[ " ${found_package_managers[@]} " =~ " $1 " ]]
}


#
# Utils
#
package() {
    if [[ $# -lt 3 ]]; then
        fatal_error "Invalid ${FUNCNAME[0]} arguments: $@"
    fi

    name=$1
    name_lower_case=`to_lower $name`
    shift

    if [[ -n ${packages[@]} ]]; then
        if [[ " ${packages[*]} " =~ " ${name_lower_case} " ]]; then
            unhandled_packages=(${unhandled_packages[@]/$name_lower_case})
        else
            return
        fi
    fi

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

    is_installed_def() {
        is_known_command $command
    }

    if [[ -z $is_installed_cb ]]; then
        is_installed_cb=is_installed_def
    fi

    $is_installed_cb
    case $? in
        0)
            local status='installed'
            ;;
        2)
            local status='unknown (unable to check)'
            ;;
        *)
            local status='not found'
            ;;
    esac

    echo ""
    echo "┌ $name"
    echo "├── Status: $status"

    # Installation
    if [[ $action = deploy && $install_missing = 1 ]]; then
        echo "├── Installation"
        if [[ $status == installed ]]; then
            echo "│   └ Skipped (already installed)"
        elif [[ -z $install_cb ]]; then
            echo "│   └ Skipped (undefined routine)"
        else
            printf "│   ├ Install $name? (y/n): "
            read yn
            case $yn in
                [Yy]*)
                    $install_cb
                    case $? in
                        0)
                            echo "│   └ Done"
                            status='installed'
                            ;;
                        2)
                            echo "│   └ Unsupported for this platform"
                            ;;
                        *)
                            echo "│   └ Failed"
                            ;;
                    esac
                    ;;
                *)
                    echo "│   └ Declined"
                    ;;
            esac
        fi
    fi

    # Synchronization
    if [[ $action == deploy || $action == backup ]]; then
        echo "├── Synchronization"
        if [[ -z $sync_cb ]]; then
            echo "│   └ Skipped (not required/undefined)"
        elif [[ $status != installed ]]; then
            echo "│   └ Skipped (package or its component is not found)"
        else
            $sync_cb
            case $? in
                0)
                    echo "│   └ Done"
                    ;;
                2)
                    echo "│   └ Unsupported for this platform"
                    ;;
                *)
                    echo "│   └ Failed"
                    ;;
            esac
        fi
    fi

    echo "└ Done"
}

installing_package_comment() {
    echo "│   ├ $1"
}

installing_package_component() {
    echo "│   ├ $1 ..."
}

installing_package_component_done() {
    echo "│   │ └ Done"
}

installing_package_component_step() {
    echo "│   │ ├ $1"
}

package_component_is_already_installed() {
    echo "│   ├ $1 is already installed"
}

install_os_package_command() {
    if [[ ! $# = 2 ]]; then
        fatal_error "Invalid ${FUNCNAME[0]} arguments: $@"
    fi

    case $2 in
        aptitude)
            echo sudo apt install $1
            ;;
        brew)
            echo brew install $1
            ;;
        snap)
            echo sudo snap install $1 --classic
            ;;
        *)
            ;;
    esac
}

install_os_package() {
    if [[ $# = 0 ]]; then
        fatal_error "Invalid ${FUNCNAME[0]} arguments: $@"
    fi

    unset install_command

    for package_full_name in "$@"; do
        local package="${package_full_name%%@*}"
        local manager=$([[ $package == $package_full_name ]] && echo "${found_package_managers[0]}" || echo "${package_full_name#*@}")

        local maybe_install_command=$(install_os_package_command "$package" "$manager")
        if [[ -z "$maybe_install_command" ]]; then
            fatal_error "Function ${FUNCNAME[0]} is called with unknown package manager '$manager', all arguments: $@"
        fi

        if is_package_manager_found "$manager"; then
            install_command=${maybe_install_command}
            break
        fi
    done

    if [[ -z "$install_command" ]]; then
        return 2  # no known version for this platform
    else
        eval ${install_command}
    fi
}


sync_root() {
    config_dir=${1/#\~/$HOME}
    case $# in
        1)
            backup_dir=${repo_root}/${1##*/}
            ;;
        2)
            backup_dir=${repo_root}/${2}
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
        printf '...'
        rsync -ah --delete "${src}/" "${dst}/" && printf "\b\b\b- Done\n"
    elif [[ -f $src ]]; then
        printf '...'
        mkdir -p "${dst_root}"
        cp "${src}" "${dst}" && printf "\b\b\b- Done\n"
    else
        printf '- source doesn'\''t exist, skipping'
    fi

}


#
# Perform action
#
echo "Performing '$action' with config repo '$repo_root'"


#
# Fonts
#
nerd_fonts_download=https://github.com/ryanoasis/nerd-fonts/releases/download

fonts=(
    $nerd_fonts_download/v3.1.1/3270.zip:3270NerdFontMono-Regular.ttf
)

is_fonts_installed() {
    # Don't try to detect
    return 2
}

install_fonts() {
    if ! is_known_command wget; then
        error "Unable to install fonts: 'wget' is missing"
    fi
    if ! is_known_command unzip; then
        fatal_error "Unable to install fonts: 'unzip' is missing"
    fi

    if [[ $OSTYPE == "darwin"* ]]; then
        local fonts_install_dir="$HOME/Library/Fonts"
    elif [[ $OSTYPE == "linux-gnu"* ]]; then
        local fonts_install_dir="$HOME/.fonts"
    else
        error "Unable to install font $1 - unsupported platform"
    fi
    local temp_dir=`mktemp -d`

    for font_info in ${fonts[@]}; do
        local font_url="${font_info%:*}"
        local font_ttf="${font_info##*:}"
        local font_archive_filename="${font_url##*/}"
        local font_archive_download=$temp_dir/$font_archive_filename

        local font_name=${font_archive_filename%%.*}
        local font_unpacked_dir="${font_archive_download}-unpacked"

        installing_package_component "Font $font_name"
        installing_package_component_step "Downloading from $font_url"
        wget --quiet --directory-prefix="$temp_dir" "$font_url"
        if [[ ! -f $font_archive_download ]]; then
            error "Failed to locate downloaded font archive: $font_archive_download"
            continue
        fi

        installing_package_component_step "Unpacking into $font_unpacked_dir"
        unzip -q "$font_archive_download" -d "$font_unpacked_dir"

        if [[ $OSTYPE == "darwin"* ]]; then
            installing_package_component_step "Moving $font_ttf -> $fonts_install_dir"
            mv $font_unpacked_dir/$font_ttf $fonts_install_dir
        elif [[ $OSTYPE == "linux-gnu"* ]]; then
            local ttf_install_dir="$fonts_install_dir/truetype/$font_name"
            installing_package_component_step "Moving $font_ttf -> $ttf_install_dir"
            mkdir -p $ttf_install_dir
            rm $ttf_install_dir/*.ttf
            mv $font_unpacked_dir/$font_ttf $ttf_install_dir/
        else
            error "Unable to install font $1 - unsupported platform"
        fi

        installing_package_component_done
    done

    if [[ $OSTYPE == "linux-gnu"* ]]; then
        installing_package_component "Rebuilding font info cache"
        fc-cache -f $fonts_install_dir
        installing_package_component_done
    fi

    rm -rf "$temp_dir"
}

package Fonts --is-installed is_fonts_installed --install install_fonts


#
# Git
#
install_git() {
    install_os_package git
}

sync_git() {
    if [[ $action = deploy ]]; then
        if is_known_command nvim; then
            git config --global core.editor nvim
        elif is_known_command vim; then
            git config --global core.editor vim
        fi
        git config --global pager.branch false
    fi
}

package Git --command git --install install_git --sync sync_git


#
# Curl
#
install_curl() {
    install_os_package curl
}

package Curl --command curl --install install_curl


#
# Conda
#
install_conda() {
    if is_package_manager_found 'brew'; then
        install_os_package miniconda@brew
    elif [[ $OSTYPE == "linux-gnu"* ]]; then
        local conda_prefix="$HOME/Sandbox/conda"
        local conda_bootstrap_dst="$conda_prefix/miniconda_bootstrap.sh"
        local conda_bootstrap_url="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"

        installing_package_component "Creating conda directory $conda_prefix"
        mkdir -p "$conda_prefix"
        installing_package_component_done

        installing_package_component "Downloading conda boostrap script  $conda_bootstrap_url -> $conda_bootstrap_dst"
        wget --quiet "$conda_bootstrap_url" -O "$conda_bootstrap_dst"
        installing_package_component_done

        installing_package_component "Running conda boostrap script $conda_bootstrap_dst with conda prefix $conda_prefix"
        bash "$conda_bootstrap_dst" -b -u -p "$conda_prefix"
        installing_package_component_done

        installing_package_component "Removing conda boostrap script $conda_bootstrap_dst"
        rm "$conda_bootstrap_dst"
        installing_package_component_done

        installing_package_comment "WARNING: run 'conda init' after installation"
    else
        error "Unable to install miniconda - unsupported platform"
    fi
}

package Conda --command conda --install install_conda


#
# CMake
#
install_cmake() {
    install_os_package cmake
}

package CMake --command cmake --install install_cmake


#
# Ninja
#
install_ninja() {
    install_os_package ninja-build@aptitude ninja@brew
}

package Ninja --command ninja --install install_ninja


#
# Fd
#
install_fd() {
    install_os_package fd-find@aptitude fd@brew

    if is_known_command fd; then
        return 0
    fi
    if is_known_command fdfind; then
        local user_local_bin="$HOME/.local/bin"
        mkdir -p $user_local_bin
        ln -s "$(which fdfind)" "$user_local_bin/fd"

        if ! is_in_path "$user_local_bin"; then
            installing_package_comment "WARNING: $user_local_bin is not in PATH, ~/.profile may add it automatically upon restart - verify or add manually"
        fi
    fi
}

package Fd --command fd-find --install install_fd


#
# Fzf
#
install_fzf() {
    if ! is_known_command git; then
        error "Unable to install fzf - 'git' is not found"
        return 1
    fi

    local fzf_url="https://github.com/junegunn/fzf.git"
    local fzf_dst="$HOME/.fzf"
    git clone --depth 1 "$fzf_url" "$fzf_dst"
    $fzf_dst/install
}

package Fzf --command fzf --install install_fzf


#
# HTop
#
install_htop() {
    install_os_package htop
}

package HTop --command htop --install install_htop


#
# Ripgrep
#
install_ripgrep() {
    install_os_package ripgrep
}

package Ripgrep --command rg --install install_ripgrep


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
    install_os_package neovim@brew nvim@snap neovim@aptitude
}

sync_nvim() {
    sync_root '~/.config/nvim'
    sync_item 'init.lua'
    sync_item 'lua'
}

package Neovim --command nvim --install install_nvim --sync sync_nvim


#
# Tmux
#
install_tmux() {
    install_os_package tmux
}

package Tmux --command tmux --install install_tmux


#
# ZSH
#
zsh_custom_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

zsh_custom_plugins=(
    plugin:zsh-autosuggestions@https://github.com/zsh-users/zsh-autosuggestions
    plugin:zsh-syntax-highlighting@https://github.com/zsh-users/zsh-syntax-highlighting.git

    theme:powerlevel10k@https://github.com/romkatv/powerlevel10k.git
)

zsh_custom_plugin_info() {
    if [[ $1 =~ ^(theme|plugin):(.+)@(.+)$ ]]; then
        # type name http dest
        local info=("${BASH_REMATCH[1]}" "${BASH_REMATCH[2]}" "${BASH_REMATCH[3]}" "${zsh_custom_dir}/${BASH_REMATCH[1]}s/"${BASH_REMATCH[2]})
        echo "${info[@]}"
    else
        fatal_error "Failed to parse plugin declaration: $1"
    fi
}

is_zsh_installed() {
    if ! is_known_command zsh; then
        return 1
    fi

    if [[ ! -d ~/.oh-my-zsh ]]; then
        return 1
    fi

    for custom_plugin in ${zsh_custom_plugins[@]}; do
        local custom_plugin_info=(`zsh_custom_plugin_info $custom_plugin`)
        local custom_plugin_dest=${custom_plugin_info[3]}

        if [[ ! -d $custom_plugin_dest ]]; then
            return 1
        fi
    done

    return 0
}

install_zsh() {
    if is_known_command zsh; then
        package_component_is_already_installed 'zsh'
    else
        install_os_package zsh
    fi
 
    if [[ -d ~/.oh-my-zsh ]]; then
        package_component_is_already_installed 'oh-my-zsh'
    elif is_known_command curl; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    else
        error "Unable to install Oh My Zsh - curl is not found"
        return 1
    fi

    if ! is_known_command git; then
        error "Unable to install ZSH plugings - 'git' is not found"
        return 1
    fi

    for custom_plugin in ${zsh_custom_plugins[@]}; do
        local custom_plugin_info=(`zsh_custom_plugin_info $custom_plugin`)
        local custom_plugin_type=${custom_plugin_info[0]}
        local custom_plugin_name=${custom_plugin_info[1]}
        local custom_plugin_http=${custom_plugin_info[2]}
        local custom_plugin_dest=${custom_plugin_info[3]}

        if [[ -d $custom_plugin_dest ]]; then
            package_component_is_already_installed "$custom_plugin_name $custom_plugin_type"
            continue
        fi

        installing_package_component "$custom_plugin_name $custom_plugin_type"
        git clone --depth=1 "${custom_plugin_http}" "${custom_plugin_dest}"
        installing_package_component_done
    done

    if [[ -n $ZSH_VERSION ]]; then
        source ${HOME}/.zshrc
    fi
}

sync_zsh() {
    sync_root '~' 'zsh'
    sync_item '.zshrc'
    sync_item '.p10k.zsh'
}

package Zsh --command zsh --is-installed is_zsh_installed --install install_zsh --sync sync_zsh


#
# Unrecognized packages
#
if (( ${#unhandled_packages[@]} != 0 )); then
    fatal_error "Some specified packages are unknown: ${unhandled_packages[@]}"
fi


#
# Backup status and prompt
#
if [[ ! $action = backup ]]; then
   exit 0
fi

if ! is_known_command git ; then
    echo ''
    echo 'Unable to show backup diff - git is not installed'
    exit 0
fi

if git diff --quiet; then
    echo ''
    echo 'No changes detected'
    exit 0
fi

echo ''
echo Changes:
git -C $repo_root status

echo ''
echo 'Choose action'
while true; do
    read -p 'Commit [c], Diff [d], Exit [e], Reset [r]: ' choice
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
        e|E )
            break
            ;;
        r|R )
            git -C $repo_root reset --hard
            break
            ;;
        * ) echo 'Invalid option "' $choice '"'
            ;;
    esac
done

