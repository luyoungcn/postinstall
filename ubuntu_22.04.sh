#!/bin/bash

# ==============================================================================
# Ubuntu 22.04 Post-Install Setup Master Script
# Target: C++ / ROS / ADAS / BSP Developer
# Usage:
#   ./setup.sh --cli    # 仅安装 CLI 环境 (适用于 WSL2 / 无界面服务器)
#   ./setup.sh --gui    # 仅安装 GUI 桌面扩展 (适用于 GNOME 桌面)
#   ./setup.sh --all    # 安装全部 (CLI + GUI)
# ==============================================================================

set -e

# ------------------------------------------------------------------------------
# 函数定义：CLI 终端开发环境安装
# ------------------------------------------------------------------------------
install_cli() {
    echo "=================================================="
    echo "  开始安装: CLI 终端开发环境 (WSL2 / Desktop 通用)"
    echo "=================================================="

    echo ">>> 0. 清理失效 PPA"
    sudo rm -f /etc/apt/sources.list.d/lazygit-team-ubuntu-release-jammy.list

    echo ">>> 1. 添加第三方 PPA (Neovim)"
    sudo apt install -y software-properties-common curl wget git
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo apt update && sudo apt -y upgrade

    echo ">>> 2. 安装核心编译链与系统开发工具"
    sudo apt -y install \
        build-essential g++-multilib gcc-multilib make cmake autoconf automake pkg-config \
        libgl1-mesa-dev libncurses-dev dpkg-dev libsdl1.2-dev \
        flex bison gperf libxml2-utils xsltproc m4 zlib1g-dev ccache tofrodos \
        lib32z1-dev gnupg \
        libssl-dev libboost-all-dev libasio-dev libtinyxml2-dev

    echo ">>> 3. 安装终端、解压与效率工具"
    sudo apt -y install \
        p7zip-rar p7zip-full unace unrar zip unzip sharutils rar \
        uudeview mpack arj cabextract neofetch \
        git gitk tig minicom cscope exuberant-ctags global silversearcher-ag \
        tmux xclip xsel zsh gawk weechat proxychains proxychains4 \
        manpages-dev man-db manpages-posix-dev \
        python3-dev python3-pip python3-setuptools python3-markdown \
        nodejs npm

    echo ">>> 4. 安装 Neovim, Lazygit & C++ LSP 专属依赖"
    sudo apt -y install neovim ripgrep fd-find fzf clangd clang-format bear

    if ! command -v lazygit &> /dev/null; then
        echo ">>> 正在通过 npm 国内镜像安装 Lazygit..."
        sudo npm install -g lazygit --registry=https://registry.npmmirror.com || true
    fi

    echo ">>> 5. 配置 Oh My Zsh 框架"
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "--> 正在安装 Oh My Zsh 核心..."
        # 尝试通过 curl 安装，若网络超时则使用镜像库
        curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -o omz_install.sh || \
        curl -fsSL https://gitee.com/mirrors/oh-my-zsh/raw/master/tools/install.sh -o omz_install.sh
        
        RUNZSH=no CHSH=no sh omz_install.sh
        rm -f omz_install.sh
    else
        echo "--> Oh My Zsh 已安装，跳过."
    fi

    echo ">>> 5.1 安装 Zsh 常用插件"
    ZSH_CUSTOM_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    
    if [ ! -d "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions" ]; then
        echo "--> 克隆 zsh-autosuggestions..."
        git clone https://gitee.com/mirrors/zsh-autosuggestions.git "$ZSH_CUSTOM_DIR/plugins/zsh-autosuggestions"
    fi

    if [ ! -d "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting" ]; then
        echo "--> 克隆 zsh-syntax-highlighting..."
        git clone https://gitee.com/mirrors/zsh-syntax-highlighting.git "$ZSH_CUSTOM_DIR/plugins/zsh-syntax-highlighting"
    fi

    # 配置 .zshrc 中的插件配置
    if [ -f "$HOME/.zshrc" ]; then
        sed -i 's/plugins=(git)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc
    fi

    echo ">>> 5.2 安装 Powerlevel10k 主题"
    if [ ! -d "$ZSH_CUSTOM_DIR/themes/powerlevel10k" ]; then
        echo "--> 克隆 Powerlevel10k 仓库..."
        git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM_DIR/themes/powerlevel10k"
    fi

    if [ -f "$HOME/.zshrc" ]; then
        echo "--> 修改 ~/.zshrc 主题配置为 powerlevel10k..."
        sed -i 's/ZSH_THEME=".*"/ZSH_THEME="powerlevel10k\/powerlevel10k"/g' ~/.zshrc
    fi

    echo ">>> 6. 修改默认 Shell 为 zsh"
    CURRENT_ZSH=$(which zsh)
    echo "--> 当前系统 zsh 路径: $CURRENT_ZSH"
    if [ "$SHELL" != "$CURRENT_ZSH" ]; then
        echo "--> 切换用户默认 Shell..."
        sudo chsh -s "$CURRENT_ZSH" "$USER" || chsh -s "$CURRENT_ZSH"
        echo "--> Shell 修改成功，下次登录或运行 'exec zsh' 时生效。"
    else
        echo "--> 当前默认 Shell 已经是 zsh."
    fi

    echo ""
    read -p "是否现在启动鱼香 ROS 一键安装/配置工具? [y/N] " CHOICE
    case "$CHOICE" in
      [yY][eE][sS]|[yY])
        source <(wget -qO- http://fishros.com/install)
        ;;
      *)
        echo "跳过鱼香 ROS 配置。"
        ;;
    esac
}

# ------------------------------------------------------------------------------
# 函数定义：GUI 桌面扩展环境安装
# ------------------------------------------------------------------------------
install_gui() {
    echo "=================================================="
    echo "  开始安装: GUI 桌面扩展 (适用于 GNOME 环境)"
    echo "=================================================="

    echo ">>> 1. 安装语言支持与 Fcitx5 输入法"
    sudo apt update
    sudo apt -y install language-selector-common
    sudo apt -y install fonts-noto-mono fonts-roboto language-pack-zh-hans language-pack-gnome-zh-hans $(check-language-support)
    sudo apt -y install fcitx5 fcitx5-chinese-addons fcitx5-rime

    echo ">>> 2. 安装 GUI 媒体与实用工具"
    sudo apt -y install file-roller vlc mpv cmus cheese kazam goldendict

    echo ">>> 3. 配置默认输入法为 Fcitx5"
    im-config -n fcitx5

    echo "GUI 环境安装完成，建议安装结束后注销或重启系统以生效输入法。"
}

# ------------------------------------------------------------------------------
# 主逻辑：参数解析与控制
# ------------------------------------------------------------------------------
show_help() {
    echo "用法: $0 [选项]"
    echo "选项:"
    echo "  --cli, -c    仅安装 CLI 开发环境 (适用于 WSL2 / 无界面环境)"
    echo "  --gui, -g    仅安装 GUI 桌面扩展 (输入法、播放器等)"
    echo "  --all, -a    安装完整环境 (CLI + GUI)"
    echo "  --help, -h   显示帮助信息"
}

case "$1" in
    --cli|-c)
        install_cli
        ;;
    --gui|-g)
        install_gui
        ;;
    --all|-a)
        install_cli
        install_gui
        ;;
    --help|-h)
        show_help
        ;;
    "")
        echo "未检测到输入参数，请选择安装模式："
        echo "1) 仅安装 CLI 环境 (WSL2 / Server)"
        echo "2) 仅安装 GUI 扩展 (Desktop)"
        echo "3) 安装全部 (CLI + GUI)"
        echo "4) 退出"
        read -p "请输入选项 [1-4]: " OPT
        case "$OPT" in
            1) install_cli ;;
            2) install_gui ;;
            3) install_cli; install_gui ;;
            *) echo "已取消操作。"; exit 0 ;;
        esac
        ;;
    *)
        echo "未知参数: $1"
        show_help
        exit 1
        ;;
esac
