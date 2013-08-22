#!/usr/bin/env bash

DISK='/dev/sda'
FQDN='vagrant-arch.vagrantup.com'
KEYMAP='us'
LANGUAGE='en_US.UTF-8'
NIC_DEVICE='ens33'
PASSWORD=$(/usr/bin/openssl passwd -crypt 'vagrant')
TIMEZONE='UTC'

CONFIG_SCRIPT='/usr/local/bin/arch-config.sh'
ROOT_PARTITION="${DISK}1"
TARGET_DIR='/mnt'

echo "==> clearing partition table on ${DISK}"
/usr/bin/sgdisk --zap ${DISK}

echo "==> destroying magic strings and signatures on ${DISK}"
/usr/bin/dd if=/dev/zero of=${DISK} bs=512 count=2048
/usr/bin/wipefs --all ${DISK}

echo "==> creating /root partition on ${DISK}"
/usr/bin/sgdisk --new=1:0:0 ${DISK}

echo "==> setting ${DISK} bootable"
/usr/bin/sgdisk ${DISK} --attributes=1:set:2

echo '==> creating /root filesystem (ext4)'
/usr/bin/mkfs.ext4 -F -m 0 -q -L root ${ROOT_PARTITION}

echo "==> mounting ${ROOT_PARTITION} to ${TARGET_DIR}"
/usr/bin/mount -o noatime,errors=remount-ro ${ROOT_PARTITION} ${TARGET_DIR}

echo '==> bootstrapping the base installation'
/usr/bin/pacstrap ${TARGET_DIR} base base-devel
/usr/bin/arch-chroot ${TARGET_DIR} pacman -S --noconfirm gptfdisk openssh syslinux
/usr/bin/arch-chroot ${TARGET_DIR} syslinux-install_update -i -a -m
/usr/bin/sed -i 's/sda3/sda1/' "${TARGET_DIR}/boot/syslinux/syslinux.cfg"
/usr/bin/sed -i 's/TIMEOUT 50/TIMEOUT 10/' "${TARGET_DIR}/boot/syslinux/syslinux.cfg"

echo '==> generating the filesystem table'
/usr/bin/genfstab -p ${TARGET_DIR} >> "${TARGET_DIR}/etc/fstab"

echo '==> generating the system configuration script'
/usr/bin/install --mode=0755 /dev/null "${TARGET_DIR}${CONFIG_SCRIPT}"

add_config() {
  echo "${1}" >> "${TARGET_DIR}${CONFIG_SCRIPT}"
}

add_config "echo '${FQDN}' > /etc/hostname"
add_config "/usr/bin/ln -s /usr/share/zoneinfo/${TIMEZONE} /etc/localtime"
add_config "echo 'KEYMAP=${KEYMAP}' > /etc/vconsole.conf"
add_config "/usr/bin/sed -i 's/#${LANGUAGE}/${LANGUAGE}/' /etc/locale.gen"
add_config '/usr/bin/locale-gen'
add_config '/usr/bin/mkinitcpio -p linux'
add_config "/usr/bin/usermod --password ${PASSWORD} root"
add_config "/usr/bin/useradd --password ${PASSWORD} --comment \"Vagrant User\" --create-home --gid users vagrant"
add_config "echo 'vagrant ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/10_vagrant"
add_config '/usr/bin/systemctl enable sshd.service'
add_config "/usr/bin/ln -s '/usr/lib/systemd/system/dhcpcd@.service' '/etc/systemd/system/multi-user.target.wants/dhcpcd@${NIC_DEVICE}.service'"
add_config '/usr/bin/pacman -Rcns --noconfirm gptfdisk'
add_config '/usr/bin/pacman -Scc --noconfirm'

echo '==> entering chroot and configuring system'
/usr/bin/arch-chroot ${TARGET_DIR} ${CONFIG_SCRIPT}
rm "${TARGET_DIR}${CONFIG_SCRIPT}"
/usr/bin/umount ${TARGET_DIR}
/usr/bin/systemctl reboot
