# SR-IOV

## Warning

This mode is highly experimental and is the worst in terms of performance because there is no way to run the VM without activating RDP in the Windows VM.

## Requirements and recommendations

### Requirements

An Intel Core (Ultra) i*n* CPU from 11th generation or more with an iGPU inside. It's really important for you to verify. In laptops, all mobile Intel Core (Ultra) have an iGPU but on towers, Intel Core (Ultra) CPU may only contain the CPU. It needs a dGPU to have display on screen. My first tests on these CPU were from the 12th generation to the 13th generation for Intel Core and 14th generation for Intel Core Ultra, I don't know how it works on other CPU. In the BIOS, search for an option like SR-IOV and activate it. The option doesn't always exists so don't worry if you don't find it.

Like in other virtualization modes, **Intel VT-d** and **Hyperthreading** must be activated in the BIOS.

No need for **Secure Boot** on your Linux host.

### Recommendations

* At least, 16GB of RAM. RAM allocated by default to the Windows VM is 8192MB. Windows 11 needs, at least, 4GB of RAM. So at least, you should need 8GB of RAM (4 for the VM) to correctly run the VM.
* Two disks, one dedicated to the Linux host, one for the Windows VM. It gives Bare Metal perforamce and allows **medperf** or **maxperf** playbook to be used as a base. It also allows to have a dual boot with Windows and Linux at boot. Perfect for firmware upgrades for example.

### How to use the role

#### Install needed packages (only once)

Start from a working Debian/Nobara/EndeavourOS desktop with Internet working and open a terminal.

##### On Debian

```shell
$ su
# apt update && apt install ansible ansible-core git sudo gawk
# /sbin/usermod -aG sudo <your_username>
# /sbin/reboot
```

##### On EndeavourOS

```shell
$ sudo pacman -Sy ansible ansible-core git
```

##### On Nobara

```shell
$ sudo dnf install ansible ansible-core git
```

#### Prepare and launch the Ansible Playbook

```shell
$ mkdir -p windowsvm/roles
$ cd windowsvm/roles
$ git clone https://github.com/fanfan42/ansible-role-lsw.git
$ cd ..
```

Follow the **README** instructions in **roles/ansible-role-lsw/build**, **roles/ansible-role-lsw/build/extra_packages** and **roles/ansible-role-lsw/build/virtio** directories. This step is only needed when using the **build** tag or the role will fail. So, do it only for the very first install or create again the VM from scratch.

Copy the playbook you want as a base from **roles/ansible-role-lsw/playbook_examples** directory (ex: `cp roles/ansible-role-lsw/playbook_examples/playbook-sriov-minperf.yml sriov.yml`).

Adapt the **vars** in the **sriov.yml** playbook following variable documentation [here](VARIABLES.md).

**Note:** Variables in the role **vars** folder can't be overloaded in the playbook, you have to modify them directly in **roles/ansible-role-lsw/vars/*yourdistro*.yml**.

```shell
$ ansible-playbook sriov.yml -t install,build,config,create -v --ask-become-pass
```

You will be asked your sudo password, enter it. For the very first install or **build** tag usage, the system reboots once. An Ansible task warns you that this action is OK and to execute again the playbook after the reboot.

After the reboot, the role starts installing all the needed packages. The **install** tag is only used once. You know everything is installed when the host reboots again. Remove the **install** tag.

During the **build** stage, a window appears with a text asking if you want to boot from the CD/DVD. Please focus on the window by clicking on it, then, press "Enter" in order to boot on the CD/DVD. You will see Windows installing. You have nothing to do except if you install programs with Ninite, Windows will automatically shutdown. In case of Ninite's programs installation, you will have to click on the button "OK" when Ninite has finished, Windows will shutdown just after. If you pass a dedicated disk for the VM, the image will be copied an it. Each time you use the **build** tag, the Windows image is ERASED so consider using it only if you really want to reinstall everything from scratch.

**Note:** If you need to exit focus during the window's build: `Ctrl + Alt + g`

The **config** stage configures Libvirt and scripts dedicated to the VM when starting or shutdown. Consider using the **config** tag everytime you just want to reset VM configuration alonside with the **create** tag.

At last, the **create** stage creates the VM. If you make changes on this VM on virt-manager and run again the playbook with **create** tag, all user added configurations will be reset.

By opening virt-manager, you can see the VM created, start it. To access the VM, open Remmina and double click on your VM name to open a RDP connection to the VM.

If your Windows is on a dedicated disk, start the VM, search "Disk management" and either:

* expand the C: drive (Not possible with Windows 11 in **normal** mode)
* or create another partition called "DATA" for example which will be mounted on D:

### Known Bugs

* If booting on Windows from grub/systemd-boot with a dedicated disk for the VM, Windows takes the lead to boot at each reboot. You have to manually reset the boot order in your BIOS in order to boot on Linux again.
* Debian Only: Liquorix kernel is not the first kernel to boot every time. You have to manually boot it from grub when booting your computer.
* Windows 10 doesn't work. Windows 11 24H2 works.
* For now, only one Intel driver allows the build part working but the VM is really slow. When connected with RDP on the VM, find the **Intel Graphics Software** installed in the VM packages and install the update. Everything works fine after.
* System freezes when using Wayland. Uxe X11/X.org instead when login to your distro.
