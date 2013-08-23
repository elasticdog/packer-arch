Packer Arch
===========

Packer Arch is a bare bones [Packer](http://www.packer.io/) template and
installation script that can be used to generate a [Vagrant](http://www.vagrantup.com/)
base box for [Arch Linux](https://www.archlinux.org/). The template was
designed specifically for use with the [VMware provider](http://www.vagrantup.com/vmware),
although it shouldn't need too much tweaking to generate a VirtualBox VM.

Overview
--------

My goal was to roughly duplicate the attributes from a
[DigitalOcean](https://www.digitalocean.com/) Arch Linux droplet:

* 64-bit
* 20 GB disk
* 512 MB memory
* Only a single /root partition (ext4)
* No swap
* Includes the `base` and `base-devel` package groups
* OpenSSH is also installed and enabled on boot

The installation script follows the
[official installation guide](https://wiki.archlinux.org/index.php/Installation_Guide)
pretty closely, with a few tweaks to ensure functionality within a VM. Beyond
that, the only customizations to the machine are related to the vagrant user
and the steps recommended for any base box.

Usage
-----

Assuming that you already have Packer, VMware Fusion (or VMware Workstation),
and Vagrant with the VMware provider installed, you should be good to clone
this repo and go:

    $ git clone https://github.com/elasticdog/packer-arch.git
    $ cd packer-arch/
    $ packer build arch-template.json

Then you can import the generated box into Vagrant:

    $ vagrant box add arch packer_vmware_vmware.box

Known Issues
------------

The official VMware Tools do not currently support Arch Linux, and the
[Open Virtual Machine Tools](http://open-vm-tools.sourceforge.net/)
(open-vm-tools) require extensive patching in order to compile correctly
with a Linux 3.10 series kernel. So for the time being, I have not
included support for the tools.

No tools means that the shared folder feature will not work, and when you
run `vagrant up` to launch a VM based on this box, you will see the
following error message:

> The HGFS kernel module was not found on the running virtual machine.
> This must be installed for shared folders to work properly. Please
> install the VMware tools within the guest and try again. Note that
> the VMware tools installation will succeed even if HGFS fails
> to properly install. Carefully read the output of the VMware tools
> installation to verify the HGFS kernel modules were installed properly.

License
-------

Packer Arch is provided under the terms of the
[ISC License](https://en.wikipedia.org/wiki/ISC_license).

Copyright &copy; 2013, [Aaron Bull Schaefer](mailto:aaron@elasticdog.com).
