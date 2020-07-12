#!/usr/bin/bash -x

# Open VM Tools
# https://wiki.archlinux.org/index.php/VMware
# https://wiki.archlinux.org/index.php/VMware/Installing_Arch_as_a_guest
echo ">>>> install-virtualbox.sh: Installing Open-VM-Tools and NFS utilities.."
/usr/bin/pacman -S --noconfirm linux-headers open-vm-tools nfs-utils

echo ">>>> install-virtualbox.sh: Enabling Open-VM-Tools service.."
/usr/bin/systemctl enable vmtoolsd.service

echo ">>>> install-virtualbox.sh: Enabling RPC Bind service.."
/usr/bin/systemctl enable rpcbind.service
