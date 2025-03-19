#!/bin/bash

sudo apt -y install \
    p7zip-rar p7zip-full unace unrar zip unzip sharutils rar \
    uudeview mpack arj cabextract file-roller neofetch \
    autoconf automake pkg-config\
    git gitk vim vim-gui-common neovim minicom cscope exuberant-ctags global silversearcher-ag \
    tmux xclip xsel \
    vlc mpv cmus wget curl gawk cheese kazam build-essential goldendict \
    fcitx fcitx-config-gtk fcitx-frontend-gtk2 fcitx-frontend-gtk3 fcitx-frontend-qt5 fcitx-googlepinyin \
    fcitx-rime fcitx-anthy tor autoconf automake \
    weechat proxychains proxychains4 \
    manpages-dev man-db manpages-posix-dev \
    python3-dev python3-pip python3-setuptools \
    fonts-noto-mono fonts-roboto language-pack-zh-han* language-pack-gnome-zh-han* \
    vim git tmux wget curl \
    $(check-language-support) \
    libgl1-mesa-dev g++-multilib git flex bison gperf build-essential \
    libncurses-dev dpkg-dev libsdl1.2-dev \
    git-core gnupg flex bison gperf build-essential \
    zip curl zlib1g-dev gcc-multilib g++-multilib \
    libgl1-mesa-dev libxml2-utils xsltproc unzip m4 \
    lib32z-dev ccache make tofrodos python3-markdown \
    libxml2-utils xsltproc \
    zsh \
    openjdk-8-jdk openjdk-8-jre openjdk-8-doc openjdk-8-jdk-headless openjdk-8-jre-headless
