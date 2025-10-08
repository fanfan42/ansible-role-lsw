# GVT-g

## Warning

This virtualization mode is abandoned by Intel since 2020. I don't know how much time the Linux kernel will still support it.

## Known Bugs

* Debian only: Boot the VM, it won't work, you have errors 'Permission denied' on some files in the log file: /var/log/libvirt/qemu/*vm-name*lg.log. Run this command: `sudo aa-complain /etc/apparmor.d/libvirt/libvirt-fca46f9a-f8f6-45f6-8d73-28a7b7e8684f`.
* If booting on Windows from grub/systemd-boot with a dedicated disk for the VM, Windows takes the lead to boot at each reboot. You have to manually reset the boot order in your BIOS in order to boot on Linux again.
* When building on GVT-g, if you want to install Ninite packages, the display doesn't work really well, windows (not Windows) dont display. You have to follow progress by hovering the mouse on the Ninite window installer, you will see progress. When it's finished, right click and close the window, VM will shutdown and Ansible play continues as well.
* When using Looking Glass, at the very first boot, LG doesn't connect to Windows, the VM musts be shut down and restarted. At the really first boot, Windows makes some updates on its peripherals, take 2 minutes before stop and start the VM.
* Debian Only: Liquorix kernel is not the first kernel to boot every time. You have to manually boot it from grub when booting your computer.
* On Nobara, when activating the RDP for VM and launching the connection to the VM, I have "your libfreerdp does not support h264". Edit the connection in Remmina, change the value in "Color Depth" field to make it work (True Color (32bpp) for example). Try open again the VM via RDP.

## Requirements and recommendations

### Requirements

An Intel Core i*n* CPU from 6th to 10th generation with an iGPU inside. It's really important for you to verify. In laptops, all mobile Intel Core have an iGPU but on towers, Intel Core CPU may only contain the CPU. It needs a dGPU to have display on screen. My first tests on these CPU were from the 8th generation (2018) to the 10th generation (2020), I don't know how it works on older generations. i7 are recommended for better VRAM quantity but **Warcraft III reforged** and **Age of Empires II Definitive Edition** perfectly work on a i5. In the BIOS, search for a graphical option like :

* Large Aperture Graphics (Toshiba)
* Total Memory Graphics (Lenovo)

And set it to the maximum available (512MB or ~1GB of RAM). This option configures the memory allocated for the iGPU, the more allocated, the better the performance in the VM. **Note :** The role automatically creates the VM with the best option available when deploying.

Like in other virtualization modes, **Intel VT-d** and **Hyperthreading** must be activated in the BIOS.

No need for **Secure Boot** on your Linux host.

### Recommendations

* Have two mice and two keyboards connected via USB to the computer. Mousepad and internal keyboard on a laptop count in the total. So you can pass 1 mouse and 1 keyboard to the Windows VM with low latency. For a laptop, never pass the internal keyboard or mousepad. If you intend to only access to your VM via RDP, you don't need a 2nd mouse/keyboard connected.
* At least, 16GB of RAM. RAM allocated by default to the Windows VM is 8192MB. Windows 11 needs, at least, 4GB of RAM. So at least, you should need 8GB of RAM (4 for the VM) to correctly run the VM.
* Two disks, one dedicated to the Linux host, one for the Windows VM. It gives Bare Metal performance and allows **medperf** or **maxperf** playbook to be used as a base. It also allows to have a dual boot with Windows and Linux at boot. Perfect for firmware upgrades for example.

## How to use the role

### Install needed packages (only once)

Start from a working Debian/Nobara/EndeavourOS desktop with Internet working and open a terminal.

#### On Debian

```shell
$ su
# apt update && apt install ansible ansible-core git sudo gawk
# /sbin/usermod -aG sudo <your_username>
# /sbin/reboot
```

#### On EndeavourOS

```shell
$ sudo pacman -Sy ansible ansible-core git
```

#### On Nobara

```shell
$ sudo dnf install ansible ansible-core git
```

### Prepare and launch the Ansible Playbook

```shell
$ mkdir -p windowsvm/roles
$ cd windowsvm/roles
$ git clone https://github.com/fanfan42/ansible-role-lsw.git
$ cd ..
```

Follow the **README** instructions in **roles/ansible-role-lsw/files/build**, **roles/ansible-role-lsw/files/build/extra_packages** and **roles/ansible-role-lsw/files/build/virtio** directories. This step is only needed when using the **build** tag or the role will fail. So, do it only for the very first install or create again the VM from scratch.

Copy the playbook you want as a base from **roles/ansible-role-lsw/files/playbook_examples** directory (ex: `cp roles/ansible-role-lsw/files/playbook_examples/playbook-gvtg-minperf.yml gvtg.yml`).

Adapt the **vars** in the **gvtg.yml** playbook following variable documentation [here](VARIABLES.md).

**Note:** Variables in the role **vars** folder can't be overloaded in the playbook, you have to modify them directly in **roles/ansible-role-lsw/vars/*yourdistro*.yml**.

```shell
$ ansible-playbook gvtg.yml -t install -v --ask-become-pass
```

You will be asked your sudo password, enter it. For the very first install, the system reboots once. An Ansible task warns you that this action is OK and to execute again the playbook after the reboot.

After the reboot, play again the same command as above the role starts installing all the needed packages. The **install** tag is only used once. You know everything is installed when the host reboots again. Remove the **install** tag at the next step.

```shell
$ ansible-playbook gvtg.yml -t build,config,create -v --ask-become-pass
```

During the **build** stage, a window appears with a text asking if you want to boot from the CD/DVD. Please focus on the window by clicking on it, then, press "Enter" in order to boot on the CD/DVD. You will see Windows installing. You have nothing to do except if you install programs with Ninite, Windows will automatically shutdown. In case of Ninite's programs installation, you will have to click on the button "Done" when Ninite has finished, Windows will shutdown just after. If you pass a dedicated disk for the VM, the image will be copied an it. Each time you use the **build** tag, the Windows image is ERASED so consider using it only if you really want to reinstall everything from scratch.

**Note:** If you need to exit focus during the window's build: `Ctrl + Alt + g`.

The **config** stage configures Libvirt and scripts dedicated to the VM when starting or shutdown. Consider using the **config** tag everytime you just want to reset VM configuration alonside with the **create** tag.

At last, the **create** stage creates the Looking Glass VM. If you make changes on this VM on virt-manager and run again the playbook with **create** tag, all user added configurations will be removed.

By opening virt-manager, you can see the VM created, start it. For seeing the Windows VM on screen, check the [VARIABLES](VARIABLES.md) file and pick the best looking glass command for your need. You will find multiple examples on the **lsw_config_usb_mouse** variable. Example: `looking-glass-client -m 97 -F win:size=1920x1080 input:rawMouse input:GrabKeyboardOnFocus input:autoCapture`.

If your Windows is on a dedicated disk, start the VM, search "Disk management" and either:
* expand the C: drive (Not possible with Windows 11 in **normal** mode)
* or create another partition called "DATA" for example which will be mounted on `D:`.
