#!/bin/bash

source ./common.sh

sudo pacman-mirrors -i -c China -b stable -a
sudo pacman -Sy
sudo pacman -Syyu


ARCHLINUXCN=$(echo -e"
\n[archlinuxcn]
\nSigLevel = Optional TrustedOnly
\nServer = https://mirrors.ustc.edu.cn/archlinuxcn/\$arch
"
)

ARCHLINUXCN_TO="/etc/pacman.conf"
backup "$ARCHLINUXCN_TO" 1
check_and_setup "archlinuxcn" "$ARCHLINUXCN" "$ARCHLINUXCN_TO" 1

# /etc/pacman.conf already backup above adding ARCHLINUXCN
sudo sed -i 's/\#Color/Color' /etc/pacman.conf

sudo pacman -Sy archlinux-keyring archlinuxcn-keyring yay \
		nerd-fonts-fira adobe-source-han-sans-otc-fonts adobe-source-han-serif-otc-fonts \
		wqy-microhei wqy-microhei-lite ttf-roboto ttf-wps-fonts \
		fcitx5 fcitx5-chinese-addons fcitx5-qt kcm-fcitx5 fcitx5-im fcitx5-pinyin-zhwiki fcitx5-material-color fcitx5-rime \
		base-devel devtools ctags cscope gcc minicom python-pynvim python-pip \
		zsh tmux neovim visual-studio-code-bin  \
		polipo tor proxychains dnscrypt-proxy unbound \
		firefox thunar xfce4-terminal lxappearance arc-gtk-theme arc-icon-theme alsa-utils\
		weechat audacity mpv mplayer vlc ffmpeg openshot uget aria2 xsel xclip calibre \
		veracrypt graphviz wget curl  neofetch 
# sudo pacman -Sy fcitx fcitx-rime fcitx-gtk2 fcitx-gtk3 fcitx-qt4 fcitx-qt5 fcitx-configtool

# https://mirrors.tuna.tsinghua.edu.cn/help/AUR/
yay --aururl "https://aur.tuna.tsinghua.edu.cn" --save
yay -Sy wps-office-cn xmind-zen astah-professional

# FCITX=$(echo -e"
# \nexport XIM_PROGRAM=fcitx
# \nexport XIM=fcitx
# \nexport GTK_IM_MODULE=fcitx
# \nexport QT_IM_MODULE=fcitx
# \nexport XMODIFIERS=\"@im=fcitx\"
# "
# )

FCITX=$(echo -e"
\nexport GTK_IM_MODULE=fcitx
\nexport QT_IM_MODULE=fcitx
\nexport XMODIFIERS=@im=fcitx
"
)

FCITX_TO="/etc/profile"
backup "$FCITX_TO" 1
check_and_setup "fcitx" "$FCITX" "$FCITX_TO" 1
