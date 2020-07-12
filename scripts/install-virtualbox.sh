#!/usr/bin/bash -x

# VirtualBox Guest Additions
# https://wiki.archlinux.org/index.php/VirtualBox/Install_Arch_Linux_as_a_guest
/usr/bin/pacman -S --noconfirm virtualbox-guest-utils-nox nfs-utils

/usr/bin/systemctl enable vboxservice.service
/usr/bin/systemctl enable rpcbind.service

# Add groups for VirtualBox folder sharing
/usr/bin/usermod --append --groups vagrant,vboxsf vagrant
