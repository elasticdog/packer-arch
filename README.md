Packer Arch
===========

Packer Arch is a bare bones [Packer](https://www.packer.io/) template and
installation script that can be used to generate a [Vagrant](https://www.vagrantup.com/)
base box for [Arch Linux](https://www.archlinux.org/). The template works
with the default VirtualBox provider as well as with
[VMware](http://www.vagrantup.com/vmware) and [Parallels](https://github.com/Parallels/vagrant-parallels) providers.

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

dragon788 has built the VMware and Virtualbox versions on Hashicorp's [Atlas build service](https://atlas.hashicorp.com)

### VirtualBox Provider

Assuming that you already have Packer,
[VirtualBox](https://www.virtualbox.org/), and Vagrant installed, you can jump right in
with:

    vagrant init dragon788/arch-ala-elasticdog; vagrant up --provider virtualbox

Or if you want to customize the box you can clone this repo and go:

    $ git clone https://github.com/elasticdog/packer-arch.git
    $ cd packer-arch/
    $ packer build -only=virtualbox-iso arch-template.json

Then you can import the generated box into Vagrant:

    $ vagrant box add arch packer_arch_virtualbox.box

### VMware Provider

Assuming that you already have Packer,
[VMware Fusion](https://www.vmware.com/products/fusion/) (or
[VMware Workstation](https://www.vmware.com/products/workstation/)), and Vagrant
with the VMware provider plugin and license installed, you can jump right in

    vagrant init dragon788/arch-ala-elasticdog; vagrant up --provider vmware_desktop

Or if you want to customize the box you can clone this repo and go:

    $ git clone https://github.com/elasticdog/packer-arch.git
    $ cd packer-arch/
    $ packer build -only=vmware-iso arch-template.json

Then you can import the generated box into Vagrant:

    $ vagrant box add arch packer_arch_vmware.box

### Parallels Provider

Assuming that you already have Packer,
[Parallels](http://www.parallels.com/), [Parallels SDK](http://www.parallels.com/eu/products/desktop/download/) and
Vagrant with the Parallels provider installed, you should be good to clone
this repo and go:

    $ git clone https://github.com/elasticdog/packer-arch.git
    $ cd packer-arch/
    $ packer build -only=parallels-iso arch-template.json

Then you can import the generated box into Vagrant:

    $ vagrant box add arch packer_arch_parallels.box

### wrapacker

For convenience, there is a wrapper script named `wrapacker` that will run the
appropriate `packer build` command for you that will also automatically ensure
the latest ISO download URL and optionally use a mirror from a provided country
code in order to build the final box.

    $ wrapacker --country US --dry-run

See the `--help` flag for additional details.

If run without options it will attempt to build both virtualbox and VMware,
otherwise you can specify a provider with --provider at the command line.

Known Issues
------------

### VMware Tools

[dragon788](https://github.com/dragon788) has worked on getting the
[vmware-tools-patches](https://github.com/rasa/vmware-tools-patches)
working with Arch and systemd and has [successfully built it](https://github.com/dragon788/vmware-tools-patches) into the VMware version of this box.

The official VMware Tools do not currently support Arch Linux, and the
[Open Virtual Machine Tools](http://open-vm-tools.sourceforge.net/)
(open-vm-tools) require extensive patching in order to compile correctly
with a Linux 3.11 series kernel though newer releases are working with
4.2+ kernels.

If the kernel version changes this may "break" the tools which means that
the shared folder feature will not work, and when you run `vagrant up` to
launch a VM from the VMware box, you may see the following error message:

> The HGFS kernel module was not found on the running virtual machine.
> This must be installed for shared folders to work properly. Please
> install the VMware tools within the guest and try again. Note that
> the VMware tools installation will succeed even if HGFS fails
> to properly install. Carefully read the output of the VMware tools
> installation to verify the HGFS kernel modules were installed properly.

Note that _this issue does not apply to VirtualBox_, as their official
guest additions work just fine.

### Vagrant Provisioners

The box purposefully does not include Puppet or Chef for automatic Vagrant
provisioning. My intention was to duplicate a DigitalOcean VPS and
furthermore use the VM for testing [Ansible](http://www.ansibleworks.com/)
playbooks for configuration management.

License
-------

Packer Arch is provided under the terms of the
[ISC License](https://en.wikipedia.org/wiki/ISC_license).

Copyright &copy; 2013&#8211;2015, [Aaron Bull Schaefer](mailto:aaron@elasticdog.com).
