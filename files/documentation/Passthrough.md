# Passthrough

## Troubleshooting

* If booting on Windows from grub/systemd-boot with a dedicated disk for the VM, Windows takes the lead to boot at each reboot. You have to manually reset the boot order in your BIOS in order to boot on Linux again.
* When using Looking Glass, at the very first boot, LG doesn't connect to Windows, the VM musts be shut down and restarted. At the really first boot, Windows makes some updates on its peripherals, take 2 minutes before stop and start the VM.
* Nobara with sddm or sddm DM: for still unknown reasons, sometimes, you have to write again your password when the VM shutdowns and sddm restarts as well (sddm issue).
* The passthrough VM may have not any sound. It's because your GPU doesn't support the software reset on its sound card part but sometimes it works, don't ask me why (at least it worked in October 2025 so maybe try with a GPU driver of that time). You have two solutions, either you set **lsw_config_add_bluetooth** to **true** and don't forget to set **lsw_config_bluetooth_address** with the correct USB address (use lsusb to find the bluetooth device in a terminal). Either, you set **lsw_passthrough_force_sound** to **true**. You will have the sound from your host internal sound card but not on your second screen.
* On Nobara, when activating the RDP for VM and launching the connection to the VM, I have "your libfreerdp does not support h264". Edit the connection in Remmina, change the value in "Color Depth" field to make it work (True Color (32bpp) for example). Try open again the VM via RDP.

## Requirements and recommendations

### Requirements

* You need at least 2 GPU. The integrated GPU in your CPU (iGPU) will help you display your Desktop Environment (DE) while the VM is running and the detached GPU (dGPU like Nvidia, AMD or Intel) will be passed (passthrough) to the VM (**Note:** a tower with 2 dGPU can also do the job). My tests are made with Nvidia GTX and RTX but it can perfectly be used with an AMD (not tested) or Intel dGPU (not tested). One REALLY important point, the dGPU passed to the VM musts be a "VGA compatible controller". On your OS, run the following command: `lscpi | grep VGA`. The dGPU cannot be a "3D controller".
* Two screens, one connected to the iGPU. For a laptop, it can only be the integrated screen. The other connected on the dGPU. On a laptop, HDMI, Display Port or USB-C ports are connected to the dGPU.
* In case of a Laptop (maybe for a Tower but not tested), go in the BIOS and activate an option like "Switchable Graphics", set it to something like "Dynamic".
* Like in other virtualization modes, **Intel VT-d** (or **AMD-Vi**) and **Hyperthreading** must be activated in the BIOS.
* No need for **Secure Boot** on your Linux host.
* If you want to also install Looking Glass, you will need to buy a "Dummy HDMI Plug" (or Dummy USB-C Plug) on your favorite retailer and plug it in the HDMI port before staring the VM. It costs less than 10 bucks. **Note:** it's also "possible" to install [Virtual Display Driver](https://github.com/VirtualDrivers/Virtual-Display-Driver) like in SR-IOV mode but I didn't make it possible in the code because of performance reasons. Install it by yourself if you need it and don't want to buy the Dummy HDMI Plug.

### Recommendations

* Have two mice and two keyboards connected via USB to the computer (or screen). Mousepad and internal keyboard on a laptop count in the total. So you can pass 1 mouse and 1 keyboard to the Windows VM with low latency. For a laptop, never pass the internal keyboard or mousepad. If you intend to only access to your VM via RDP, you don't need a 2nd mouse/keyboard connected.
* 16GB of RAM. RAM allocated by default to the Windows VM is 8192MB. For information, Windows 11 needs, at least, 4GB of RAM and you cannot use more than 4/5 of your Linux host maximum RAM.
* Two disks, one dedicated to the Linux host, one for the Windows VM. It gives Bare Metal performance and allows **medperf** or **maxperf** playbook to be used as a base. It also allows to have a dual boot with Windows and Linux at boot. Perfect for firmware upgrades for example.

## How to use the role

### Install needed packages (only once)

Start from a working Debian/Nobara/EndeavourOS desktop with Internet and (proprietary) Nvidia/AMD/Intel dGPU driver installed and working (your second screen works and is connected to your dGPU). For Nvidia, it's highly recommmend to have the DKMS (akmod by default on Nobara) Nvidia driver installed. Open a terminal.

Note: For Nvidia on Debian, in order to have the latest driver, use this [guide](https://forums.developer.nvidia.com/t/5090-working-on-debian-13-with-nvidia-open-driver-version-580-95-05/347268).

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

Copy the playbook you want as a base from **roles/ansible-role-lsw/files/playbook_examples** directory (ex: `cp roles/ansible-role-lsw/files/playbook_examples/playbook-passthrough-minperf.yml passthrough.yml`).

Adapt the **vars** in the **passthrough.yml** playbook following variable documentation [here](VARIABLES.md).

**Note:** Variables in the role **vars** folder can't be overloaded in the playbook, you have to modify them directly in **roles/ansible-role-lsw/vars/*yourdistro*.yml**.

```shell
$ ansible-playbook passthrough.yml -t install,build,config,create -v --ask-become-pass
```

You will be asked your sudo password, enter it. For the very first install or **build** tag usage, the system reboots once. An Ansible task warns you that this action is OK and to execute again the playbook after the reboot. After reboot, the screen attached to the dGPU doesn't display anything. It's normal.

After the reboot, play again the same command as above, the role starts installing all the needed packages. The **install** tag is only used once. You know everything is installed when the host reboots again. Remove the **install** tag at the next step.

```shell
$ ansible-playbook passthrough.yml -t build,config,create -v --ask-become-pass
```

During the **build** stage, a window appears with a text asking if you want to boot from the CD/DVD. Please focus on the window by clicking on it, then, press "Enter" in order to boot on the CD/DVD. You will see Windows installing. When entering the last build step in case you added some packages in **lsw_windows_app_to_add** variable, you may have to interact with possible failed install but normally, just wait until the VM shutdowns automatically. If you pass a dedicated disk for the VM, the image will be copied an it. Each time you use the **build** tag, the Windows image is ERASED so consider using it only if you really want to reinstall everything from scratch.

**Note 1:** If you need to exit focus during the window's build: `Ctrl + Alt + g`.

**Note 2:** During the build, the second screen attached to the dGPU will display Windows installation after some time. It means the GPU driver has been succesfully installed during the image building.

The **config** stage configures Libvirt and scripts dedicated to the VM when starting or shutdown. Consider using the **config** tag everytime you just want to reset VM configuration alonside with the **create** tag.

At last, the **create** stage creates the Passthrough VM, maybe RDP if you set its variable and creates the launchers. If Looking Glass has been set to be installed, you also have a second VM that ends with "lg". The 2 VM share the same disk and same EFI variables files. If you make changes on these VM on virt-manager and run again the playbook with **create** tag, all user added configurations will be removed.

## Launch the VM

### Automatic way

Click on **LSW Passthrough** launcher in **System** category in your application menu. Your Display Manager (DM) will stop, some scripts are executed and DM starts again. The VM displays on the second screen. If you also have Looking Glass VM, click on **LSW LG** launcher in **System** category in your application menu. Like for Passthrough launcher, DM restarts. Looking Glass screen appears ~10 seconds after the restart. If you need to quit Looking Glass without shutting down the VM to go back to your Linux Host, the shortcut is `Right-Ctrl + q`. Want to go back in the VM ? Click again on **LSW LG** launcher, the window should appear after ~1 second.

In any case, when you shutdown the VM, DM restarts again.

### Manual way

Note: This way is only for debugging problems.

By opening virt-manager, you can see the VM created, start it. Your Display Manager (DM) will stop, some scripts are executed and DM starts again. The VM displays on the second screen. For seeing the Windows VM on 1st screen with Looking Glass, check the [VARIABLES](VARIABLES.md) file and pick the best looking glass command for your need. You will find multiple examples on the **lsw_config_usb_mouse** variable. Example: `looking-glass-client -m 97 -F input:rawMouse input:GrabKeyboardOnFocus`. When the VM stops, DM also restarts.

## Optional actions

### Expand your Windows storage drive

If your Windows is on a dedicated disk, start the VM, search "Disk management" and either:

* expand the C: drive (Not possible with Windows 11 in **normal** mode)
* or create another partition called "DATA" for example which will be mounted on `D:`.

### Install Bluetooth driver

In case you wanted to passthrough your Bluetooth card, you may have to manually install the driver after starting your VM. Example for Intel Bluetooth card: In your VM, go [here](https://www.intel.com/content/www/us/en/download/18649/intel-wireless-bluetooth-drivers-for-windows-10-and-windows-11.html) and install the latest available driver.
