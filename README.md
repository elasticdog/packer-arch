Packer Arch
===========

Packer Arch is a bare bones [Packer](https://www.packer.io/) template and
installation script that can be used to generate a [Vagrant](https://www.vagrantup.com/)
base box for [Arch Linux](https://www.archlinux.org/). The template works
with the default VirtualBox provider as well as with
[VMware](https://www.vagrantup.com/vmware), [Parallels](https://github.com/Parallels/vagrant-parallels)
and [libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt) providers.

Overview
--------

My goal was to roughly duplicate the attributes from a
[DigitalOcean](https://www.digitalocean.com/) Arch Linux droplet:

* 64-bit
* 20 GB disk
* 512 MB memory
* Only a single /root partition (ext4)
* No swap
* Includes the `base` meta package and `base-devel` group
* OpenSSH is also installed and enabled on boot

The installation script follows the
[official installation guide](https://wiki.archlinux.org/index.php/Installation_Guide)
pretty closely, with a few tweaks to ensure functionality within a VM. Beyond
that, the only customizations to the machine are related to the vagrant user
and the steps recommended for any base box.

Usage
-----

### VirtualBox Provider

Assuming that you already have Packer,
[VirtualBox](https://www.virtualbox.org/), and Vagrant installed, you
should be good to clone this repo and go:

    $ git clone https://github.com/elasticdog/packer-arch.git
    $ cd packer-arch/
    $ packer build -only=virtualbox-iso arch-template.json

Then you can import the generated box into Vagrant:

    $ vagrant box add arch output/packer_arch_virtualbox.box

### VMware Provider

Assuming that you already have Packer,
[VMware Fusion](https://www.vmware.com/products/fusion/) (or
[VMware Workstation](https://www.vmware.com/products/workstation/)), and
Vagrant with the VMware provider installed, you should be good to clone
this repo and go:

    $ git clone https://github.com/elasticdog/packer-arch.git
    $ cd packer-arch/
    $ packer build -only=vmware-iso arch-template.json

Then you can import the generated box into Vagrant:

    $ vagrant box add arch output/packer_arch_vmware.box

### Parallels Provider

Assuming that you already have Packer,
[Parallels](http://www.parallels.com/), [Parallels SDK](http://www.parallels.com/eu/products/desktop/download/) and
Vagrant with the Parallels provider installed, you should be good to clone
this repo and go:

    $ git clone https://github.com/elasticdog/packer-arch.git
    $ cd packer-arch/
    $ packer build -only=parallels-iso arch-template.json

Then you can import the generated box into Vagrant:

    $ vagrant box add arch output/packer_arch_parallels.box

### libvirt Provider

Assuming that you already have Packer, Vagrant with the
[vagrant-libvirt](https://github.com/vagrant-libvirt/vagrant-libvirt)
plugin installed, you should be good to clone
this repo and go:

    $ git clone https://github.com/elasticdog/packer-arch.git
    $ cd packer-arch/
    $ packer build -only=qemu arch-template.json

Then you can import the generated box into Vagrant:

    $ vagrant box add arch output/packer_arch_libvirt.box

NOTE: libvirt support is limited to QEMU/KVM only.

### wrapacker

For convenience, there is a wrapper script named `wrapacker` that will run the
appropriate `packer build` command for you that will also automatically ensure
the latest ISO download URL and optionally use a mirror from a provided country
code in order to build the final box.

    $ wrapacker --country US --dry-run

For debugging purposes, execute:

    $ PACKER_LOG=1 ./wrapacker --country=US --provider=virtualbox --on-error=ask --force

See the `--help` flag for additional details.

Known Issues
------------

### VMware Tools

The official VMware Tools do not currently support Arch Linux, and the
[Open Virtual Machine Tools](https://github.com/vmware/open-vm-tools)
(open-vm-tools) require extensive patching in order to compile correctly
with a Linux 3.11 series kernel. So for the time being, I have not
included support for the tools.

No tools means that the shared folder feature will not work, and when you
run `vagrant up` to launch a VM based on the VMware box, you will see the
following error message:

> The HGFS kernel module was not found on the running virtual machine.
> This must be installed for shared folders to work properly. Please
> install the VMware tools within the guest and try again. Note that
> the VMware tools installation will succeed even if HGFS fails
> to properly install. Carefully read the output of the VMware tools
> installation to verify the HGFS kernel modules were installed properly.

Note that _this issue does not apply to VirtualBox_, as their official
guest additions work just fine.

### Vagrant Provisioners

The box purposefully does not include Puppet, Chef or Ansible for automatic Vagrant
provisioning. My intention was to duplicate a DigitalOcean VPS and
furthermore use the VM for testing [Ansible](http://www.ansible.com/)
playbooks for configuration management.

License
-------

Packer Arch is provided under the terms of the
[ISC License](https://en.wikipedia.org/wiki/ISC_license).

Copyright &copy; 2013&#8211;2017, [Aaron Bull Schaefer](mailto:aaron@elasticdog.com).
