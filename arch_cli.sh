#!/bin/bash
set -e

# -----------------------------
# 1️⃣ 更新系统 & Keyring
# -----------------------------
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm base-devel devtools pacman-contrib

# -----------------------------
# 2️⃣ 安装开发工具
# -----------------------------
sudo pacman -S --needed --noconfirm \
    git gcc g++ gdb lldb clang clang++ clang-tools-extra \
    cmake make ninja meson ccache bear valgrind ccls \
    python python-pip python-virtualenv python-pynvim \
    nodejs npm docker docker-compose containerd runc \
    zsh tmux neovim perl \
    lazygit ripgrep fd xclip xsel bottom neofetch \
    wget curl uget aria2 tor proxychains dnscrypt-proxy unbound weechat \
    alsa-utils ffmpeg

# -----------------------------
# 3️⃣ 启用 UTF-8 locale
# -----------------------------
sudo sed -i 's/^#\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen
sudo sed -i 's/^#\(zh_CN.UTF-8 UTF-8\)/\1/' /etc/locale.gen
sudo locale-gen

# -----------------------------
# 4️⃣ 安装中文字体
# -----------------------------
sudo pacman -S --needed --noconfirm adobe-source-han-sans-otc-fonts wqy-microhei

# -----------------------------
# 5️⃣ 启用 Docker & systemd 服务
# -----------------------------
sudo systemctl enable --now docker
sudo usermod -aG docker "$USER"

# sudo systemctl enable --now tor
# sudo systemctl enable --now dnscrypt-proxy
# sudo systemctl enable --now unbound

# -----------------------------
# 6️⃣ 安装 Oh My Tmux
# -----------------------------
cd ~
git clone --single-branch https://github.com/gpakosz/.tmux.git
ln -s -f .tmux/.tmux.conf
cp .tmux/.tmux.conf.local .

# -----------------------------
# 7️⃣ 安装 Oh My Zsh + 插件 + powerlevel10k
# -----------------------------
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' "$HOME/.zshrc"
sed -i 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting docker npm)/' "$HOME/.zshrc"

# -----------------------------
# 8️⃣ Node 全局工具
# -----------------------------
sudo npm install -g tree-sitter-cli neovim

# -----------------------------
# 9️⃣ 完成提示
# -----------------------------
echo -e "\n✅ Arch Linux 完整开发环境安装完成！"
echo "请注销或重启以生效 zsh、tmux、docker、中文环境和字体设置。"
