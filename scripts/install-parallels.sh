#!/usr/bin/bash -x

# Parallels Tools
# https://wiki.archlinux.org/index.php/Parallels
echo ">>>> install-virtualbox.sh: Installing Parallels Tools.."
mount /dev/sr1 /mnt
ln -sf /usr/lib/systemd/scripts/ /etc/init.d
export def_sysconfdir=/etc/init.d
touch /etc/X11/xorg.conf
pacman -S --noconfirm python2 linux-headers
ln -sf /usr/bin/python2 /usr/local/bin/python
/mnt/install --install-unattended

# clean up
echo ">>>> install-virtualbox.sh: Cleaning Up.."
umount /dev/sr1
/usr/bin/pacman -Rcns --noconfirm python2 linux-headers
rm -f /etc/init.d
rm -f /etc/X11/xorg.conf
rm -f /usr/local/bin/python
