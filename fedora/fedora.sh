#!/bin/bash

source ./common.sh

backup "/etc/yum.repos.d" 1
sudo rm "/etc/yum.repos.d"

sudo ln -s `pwd`/yum.repos.d /etc/yum.repos.d

su -c 'dnf install http://mirrors.ustc.edu.cn/rpmfusion/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm http://mirrors.ustc.edu.cn/rpmfusion/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm'

#fdzh repo
sudo dnf config-manager --add-repo=http://repo.fdzh.org/FZUG/FZUG.repo

sudo dnf -y makecache
sudo dnf -y update

sudo dnf -y install autoconf automake inkscape glib2 libxml2 pkgconfig rubygem-bundler rubygem-sass sassc

sudo dnf -y install vim git gitk gcc gcc-c++ tor tor-arm zsh tmux gnome-tweak-tool \
    rxvt-unicode screenfetch ibus-rime chromium ctags cscope minicom wget curl goldendict weechat \
    proxychains gimp filezilla
sudo dnf -y install neovim python2-neovim python3-neovim
sudo dnf -y install cabextract lzip nano p7zip p7zip-plugins
sudo dnf -y install autoconf automake
sudo dnf -y install pkgconfig gtk3-devel gnome-themes-standard gtk-murrine-engine

sudo dnf install fcitx fcitx-qt4 fcitx-qt5 fcitx-gtk2 fcitx-gtk3 fcitx-configtool sogoupinyin
#禁止sogou访问网络
sudo setsebool -P sogou_access_network=0

sudo dnf -y install mencoder mplayer mpv vlc ffmpeg openshot
sudo dnf -y install flash-plugin
