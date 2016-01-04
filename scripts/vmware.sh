#!/bin/bash -eux

SSH_USERNAME=${SSH_USERNAME:-vagrant}

if [[ $PACKER_BUILDER_TYPE =~ vmware ]]; then
    echo "==> Installing VMware Tools"
    # Assuming the following packages are installed
    #pacman -Syu --needed --noconfirm
    # These are arch specific changes, so not putting in the patches repo
    pacman -S --needed --noconfirm wget abs
    # System /tmp isn't large enough for this operation
    mkdir -p /home/${SSH_USERNAME}/tmp
    cd /home/${SSH_USERNAME}/tmp

    # This is a fix for Arch not having SysVinit dirs
    for x in {0..6}; do mkdir -p /etc/init.d/rc${x}.d; done

    wget https://raw.githubusercontent.com/dragon788/vmware-tools-patches/master/patched-open-vm-tools.sh
    chmod +x patched-open-vm-tools.sh
    ./patched-open-vm-tools.sh

    VMWARE_TOOLBOX_CMD_VERSION=$(vmware-toolbox-cmd -v)
    echo "==> Installed VMware Tools ${VMWARE_TOOLBOX_CMD_VERSION}" 
    # These are arch specific changes, so not putting in the patches repo
    # I'm not convinced I need these service definitions, as vmtoolsd is separate
    #abs community/open-vm-tools
    #cp /var/abs/community/open-vm-tools/vmware-* /usr/lib/systemd/system
    #systemctl enable vmware-vmblock-fuse.service
    # Running the compile.sh in patched-open-vm-tools above should install and activate the 
    # vmware tools services we need for shared folders


fi
