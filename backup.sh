#!/usr/bin/env sh

repo_root=`git rev-parse --show-toplevel`

# Copy changes
echo Backing up current config into $repo_root


echo ''
echo Backing alacrity config ...
dst=${repo_root}/alacritty
src=~/.config/alacritty
mkdir -p ${dst}
cp -r ${src}/* ${dst}/
echo Done


echo ''
echo Backing nvim config ...
dst=${repo_root}/nvim
src=~/.config/nvim
mkdir -p ${dst}
cp ${src}/init.lua ${dst}/
cp -r ${src}/lua ${dst}/
echo Done


echo ''
echo Backing up zsh config ...
dst=${repo_root}/zsh
src=~
mkdir -p ${dst}
cp ${src}/.zshrc ${dst}/zshrc
cp ${src}/.p10k.zsh ${dst}/p10k.zsh
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

