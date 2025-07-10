# ansible-role-passthrough-gvtg-sriov

## Introduction

The goal of this role is to allow the automatic installation of a full Windows 10/11 Family (other variants are also possible) Virtual Machine (VM) on a Linux host. The VM is customized to allow maximum performance at the price of security "features" and can be built with these virtualization technologies :

* Passthrough
* Intel GVT-g
* Intel SR-IOV

The VM built runs with QEMU+KVM and libvirt is used to manage the VM.

For this role, I can build the VM on 4 Linux distributions (or distros):

* Arch Linux based : EndeavourOS with XFCE (my personal distro)
* Ubuntu based : Pop!_OS with (modified) GNOME
* Fedora based : Nobara with KDE
* NixOS with GNOME

I only support X11/X.org DE, no tests on Wayland. Even if it's the future, I think that Nvidia drivers are not stable enough on Wayland. The 4 distros are not randomly chosen, I think they are the best to provide a good desktop experience and they are also designed/easy to configure for the best gaming experience on Linux (for example, Zen/Liquorix kernels are easy to install). The VM built atop of it only adds other options for gaming in case Wine/Proton don't offer good stability for some Windows games. NixOS is more a POC, I can already hear NixOS users scream that Ansible is not designed to build a NixOS system. All Desktop Managers (DM) are supported. Grub2 and systemd-boot are also supported.

For my tests, I used 2 laptops :

* [Lenovo Legion Y540-15IRH](https://www.laptopspirit.fr/266282/lenovo-legion-y540-15irh-81sx003bfr-pc-portable-15-144hz-joueur-et-createurs-gtx-1660-ti.html), compatible with Passthrough and GVT-g. It has an Intel Core i7-9750H, a Nvidia Geforce GTX 1660Ti, 16GB of RAM, a NVMe drive and a SSD SATA drive.
* [Asus ROG Strix G814 (2023)](https://laptopmedia.com/fr/series/asus-rog-strix-g18-g814-2023/), compatible with Passthrough and SR-IOV. It has an Intel Core i7-13650HX and Nvidia Geforce RTX 4080, 32 GB of RAM, 2 NVMe drives.

Have fun !

## Requirements and recommendations

### Requirements for Passthrough

You need at least 2 GPU. The integrated GPU in your CPU (iGPU) will help you display your DE while the VM is running and the detached GPU (dGPU like Nvidia, AMD or Intel) will be passed (passthrough) to the VM. My tests are made with Nvidia GTX and RTX but it can perfectly be used with an AMD or Intel dGPU. For the last 2 cases, you will probably have to modify the Ansible code if you need specific options. One REALLY important point, the dGPU passed to the VM musts be a "VGA compatible controller". On your OS, run the following command: `lscpi | grep VGA`. The dGPU cannot be a "3D controller". For the case of Nvidia, most of the recent GPU (since the 10 series) that end with 50 (example: Nvidia RTX 3050) are 3D controllers, not VGA compatible controllers. In short, 3D controllers receive graphical calls from the CPU, treat it, then resend it to the CPU to be displayed via the iGPU. The 3D controller is not connected to HDMI/Display Port so it can't be passed to the VM.

In case of a Laptop (maybe for a Tower but not tested), go in the BIOS and activate an option like "Switchable Graphics". This option allows, at least on Laptops, to use the iGPU for the integrated screen and use the dGPU for all HDMI/Display ports.

**Special note for Nvidia dGPU :** On GTX cards, you will have to modify the ROM of the GPU. Don't know why but Nvidia blocked their ROMs to prevent Passthrough of their cards

### Requirements for GVT-g

An Intel Core i*n* CPU from 4th to 10th generation. My first tests on these CPU were from the 8th generation (2018) to the 10th generation (2020), I don't know how it works on older generations. i7 are recommended for better VRAM quantity but I could perfectly played **Warcraft III reforged** on a i5. In the BIOS, search for a graphical option like :

* Large Aperture Graphics (Toshiba)
* Total Memory Graphics (Lenovo)

And set it to the maximum available (~1GB of RAM). The best option only exists on Intel Core i7 CPU. This option configures the memory allocated for the iGPU, the more allocated, the better the performance in the VM. **Note :** The role automatically creates the VM with the best option available when deploying.

### Requirements for SR-IOV

An Intel Core (Ultra) i*n* from 11th to 14th generation. Since the SR-IOV is "only" available via [i915-sriov-dkms](https://github.com/strongtz/i915-sriov-dkms), the mandatory kernel used is Zen. Liquorix is installed for Pop!_OS. **Note :** Zen/Liquorix is always installed in all cases (except GVT-g), remove it from the package list if you don't want it but I can't guarantee the final result because it's not tested.

### Requirements for all cases

**Intel VT-d** or **AMD-Vi** are supported by the CPU and activated in your BIOS. **Hyperthreading** musts also be activated.

**ansible-core** and **ansible** packages are installed for this role.

This role is "only" for personal usage, the **LICENSE** associated to this role protects it from uncontrolled commercial usage so, I assume you have admin privileges on your computer.

### Recommendations for all cases

2 disks. SSD, NVMe or HDD (if you really want to suffer...). Why ? With 2 disks, this role allows a dual boot PC. The goals of this system allow :

* Firmware updates of the VM when booting on Windows. Fwupd/LVFS still don't have all the firmware updates. Also, if really needed, the best gaming performance is still on Bare Metal Laptops/Towers. It's just boring (for me) to have to reboot everytime and don't have access to my Linux, this the goal of this role.
* Better gaming performance. This role completely allows you to have an img (RAW, COW not supported) for your VM. But, especially with NVMe drives, drives are connected on PC via PCI, launching a VM with a PCI drive increases the performance of the VM so it also increases the I/O performance in the VM.

At least, 16GB of RAM. This role will, by default, split your **Host** memory in half. The other half is passed to the **Guest** (VM). Windows 11 needs, at least, 4GB of RAM. So at least, you should need 8GB of RAM (4 for the VM) to correctly run the VM. **Note:** the Lenovo laptop used has 16GB of RAM, the Asus one, 32GB. I won't test if it works on smaller RAM, again, I'm not here to suffer.

This role is tested on a fresh install of the 4 distros listed before. Do the same.

## Example of playbook and inventory to use this role

inventory file :

```ini
[localhost]
localhost ansible_host=127.0.0.1
```

Playbook file :

```yaml
- name: pgs
  hosts: localhost
  connection: local
  become: true
  roles:
    - passthrough-gvtg-sriov
 
```

## How to use the VM

Open libvirt-manager and lauch the VM
