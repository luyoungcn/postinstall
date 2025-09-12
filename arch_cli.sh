#!/bin/bash
set -e

# -----------------------------
# 🛠️ 更新系统 & Keyring
# -----------------------------
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm base-devel devtools pacman-contrib

# -----------------------------
# 💻 编译 & 开发工具
# -----------------------------
sudo pacman -S --needed --noconfirm \
    git gcc g++ gdb lldb clang clang++ clang-tools-extra \
    cmake make ninja meson ccache bear valgrind ccls

# -----------------------------
# 🐍 Python 环境
# -----------------------------
sudo pacman -S --needed --noconfirm python python-pip python-virtualenv python-pynvim

# -----------------------------
# 📦 Node.js & 前端工具
# -----------------------------
sudo pacman -S --needed --noconfirm nodejs npm
sudo npm install -g tree-sitter-cli neovim

# -----------------------------
# 🐳 容器相关
# -----------------------------
sudo pacman -S --needed --noconfirm docker docker-compose containerd runc

# -----------------------------
# ⚡ 终端 & 编辑器工具
# -----------------------------
sudo pacman -S --needed --noconfirm \
    zsh tmux neovim perl \
    lazygit \
    ripgrep fd xclip xsel \
    bottom neofetch

# -----------------------------
# 🌐 网络 & 下载工具
# -----------------------------
sudo pacman -S --needed --noconfirm \
    wget curl uget aria2 \
    tor proxychains dnscrypt-proxy unbound \
    weechat

# -----------------------------
# 🎵 多媒体 & 系统工具
# -----------------------------
sudo pacman -S --needed --noconfirm \
    alsa-utils ffmpeg

# -----------------------------
# ⚙️ 配置步骤
# -----------------------------

# Docker: 启动服务 & 当前用户加入 docker 组
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"

# zsh: 设置为默认 shell
chsh -s "$(which zsh)"

# 启用系统服务
# sudo systemctl enable --now tor
# sudo systemctl enable --now dnscrypt-proxy
# sudo systemctl enable --now unbound

# 完成提示
echo -e "\n✅ Arch Linux 开发环境安装及基础配置完成！"
echo "请注销或重启以生效 zsh 和 docker 组权限。"
