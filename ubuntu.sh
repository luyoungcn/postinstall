#!/bin/bash

# sudo dpkg --add-architecture i386
# sudo apt-get update -y
# sudo apt-get -y install lib32z1 lib32ncurses5 libbz2-1.0:i386 libstdc++6:i386 \
#     libfontconfig1:i386 libxext6:i386 libxrender1:i386 libgstreamer-plugins-base1.0-0:i386

# sudo apt -y install openssl1.0
# echo "export OPENSSL_DIR=/usr/lib/ssl1.0/" >> ~/.bashrc

function add_ppa
{
    if ! grep -q "$1" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
        echo "Add ppa:$1 ..."
        sudo add-apt-repository ppa:$1
    else
        echo "ppa:$1 already added"
    fi
}

sudo apt -y install \
    p7zip-rar p7zip-full unace unrar zip unzip sharutils rar \
    uudeview mpack arj cabextract file-roller neofetch \
    autoconf automake pkg-config libgtk-3-dev gnome-themes-standard gtk2-engines-murrine \
    git gitk vim vim-gui-common neovim minicom cscope ctags global silversearcher-ag \
    tmux xclip xsel \
    vlc mpv cmus wget curl gawk cheese kazam build-essential goldendict \
    fcitx fcitx-config-gtk fcitx-frontend-gtk2 fcitx-frontend-gtk3 fcitx-frontend-qt5 fcitx-googlepinyin \
    fcitx-rime fcitx-anthy tor tor-arm autoconf automake python-pip \
    weechat openshot hexchat proxychains proxychains4  filezilla lftp audacious audacity \
    meld polipo clementine calibre manpages-dev man-db manpages-posix-dev \
    python-dev python-pip python3-dev python3-pip python-setuptools python3-setuptools \
    fonts-noto-mono fonts-roboto language-pack-zh-han* language-pack-gnome-zh-han* \
    vim git tmux wget curl calibre mpv vlc chromium-browser \
    $(check-language-support) libx11-dev:i386 libreadline6-dev:i386 \
    libgl1-mesa-dev g++-multilib git flex bison gperf build-essential \
    libncurses5-dev:i386 dpkg-dev libsdl1.2-dev \
    git-core gnupg flex bison gperf build-essential \
    zip curl zlib1g-dev gcc-multilib g++-multilib \
    libc6-dev-i386 lib32ncurses5-dev x11proto-core-dev libx11-dev \
    libgl1-mesa-dev libxml2-utils xsltproc unzip m4 \
    lib32z-dev ccache make tofrodos python-markdown \
    libxml2-utils xsltproc zlib1g-dev:i386 \
    openjdk-8-jdk openjdk-8-jre openjdk-8-doc openjdk-8-jdk-headless openjdk-8-jre-headless

sudo pip install grip hpp2plantuml
