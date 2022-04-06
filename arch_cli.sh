#!/bin/bash

sudo pacman -Sy archlinux-keyring archlinuxcn-keyring
sudo pacman -Sy base-devel devtools make cmake gcc clang minicom python-pynvim python-pip \
		zsh tmux neovim perl ccls \
		tor proxychains dnscrypt-proxy unbound \
		alsa-utils ffmpeg uget aria2 xsel xclip \
		wget curl  neofetch weechat pacman-contrib
