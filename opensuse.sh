#!/bin/bash

#sudo zypper mr -da

sudo zypper ar -f https://mirrors.ustc.edu.cn/opensuse/distribution/leap/42.2/repo/oss USTC:42.2:OSS
sudo zypper ar -f https://mirrors.ustc.edu.cn/opensuse/distribution/leap/42.2/repo/non-oss USTC:42.2:NON-OSS
sudo zypper ar -f https://mirrors.tuna.tsinghua.edu.cn/opensuse/update/leap/42.2/oss/ TUNA:42.2:UPDATE-OSS
sudo zypper ar -f https://mirrors.tuna.tsinghua.edu.cn/opensuse/update/leap/42.2/non-oss/ TUNA:42.2:UPDATE-NON-OSS

sudo zypper ar -f https://mirrors.tuna.tsinghua.edu.cn/packman/suse/openSUSE_Leap_42.2/ Packman

sudo zypper ref

sudo zypper up

sudo zypper install vim git gitk zsh tmux ctags cscope minicom wget curl screenfetch  proxychains tor shutter goldendict weechat hexchat filezilla gimp rxvt-unicode python-gpgme

sudo zypper install fcitx fcitx-googlepinyin fcitx-rime

sudo cp /etc/sysconfig/language /etc/sysconfig/language.bak

sudo sed -i "s/INPUT_METHOD=""/INPUT_METHOD=\"fcitx\"/" /etc/sysconfig/language
cp ~/.bashrc ~/.bashrc.bak
echo "export GTK_IM_MODULE=fcitx">>~/.bashrc
echo "export XMODIFIERS=@im=fcitx">>~/.bashrc
echo "export QT_IM_MODULE=fcitx">>~/.bashrc

sudo zypper install k3b-codecs ffmpeg lame phonon-backend-vlc phonon4qt5-backend-vlc vlc-codecs

sudo zypper install flash-player

sudo zypper install -t pattern devel_basis



# ---

# OpenSUSE Leap 42.1 gnome

- [OpenSUSE Leap 42.1安装后的一些必要配置（原创）](http://tieba.baidu.com/p/4243027288)
- [Install Chinese Fcitx Input method on OpenSUSE Leap 42.1 Gnome](https://www.linuxbabe.com/desktop-linux/install-chinese-fcitx-input-method-on-opensuse-leap-42-1-gnome)
-[安装 openSUSE Leap 42.1 之后要做的 8 件事](https://linux.cn/article-7320-1.html)
- [What is build-essentials for openSUSE](http://randomgeekery.org/post/2014/what-is-build-essentials-for-opensuse/)
- [How to install Nutstore for KDE/XFCE](https://yun.shlingang.com/s/downloads/linux#install_for_kdexfce)

## 更改国内源并更新软件

sudo zypper mr -da

sudo zypper ar -fc https://mirrors.ustc.edu.cn/opensuse/distribution/leap/42.1/repo/oss USTC:42.1:OSS

sudo zypper ar -fc https://mirrors.ustc.edu.cn/opensuse/distribution/leap/42.1/repo/non-oss USTC:42.1:NON-OSS

sudo zypper ar -fc https://mirrors.ustc.edu.cn/opensuse/update/leap/42.1/oss USTC:42.1:UPDATE-OSS

sudo zypper ar -fc https://mirrors.ustc.edu.cn/opensuse/update/leap/42.1/non-oss USTC:42.1:UPDATE-NON-OSS

sudo zypper ref

sudo zypper up

## 增加Packman源

sudo zypper ar http://mirrors.hust.edu.cn/packman/suse/openSUSE_Leap_42.1/ Packman

sudo zypper ref

## build essential

`sudo zypper install -t pattern devel_basis`

##Tools

sudo zypper install vlc vlc-codecs

sudo zypper install mpv

sudo zypper install flash-player

sudo zypper install chromium chromium-pepper-flash

## fcitx

`sudo zypper install fcitx fcitx-googlepinyin`

`sudo vim /etc/sysconfig/language`

Find this line
`INPUT_METHOD=""`

change it to
`INPUT_METHOD="fcitx"`

`vim ~/.bashrc`

add these three line at the end of the file

```bash
export GTK_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export QT_IM_MODULE=fcitx
```

`fcitx-config-gtk3`

1. Click the plus icon the bottom-left corner to add a input method
2. In the next screen, uncheck only show current language and search for googlepinyin
3. Click OK to add this input method

Now you can call googlepinyin input method by pressing Ctrl+Space

## main language is English

language->second language: add simple chinese

## shadowsocks-qt5

sudo zypper ar -fc http://download.opensuse.org/repositories/home:/MargueriteSu/openSUSE_Leap_42.1/ MargueriteSu

sudo zypper ref

sudo zypper install shadowsocks-qt5

## shadowsocks command line
sudo pip install shadowsocks

## Nutstore
sudo zypper install gvfs java-1_7_0-openjdk-headless python-notify
### For 32bit
wget http://jianguoyun.com/static/exe/installer/nutstore_linux_dist_x86.tar.gz -O /tmp/nutstore_bin.tar.gz
### For 64bit
wget http://jianguoyun.com/static/exe/installer/nutstore_linux_dist_x64.tar.gz -O /tmp/nutstore_bin.tar.gz
mkdir -p ~/.nutstore/dist && tar zxf /tmp/nutstore_bin.tar.gz -C ~/.nutstore/dist
~/.nutstore/dist/bin/install_core.sh

## For xfce

### whiskermenu
sudo zypper install xfce4-panel-plugin-whiskermenu

## gnome shell extensions

- [User Themes](https://extensions.gnome.org/extension/19/user-themes/)
- [TopIcons Plus](https://extensions.gnome.org/extension/1031/topicons/)
- [Dash to Dock](https://extensions.gnome.org/extension/307/dash-to-dock/)
- [AlternateTab](https://extensions.gnome.org/extension/15/alternatetab/)

## Build arc theme

`sudo zypper install autoconf automake pkg-config gtk3-devel git`

`git clone https://github.com/horst3180/arc-theme --depth 1 && cd arc-theme`

`./autogen.sh --prefix=/usr`

`sudo make install`

