#!/bin/bash -eux

SSH_USERNAME=${SSH_USERNAME:-vagrant}

if [[ $PACKER_BUILDER_TYPE =~ vmware ]]; then
    echo "==> Installing VMware Tools"
    # Assuming the following packages are installed
    #pacman -Syu --needed --noconfirm
    pacman -S --needed --noconfirm wget
    cd /tmp
    wget https://raw.githubusercontent.com/dragon788/vmware-tools-patches/master/patched-open-vm-tools.sh
    ./patched-open-vm-tools.sh

    VMWARE_TOOLBOX_CMD_VERSION=$(vmware-toolbox-cmd -v)
    echo "==> Installed VMware Tools ${VMWARE_TOOLBOX_CMD_VERSION}" 

fi
