# SR-IOV

## Warning

This mode is highly experimental and has many problems:

* It doesn't work well with Wayland (at least with Debian with GNOME).
* Intel has decided since August 2025 that ony Pro dGPU will be supported. So, in order for this role to work, it depends on the community.
* Despite more recent CPU with iGPU, performance is a little bit less than GVT-g.

## Troubleshooting

* Debian only: Boot the VM, it won't work, you have errors 'Permission denied' on some files in the log file: /var/log/libvirt/qemu/*vm-name*.log. Run this command: `sudo aa-complain /etc/apparmor.d/libvirt/libvirt-fca46f9a-f8f6-45f6-8d73-28a7b7e8684f`.
* If booting on Windows from grub/systemd-boot with a dedicated disk for the VM, Windows takes the lead to boot at each reboot. You have to manually reset the boot order in your BIOS in order to boot on Linux again.
* Debian only: Liquorix kernel is not the first kernel to boot every time. You have to manually boot it from grub when booting your computer.
* Intel 12th and 13th: ~~For now, only one Intel driver allows the build part working but the VM is really slow. When connected with RDP on the VM, find the **Intel Graphics Software** installed in the VM packages and install the update. Everything works fine after.~~ Found 2nd driver (september 2025) that can do the trick, see SR-IOV [VARIABLES](./VARIABLES.md) and GPU driver [README](../build/extra_packages/README.md).
* Debian with GNOMW: Display Manager resets when creating the Virtual Function (VF) when using Wayland in your Desktop Environment. Uxe X11/X.org instead when login to your distro when on Debian GNOME (the wheel at bottom right of the login screen when asking your password).
* Intel 12th and 13th: ~~On EndeavourOS, same problem as wayland above. The display will freeze around 58% of windows installation, just after the Intel driver installation. The installation has not failed but you don't see anything working. Press `Ctrl+Alt+F2`, enter your login and passsword in the console. Put a timer, set it to 10-13 minutes. Try to check with `ps aux | grep qemu` and `ps aux | grep playbook` if it's still running. If qemu is still working, `kill -9 process_number_of_qemu`. Wait for ansible to finish (`watch -n2 "ps aux | grep playbook"`). `sudo systemctl restart display-manager`. **Note:** It's also easier to not install apps from Ninite, this way, the VM shutdowns automatically and ansible continues without intervention but you still have to press `Ctrl+Alt+F2` when the screen starts freezing and wait for ansible to finish. You can still install apps from Ninite in the VM after. When you start the VM and access it with Remmina, the VM shutdowns. Restart it and access it again with Remmina (maybe multiple times until it connects). The system is really slow. Update the Intel driver quickly as explained above.~~ Virtual Display Driver may not install, it's random but not too much often. You have to install it yourself on the VM by downloading, for example, this version of [VDD Control](https://github.com/VirtualDrivers/Virtual-Display-Driver/releases/tag/25.7.23).
* On Nobara, when activating the RDP for VM and launching the connection to the VM, I have "your libfreerdp does not support h264". Edit the connection in Remmina, change the value in "Color Depth" field to make it work (True Color (32bpp) for example). Try open again the VM via RDP.
* When using Looking Glass, at the very first boot, LG doesn't connect to Windows, the VM musts be shut down and restarted. At the really first boot, Windows makes some updates on its peripherals, take 2 minutes before stop and start the VM. Going on the OS via RDP (Remmina) first can also help especially to correctly initiate the first install of Virtual Display Driver.

**Note 1:** For now, Intel Core i7-1255U (12th generation Alder Lake), Intel Core i7-13650HX (13th generation Raptor Lake) and Intel Core Ultra i7-155U (14th generation Meteor Lake) didn't need any ROM file for the Vitual Function to work in the VM, as documented in Strongtz i915-sriov-dkms repository.

**Note 2:** Intel Core Ultra 155U works really well. No freeze during the build, no need to update the Intel driver after installation. It's pretty good in fact. ~~And finally, the oldest SR-IOV CPU generation tested (12th for me), the highest the pain~~.

## Requirements and recommendations

### Requirements

An Intel Core (Ultra) i*n* CPU from 11th generation or more with an iGPU inside. It's really important for you to verify. In laptops, all mobile Intel Core (Ultra) have an iGPU but on towers, Intel Core (Ultra) CPU may only contain the CPU. It needs a dGPU to have display on screen. My first tests on these CPU were from the 12th generation to the 13th generation for Intel Core and 14th generation for Intel Core Ultra, I don't know how it works on other CPU. In the BIOS, search for an option like SR-IOV and activate it. The option doesn't always exists so don't worry if you don't find it. Still in the BIOS, search for a graphical option like : Total Memory Graphics (Lenovo). And set it to the maximum available to have better performance at the cost of RAM.

Like in other virtualization modes, **Intel VT-d** and **Hyperthreading** must be activated in the BIOS.

No need for **Secure Boot** on your Linux host.

### Recommendations

* Have two mice and two keyboards connected via USB to the computer. Mousepad and internal keyboard on a laptop count in the total. So you can pass 1 mouse and 1 keyboard to the Windows VM with low latency. For a laptop, never pass the internal keyboard or mousepad. **Note:** If only using RDP, these devices are completely unavailable. If you intend to only access to your VM via RDP, you don't need a 2nd mouse/keyboard connected.
* At least, 16GB of RAM. RAM allocated by default to the Windows VM is 8192MB. Windows 11 needs, at least, 4GB of RAM. So at least, you should need 8GB of RAM (4 for the VM) to correctly run the VM.
* Two disks, one dedicated to the Linux host, one for the Windows VM. It gives Bare Metal performance and allows **medperf** or **maxperf** playbook to be used as a base. It also allows to have a dual boot with Windows and Linux at boot. Perfect for firmware upgrades for example.
* Build and use the VM on a X11 DE (EndeavourOS with XFCE for example). Use Wayland at your own risks.
* Set the var **lsw_windows_activate_rdp** to true and also set a password for the VM (**lsw_windows_password**) or deal with bugs at your own risks. Remmina will help you after VM build to update the driver if necessary and manually install Virtual Display Driver. If everything works, Looking Glass will be available and you have won.

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

Copy the playbook you want as a base from **roles/ansible-role-lsw/files/playbook_examples** directory (ex: `cp roles/ansible-role-lsw/files/playbook_examples/playbook-sriov-minperf.yml sriov.yml`).

Adapt the **vars** in the **sriov.yml** playbook following variable documentation [here](VARIABLES.md).

**Note:** Variables in the role **vars** folder can't be overloaded in the playbook, you have to modify them directly in **roles/ansible-role-lsw/vars/*yourdistro*.yml**.

```shell
$ ansible-playbook sriov.yml -t install -v --ask-become-pass
```

You will be asked your sudo password, enter it. For the very first install, the system reboots once. An Ansible task warns you that this action is OK and to execute again the playbook after the reboot.

After the reboot, play again the same command as above, the role starts installing all the needed packages. The **install** tag is only used once. You know everything is installed when the host reboots again. Remove the **install** tag at the next step.

```shell
$ ansible-playbook sriov.yml -t build,config,create -v --ask-become-pass
```

During the **build** stage, a window appears with a text asking if you want to boot from the CD/DVD. Please focus on the window by clicking on it, then, press "Enter" in order to boot on the CD/DVD. You will see Windows installing. You have nothing to do except if you install programs with Ninite, Windows will automatically shutdown. In case of Ninite's programs installation, you will have to click on the button "Done" when Ninite has finished, Windows will shutdown just after. If you pass a dedicated disk for the VM, the image will be copied an it. Each time you use the **build** tag, the Windows image is ERASED so consider using it only if you really want to reinstall everything from scratch.

**Note:** If you need to exit focus during the window's build: `Ctrl + Alt + g`.

The **config** stage configures Libvirt and scripts dedicated to the VM when starting or shutdown. Consider using the **config** tag everytime you just want to reset VM configuration alonside with the **create** tag.

At last, the **create** stage creates the VM. If you make changes by hand on this VM on virt-manager and run again the playbook with **create** tag, all user added configurations will be removed.

By opening virt-manager, you can see the VM created, start it. To access the VM, open Remmina and double click on your VM name to open a RDP connection to the VM. If everything worked well, including Troubleshooting, stop the VM and start it againg, Looking Glass should now work (Best performance). Examples for using Looking Glass are in [variables](./VARIABLES.md) documentation, search for the variable **lsw_config_usb_mouse**. Example: `looking-glass-client -m 97 -F win:size=1920x1080 input:rawMouse input:GrabKeyboardOnFocus input:autoCapture`.

If your Windows is on a dedicated disk, start the VM, search "Disk management" and either:

* expand the C: drive (Not possible with Windows 11 in **normal** mode).
* or create another partition called "DATA" for example which will be mounted on `D:`.
