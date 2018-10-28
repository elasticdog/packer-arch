#!/usr/bin/bash -x

# Open VM Tools
# https://wiki.archlinux.org/index.php/VMware
# https://wiki.archlinux.org/index.php/VMware/Installing_Arch_as_a_guest
/usr/bin/pacman -S --noconfirm linux-headers open-vm-tools nfs-utils

/usr/bin/systemctl enable vmtoolsd.service
/usr/bin/systemctl enable rpcbind.service
