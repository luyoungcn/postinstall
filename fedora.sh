#!/usr/bin/env bash

echo "Fedora-43 post install start ..."

set -e

echo "== Fedora 43 Post Install (Developer Edition) =="
echo "Updating system..."

sudo dnf upgrade --refresh -y

echo "Installing Development Tools group..."
# sudo dnf group install -y "Development Tools"
sudo dnf install -y @development-tools

echo "Installing core development packages..."
sudo dnf install -y \
    gcc gcc-c++ \
    clang llvm \
    binutils \
    make cmake ninja-build \
    gdb \
    pkgconf \
    git \
    bc bison flex \
    openssl-devel elfutils-libelf-devel \
    kernel-devel kernel-headers \
    perf \
    pahole \
    ccache

echo "Installing useful utilities..."
sudo dnf install -y \
    htop \
    strace \
    ltrace \
    ripgrep \
    fd-find \
    tmux \
    wget curl \
    tree \
    rsync

sudo dnf install -y \
    awk \
    vim \
    xz

echo "Installing Rust toolchain..."
sudo dnf install -y rust cargo

echo "Configuring ccache..."
if ! grep -q "USE_CCACHE" ~/.bashrc; then
    echo 'export USE_CCACHE=1' >> ~/.bashrc
    echo 'export CC="ccache gcc"' >> ~/.bashrc
    echo 'export CXX="ccache g++"' >> ~/.bashrc
fi

ccache -M 20G || true

echo "Enabling faster DNF config..."
if ! grep -q "max_parallel_downloads" /etc/dnf/dnf.conf; then
    echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf
    echo "fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf
fi

echo "Optional: Install Google Chrome? (y/N)"
read -r install_chrome



if [[ "$install_chrome" == "y" || "$install_chrome" == "Y" ]]; then
    # sudo dnf install -y fedora-workstation-repositories
    # sudo dnf config-manager --set-enabled google-chrome
    # sudo dnf install -y google-chrome-stable
    sudo dnf install https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
fi

echo
echo "Post-install complete."
echo "Reboot recommended."
