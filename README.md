# ansible-role-lsw

## Introduction

LSW stands for Linux Sub Windows, the reverse application of Windows WSL. The goal of this role is to allow the automatic installation of a full Windows 10/11 Pro Virtual Machine (VM) on a Linux host. The VM is customized to allow maximum performance at the price of security "features" and can be built with these virtualization technologies :

* Passthrough
* Intel GVT-g
* Intel SR-IOV

The VM built runs with QEMU+KVM and Libvirt is used to manage the VM.

This role can build the VM on 3 Linux distributions (or distros):

* Arch Linux based : EndeavourOS with lightdm + XFCE (my personal distro)
* Debian with gdm3 + GNOME
* Fedora based : Nobara with sddm + KDE

The 3 distros are not randomly chosen, I think they are the best to provide a good desktop experience and they are also designed/easy to configure for the best gaming experience on Linux (for example, Zen/Liquorix kernels are easy to install). The VM built atop of it only adds other options for gaming in case Wine/Proton don't offer good stability for some Windows games or emulators.

For my tests, I used 2 laptops :

* [Lenovo Legion Y540-15IRH](https://www.laptopspirit.fr/266282/lenovo-legion-y540-15irh-81sx003bfr-pc-portable-15-144hz-joueur-et-createurs-gtx-1660-ti.html), compatible with Passthrough and GVT-g. It has an Intel Core i7-9750H, a Nvidia Geforce GTX 1660Ti, 16GB of RAM, a NVMe drive and a SSD SATA drive.
* [Asus ROG Strix G814 (2023)](https://laptopmedia.com/fr/series/asus-rog-strix-g18-g814-2023/), compatible with Passthrough and SR-IOV. It has an Intel Core i7-13650HX and Nvidia Geforce RTX 4080, 32 GB of RAM, 2 NVMe drives.

Other recent Lenovo Thinkpad (L14 Gen3 and T16 gen3) were also used for SR-IOV virtualization. I also used old step by step on my old Github [repository](https://github.com/fanfan42/VFIO-Passthrough-dual-running-systems-on-laptop) especially to help me with AMD CPU on Passthrough virtualization mode.

Depending on the virtualization mode you want, please go and follow instructions in **documentation** directory, **example:** Passthrough.md
