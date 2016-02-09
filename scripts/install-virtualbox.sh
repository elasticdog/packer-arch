#!/usr/bin/bash -x

# VirtualBox Guest Additions
# https://wiki.archlinux.org/index.php/VirtualBox
/usr/bin/pacman -S --noconfirm linux-headers virtualbox-guest-utils virtualbox-guest-dkms nfs-utils
echo -e 'vboxguest\nvboxsf\nvboxvideo' > /etc/modules-load.d/virtualbox.conf
guest_version=$(/usr/bin/pacman -Q virtualbox-guest-dkms | awk '{ print $2 }' | cut -d'-' -f1)
kernel_version="$(/usr/bin/pacman -Q linux | awk '{ print $2 }')-ARCH"
/usr/bin/dkms install "vboxguest/${guest_version}" -k "${kernel_version}/x86_64"
/usr/bin/systemctl enable dkms.service
/usr/bin/systemctl enable vboxservice.service
/usr/bin/systemctl enable rpcbind.service

# Add groups for VirtualBox folder sharing
/usr/bin/groupadd vagrant
/usr/bin/usermod --append --groups vagrant,vboxsf vagrant
