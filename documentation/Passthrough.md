# Passthrough

## Requirements and recommendations

### Requirements

* You need at least 2 GPU. The integrated GPU in your CPU (iGPU) will help you display your Desktop Eenvironment (DE) while the VM is running and the detached GPU (dGPU like Nvidia, AMD or Intel) will be passed (passthrough) to the VM (Note: a tower with 2 dGPU can also do the job). My tests are made with Nvidia GTX and RTX but it can perfectly be used with an AMD (not tested) or Intel (not tested) dGPU. One REALLY important point, the dGPU passed to the VM musts be a "VGA compatible controller". On your OS, run the following command: `lscpi | grep VGA`. The dGPU cannot be a "3D controller".
* Two screens, one connected to the iGPU, for a laptop, it can only be the integrated screen. The other connected on the dGPU. On a laptop, HDMI, Display Port or USB-C ports are connected to the dGPU.
* In case of a Laptop (maybe for a Tower but not tested), go in the BIOS and activate an option like "Switchable Graphics", set it to something like "Dynamic".
* Like in other virtualization modes, **Intel VT-d** (or **AMD-Vi**) and **Hyperthreading** must be activated in the BIOS.
* No need for **Secure Boot** on your Linux host.
* If you want to also install Looking Glass, you will need to buy a "Dummy HDMI Plug" on your favorite retailer and plug it in the HDPI port before staring the VM. It costs less than 10 bucks.

### Recommendations

* Have two mice and two keyboards connected via USB to the computer. Mousepad and internal keyboard on a laptop count in the total. So you can pass 1 mouse and 1 keyboard to the Windows VM with low latency.
* At least, 16GB of RAM. RAM allocated by default to the Windows VM is 8192MB. For information, Windows 11 needs, at least, 4GB of RAM and you cannot use more than 3/4 of your Linux host maximum RAM.
* Two disks, one dedicated to the Linux host, one for the Windows VM. It gives Bare Metal perforamce and allows **medperf** or **maxperf** playbook to be used as a base. It also allows to have a dual boot with Windows and Linux at boot. Perfect for firmware upgrades for example.

### How to use the role

#### Install needed packages (only once)

Start from a working Debian/Nobara/EndeavourOS desktop with Internet and (proprietary) Nvidia/AMD/Intel dGPU driver installed and working (your second screen works and is connected to your dGPU). Open a terminal.

##### On Debian

```shell
$ su
# apt update && apt install ansible ansible-core git sudo gawk
# usermod -aG sudo `whoami`
# reboot
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
$ git clone https://github.com/fanfan42/ansible-role-pgs.git
$ cd ..
```

Follow the **README** instructions in **roles/ansible-role-pgs/build**, **roles/ansible-role-pgs/build/extra_packages** and **roles/ansible-role-pgs/build/virtio** directories. This step is only needed when using the **build** tag or the role will fail. So, do it only for the very first install or create again the VM from scratch.

**Special note for Nvidia GTX dGPU :** On GTX cards, you will have to modify the ROM of the GPU. Don't know why but Nvidia blocked their ROMs to prevent Passthrough of their cards. Please follow this guide [here](PATCH_NVIDIA_FW.md) to generate a patched ROM and copy it in **roles/ansible-role-pgs/files/patched-bios.rom**. 

Copy the playbook you want as a base from **roles/ansible-role-pgs/playbook_examples** directory (ex: `cp roles/ansible-role-pgs/playbook_examples/playbook-passthrough-minperf.yml passthrough.yml`).

Adapt the **vars** in the **passthrough.yml** playbook following variable documentation [here](VARIABLES.md).

**Note:** Variables in the role **vars** folder can't be overloaded in the playbook, you have to modify them directly in **roles/ansible-role-pgs/vars/*yourdistro*.yml**.

```shell
$ ansible-playbook gvtg.yml -t install,build,config,create -v --ask-become-pass
```

You will be asked your sudo password, enter it. For the very first install or **build** tag usage, the system reboots once. An Ansible task warns you that this action is OK and to execute again the playbook after the reboot. After reboot, the screen atatched to the dGPU doesn't display anything. It's normal.

After the reboot, the role starts installing all the needed packages. The **install** tag is only used once. If you need to run again the playbook, you can remove it. You know everything is installed when you enter the **build** stage.

During the **build** stage, a window appears with a text asking if you want to boot from the CD/DVD. Please focus on the window by clicking on it, then, press "Enter" in order to boot on the CD/DVD. You will see Windows installing. You have nothing to do except if you install programs with Ninite, Windows will automatically shutdown. In case of Ninite's programs installation, you will have to click on the button "OK" when Ninite has finished, Windows will shutdown just after. If you pass a dedicated disk for the VM, the image will be copied an it. Each time you use the **build** tag, the Windows image is ERASED so consider using it only if you really want to reinstall everything from scratch.

**Note 1:** If you need to exit focus during the window's build: `Ctrl + Alt + g`.

**Note 2:** During the build, the second screen attached to the dGPU will display Windows installation after some time. It means the GPU driver has been succesfully installed during the image build.

The **config** stage configures Libvirt and scripts dedicated to the VM when starting or shutdown. Consider using the **config** tag everytime you just want to reset VM configuration alonside with the **create** tag.

At last, the **create** stage creates the Passthrough VM. If Looking Glass has been set to be installed, you also have a second VM that ends with "lg". The 2 VM share the same disk and same EFI variables files. If you make changes on these VM on virt-manager and run again the playbook with **create** tag, all user added configurations will be reset.

By opening virt-manager, you can see the VM created, start it. Your Display Manager (DM) will stop, some scripts are executed and DM starts again. The VM displays on the second screen. For seeing the Windows VM on 1st screen with Looking Glass, check the [VARIABLES](VARIABLES.md) file and pick the best looking glass command for your need. You will find multiple examples on the **pgs_config_usb_mouse** variable. Example: `looking-glass-client -m 97 -F win:size=1920x1080 input:rawMouse input:GrabKeyboardOnFocus input:autoCapture`. When the VM stops, DM also restarts.

If your Windows is on a dedicated disk, start the VM, search "Disk management" and either:
* expand the C: drive (Not possible with Windows 11 in **normal** mode)
* create another partition called "DATA" for example which will be mounted on D:

### Known Bugs

* Debian only: Boot the 2 VM, one adter the other, it won't work, you have errors 'Permission denied' on some files in the log file: /var/log/libvirt/qemu/*vm-name*.log. Run this command: `sudo aa-complain /etc/apparmor.d/libvirt/libvirt-94d6959d-b1ae-4ba9-8a9f-4aa60563e40f`. If you also have the Looking Glass VM, run: `sudo aa-complain /etc/apparmor.d/libvirt/libvirt-fca46f9a-f8f6-45f6-8d73-28a7b7e8684f`
* If booting on Windows from grub/systemd-boot with a dedicated disk for the VM, Windows takes the lead to boot at each reboot. You have to manually reset the boot order in your BIOS in order to boot on Linux again.
* When using Looking Glass, at the very first boot, LG doesn't connect to Windows, the VM musts be shut down and restarted. At the really first boot, Windows makes some updates on its peripherals, take 2 minutes before stop and start the VM.
* On Debian and EndeavourOS, the task which creates and (auto)start the default network silently fails and the VM won't boot. Please run: `sudo virsh net-autostart default && sudo virsh net-start default`
* Nobara with sddm or sddm DM: for still unknown reasons, sometimes, you have to write again your password when the VM shutdowns and sddm restarts as well (sddm issue).
* The passthrough VM may have not any sound. The only way I found to get it back was to re build the VM with the **build** tag. Please ensure that gpudriver.exe is really for your card and system.
