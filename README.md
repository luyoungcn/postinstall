# postinstall

验证启动模式

ls /sys/firmware/efi/efivars

连接到因特网

wifi-menu
ping www.baidu.com
...

更新系统时间

timedatectl set-ntp true

建立硬盘分区

fdisk /dev/sda
:g 建立gpt分区表
n add a new partition
起始扇区 默认 回车
结束扇区 e.g. +100M, +100G, 回车

:w 保存分区方案
:lsblk 查看结果

分区方案
efi 500M
swap 4G
/    40G
/xxx 剩余所有 luks加密 

格式化分区

fdisk/gdisk: 创建类型为 EFI System (EFI System (在 fdisk 中) 或 ef00 (在 gdisk 中)的分区。然后运行 mkfs.fat -F32 /dev/<THAT_PARTITION> 格式化为 FAT32 格式。
mkfs.ext4 </dev/root_partition>（根分区,home分区）
mkswap /dev/swap_partition（交换空间分区）

挂载分区

mount /dev/root_partition /mnt
然后使用 mkdir(1) 创建其他剩余的挂载点（比如 /mnt/efi）并挂载其相应的磁盘卷。 
mkdir /mnt/efi
mount /dev/sda1 /mnt/efi

swapon /dev/swap_partition（交换空间分区）

Mirrors

vim /etc/pacman.d/mirrorlist

开头加入
Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch

安装必需软件包

pacstrap /mnt base linux linux-firmware

生成fstab文件

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

时区

ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc

本地化

编辑/etc/locale.gen 然后移除需要的 地区 前的注释符号 #。
建议将en_US UTF-8和zh_CN UTF-8都取消注释

接着执行 locale-gen 以生成 locale 信息：

# locale-gen

然后创建 locale.conf(5) 文件，并 编辑设定 LANG 变量，比如：

/etc/locale.conf

LANG=en_US.UTF-8

网络配置

/etc/hostname

myhostname

添加对应的信息到 hosts(5):

/etc/hosts

127.0.0.1	localhost
::1		localhost
127.0.1.1	myhostname.localdomain	myhostname

pacman -S --noconfirm dhcp wpa_supplicant networkmanager
systemctl enable NetworkManager

Root 密码

passwd

安装引导程序

pacman -S grub efibootmgr

grub-install --target=x86_64-efi --efi-directory=/efi --bootloader-id=ArchLinux

重启

输入exit或按Ctrl+d退出chroot环境
用umount -R /mnt手动卸载被挂载的分区
执行reboot重启系统


添加普通用户

sudo pacman -Sy zsh sudo
useradd -m -G wheel -s /bin/zsh <xxx>
passwd xxx

sudo vim /etc/sudoers
取消注释 %wheel ALL=(ALL) ALL

安装显示服务

sudo pacman -S xorg xorg-xinit xorg-server xorg-apps

安装窗口管理器

pacman -S i3-gaps

启动窗口管理器

echo exec i3 >> ~/.xinitrc

手动启动X

startX
