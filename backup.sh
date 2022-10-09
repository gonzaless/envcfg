#!/usr/bin/env sh

repo_root=`git rev-parse --show-toplevel`

# Copy changes
echo Backing up current config into $repo_root

echo ''
echo Backing up zsh config ...
zsh_root=${repo_root}/zsh
mkdir -p ${zsh_root}
cp ~/.zshrc ${zsh_root}/zshrc
echo Done

echo ''
echo Backing nvim config ...
nvim_root=${repo_root}/nvim
mkdir -p ${nvim_root}
cp ~/.config/nvim/init.lua ${nvim_root}/
cp -r ~/.config/nvim/lua ${nvim_root}/
echo Done


# Show status
echo ''
echo Changes:
git -C $repo_root status


# Action prompt
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

