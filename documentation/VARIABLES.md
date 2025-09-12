# Table Of Contents

[**Common variables**](#common-variables)

- [lsw_virt_mode](#lsw_virt_mode)
- [lsw_windows_iso](#lsw_windows_iso)
- [lsw_windows_vm_name](#lsw_windows_vm_name)
- [lsw_windows_vm_private_ip](#lsw_windows_vm_private_ip)
- [lsw_windows_vmlg_private_ip](#lsw_windows_vmlg_private_ip)
- [lsw_windows_img_format](#lsw_windows_img_format)
- [lsw_windows_img_size](#lsw_windows_img_size)
- [lsw_windows_disk_device_path](#lsw_windows_disk_device_path)
- [lsw_config_pass_disk_controller](#lsw_config_pass_disk_controller)
- [lsw_windows_build_mem](#lsw_windows_build_mem)
- [lsw_windows_build_num_cpu](#lsw_windows_build_num_cpu)
- [lsw_windows_build_timeout_minutes](#lsw_windows_build_timeout_minutes)
- [lsw_windows_install_template](#lsw_windows_install_template)
- [lsw_windows_version](#lsw_windows_version)
- [lsw_windows_language](#lsw_windows_language)
- [lsw_windows_timezone](#lsw_windows_timezone)
- [lsw_windows_keyboard](#lsw_windows_keyboard)
- [lsw_windows_licence_key](#lsw_windows_licence_key)
- [lsw_windows_user](#lsw_windows_user)
- [lsw_windows_password](#lsw_windows_password)
- [lsw_windows_gpu_driver](#lsw_windows_gpu_driver)
- [lsw_windows_gpu_install_options](#lsw_windows_gpu_install_options)
- [lsw_windows_app_to_remove](#lsw_windows_app_to_remove)
- [lsw_windows_capability_to_remove](#lsw_windows_capability_to_remove)
- [lsw_windows_feature_to_remove](#lsw_windows_feature_to_remove)
- [lsw_config_vm_memory](#lsw_config_vm_memory)
- [lsw_config_usb_mouse](#lsw_config_usb_mouse)
- [lsw_windows_usb_kbd](#lsw_windows_usb_kbd)
- [lsw_windows_install_app_from_ninite](#lsw_windows_install_app_from_ninite)
- [lsw_install_looking_glass](#lsw_install_looking_glass)
- [lsw_looking_glass_memory](#lsw_looking_glass_memory)
- [lsw_install_zen](#lsw_install_zen)
- [lsw_windows_install_rdp](#lsw_windows_install_rdp)

[**Passthrough variables**](#passthrough-variables)

- [lsw_passthrough_gpu_pci_base_addr](#lsw_passthrough_gpu_pci_base_addr)
- [lsw_config_is_laptop](#lsw_config_is_laptop)
- [lsw_config_gpu_nvidia_gtx](#lsw_config_gpu_nvidia_gtx)

[**OS specific variables**](#os-specific-variables)

- [lsw_distro_boot_location](#lsw_distro_boot_location)
- [lsw_distro_boot_loader](#lsw_distro_boot_loader)
- [lsw_distro_initramfs_binary](#lsw_distro_initramfs_binary)
- [lsw_apt_keys](#lsw_apt_keys)
- [lsw_apt_repos](#lsw_apt_repos)
- [lsw_packages](#lsw_packages)
- [lsw_zen_packages](#lsw_zen_packages)
- [lsw_zen_gvtg_packages](#lsw_zen_gvtg_packages)
- [lsw_pycdlib_dependencies](#lsw_pycdlib_dependencies)
- [lsw_rm_pycdlib_dependencies](#lsw_rm_pycdlib_dependencies)
- [lsw_lg_version](#lsw_lg_version)
- [lsw_lg_url](#lsw_lg_url)
- [lsw_lg_dependencies](#lsw_lg_dependencies)
- [lsw_rm_lg_dependencies](#lsw_rm_lg_dependencies)
- [lsw_packer_version](#lsw_packer_version)
- [lsw_packer_url](#lsw_packer_url)
- [lsw_windows_ovmf_code_path](#lsw_windows_ovmf_code_path)
- [lsw_windows_ovmf_code_secboot_path](#lsw_windows_ovmf_code_secboot_path)
- [lsw_windows_ovmf_vars_path](#lsw_windows_ovmf_vars_path)
- [lsw_windows_uefi_shell_path](#lsw_windows_uefi_shell_path)
- [lsw_sriov_rdp_packages](#lsw_sriov_rdp_packages)
- [lsw_sriov_pkg_version](#lsw_sriov_pkg_version)
- [lsw_sriov_i915_pkg](#lsw_sriov_i915_pkg)
- [lsw_sriov_pkg_url](#lsw_sriov_pkg_url)

## Common variables

### lsw_virt_mode

Accepted values are:

* **passthrough** (the default).
* **gvtg** if your Intel Core CPU is from 6th (2015) to 10th (2020) generation.
* **sriov** if your Intel Core (Ultra) CPU is from the 11th generation or higher.

Other values will make the role fail.

### lsw_windows_iso

Follow the guide [here](../build/README.md) to get your windows ISO installation file. Default value: **windows10.iso**

**WARNING:** All tests have been done with Official Microsoft Windows 10/11 Pro ISO files. I don't guarantee any results with other ISO. No tests will be performed with unofficial Microsoft Windows ISO files.

### lsw_windows_vm_name

The name you want to give to your Windows virtual machine. By default, it takes your hostname and add 'vm-' in front of it. If you install Looking Glass, the virtual machine created takes a 'lg' after its name, example: vm-legionlg.

### lsw_windows_vm_private_ip

Default to **192.168.122.42**. IP on the default network managed by Libvirt. Change it only if you set to **true** variable **lsw_windows_activate_rdp** and really need another IP.

### lsw_windows_vmlg_private_ip

Default to **192.168.122.21**. IP on the default network managed by Libvirt for Looking Glass VM. Change it only if you need to set to **true** variable **lsw_windows_activate_rdp** and really need another IP.

### lsw_windows_img_format

Possible values are **raw** (the default) or **qcow2**. Other values will make the role fail.

When you create an Windows image (build tag), qemu is able to manage **RAW** and **QCOW2** format. In brief, **RAW** format has the best performance than QCOW2 but has less functionnalities to resize the image for example. If you attend to passthrough an entire disk dedicated to the VM, this parameter has no importance because when the build is finished, the image created is copied directly on this disk.

### lsw_windows_img_size

Size in GB of the image file created during the build play. **50G** by default. For this variable, it also depends on if you pass a dedicated disk to the VM. If you have only one disk in your computer, it's better to increase the default size so the virtual machine has enough space to install programs later. On the contrary, if the image is copied on a dedicated disk, decrease the size to around 30G so there is enough space for Windows to install and the copy on disk will take less time.

### lsw_windows_disk_device_path

By default, it's an empty value. Give the complete path of another disk than the one for your Linux host if you want to pass this disk to the VM. Giving a dedicated disk to the VM also allows to have a dual boot Windows at next startup and increases performance.

**WARNING:**

* the disk musts be a valid disk, not a partition, examples: /dev/sda or /dev/nvme0n1. Role will fail if not a valid disk.
* the disk is WIPED once the image build is finished and the role doesn't verify if it's your Host disk. Be careful.

### lsw_config_pass_disk_controller

Default to **false**. Set it to **true** if wou want to passthrough the PCI controller of your second disk dedicated to the VM. It gives the best performance. For NVMe drives, it should be set to **true** everytime, normally the PCI controller is dedicated to the drive. In case you have a computer with only SATA drives (SSD or HDD), let this variable to **false** because if the drive dedicated to your Linux host is also attached to the same PCI controller as the drive you want to dedicate to your Windows VM, all disks will be passthrough into your VM, with all problems you can imagine.

### lsw_windows_build_mem

The memory (RAM) used when building the Windows image in MB. By default, it takes the half of your total memory installed on your host.

### lsw_windows_build_num_cpu

The number of Virtual CPU (vCPU) affected to the build step, cores and threads included. By default, it takes half of the vCPU.

### lsw_windows_build_timeout_minutes

This role is not perfect, when the role builds the Windows image, I don't communicate with the VM so I estimated the time to build around **30** minutes (the default) before the task timeouts. Increase or decrease this value depending on your hardware.

### lsw_windows_install_template

Can be **normal** (the default) or **private**. When the VM is building or when the role creates it in libvirt, templates are used to build and define the VM. The **normal** mode has really few optimizations for running the VM but, and it's a really important information, the VM is compliant with Microsoft EULA. On the other side, **private** mode tweaks many things to make the OS very responsive but it's not accepetd by Microsoft. For example, Windows 11 forces users to have secure boot activated or to have, at least, 4GB of RAM. The **private** mode allows you to bypass these requirements at the cost of losing all support from Microsoft. **private** mode has to be used for private usage or educational purpose, so: at your own risks. In any case, you will have to enter a valid licence key to use your VM.

### lsw_windows_version

Can be **10** (the default) or **11**. Choose the version according the Windows ISO file downloaded. No other products (Windows 7, Windows Server 2022, etc) of Microsoft Windows have been tested. Giving other values will make this role fail.

### lsw_windows_language

The language used in Windows when installing it. By default, it's **fr-FR**. Choose **en-US** for American or any other language supported by Windows.

### lsw_windows_timezone

The timezone depending where you are installing the VM. By default, it's **'Romance Standard Time'**. Either you find your Windows compatible timezone, either you change it by hand after the VM creation.

### lsw_windows_keyboard

The keyboard layout. By default, it's **040c:00000409** for US default layout. **0409:0000040c** is the French default layout. This parameter can be changed after windows VM creation.

### lsw_windows_licence_key

The Microsoft licence key needed to activate Windows. By default, it's **VK7JG-NPHTM-C97JM-9MPGT-3V66T**. This is a generic licence key which automatically "tells" to Windows ISO, 10 or 11, to install the Pro version. **2B87N-8KFHP-DKV6R-Y2C8J-PKCKT** allows the installation of Windows 10/11 Pro N. Generally, put a generic or valid licence key, it will install the Windows associated to the licence key.

**WARNINGS:**

* This "licence" key DOES NOT activate Windows, either you put a valid licence key in place of this one, either you activate Windows after VM creation.
* All tests have been made on Windows 10/11 Pro or Pro N, testing on other versions of Windows are at your own risks.
* A valid Microsoft licence is mandatory even when using **private** mode in **lsw_windows_install_template** variable.

### lsw_windows_user

The user who will login as Administrator on the VM. By default, it's the user who is running the ansible playbook. By the way, don't run the playbook as root, it's not necessary, the role asks your administrator password to run necessary administrative tasks.

### lsw_windows_password

The password associated to **lsw_windows_user**. By default, it's empty. It's completely OK to let it empty, it won't affect VM build or creation. You decide.

### lsw_windows_gpu_driver

The driver associated to your dGPU or iGPU. By default, it's **intel**. Even if this role is used on a computer with only an Intel iGPU (GVT-g or SR-IOV), you have to manually download the GPU driver or the role will fail to apply. More information to do it [here](../build/extra_packages/README.md).

### lsw_windows_gpu_install_options

The options needed to install the GPU driver to not ask questions (install everything by default) and no shutdown required. **intel** and **nvidia** have been tested, it works. Options for AMD dGPU have never been tested.

### lsw_windows_app_to_remove

List of Windows applications to remove. These applications are only removed if **lsw_windows_install_template** is manually set to **private**. Many of these applications are [here](../defaults/main.yml).

### lsw_windows_capability_to_remove

See **lsw_windows_app_to_remove**.

### lsw_windows_feature_to_remove

See **lsw_windows_app_to_remove**.

### lsw_config_vm_memory

The memory (RAM) allocated to Windows VM in MB. The default is **8192**. The role will fail if the memory allocated for the VM exceeds 3/4 of the total memory on your Linux host. This variable is different from **lsw_windows_build_mem** because this variable only affects memory allocated for the build stage.

### lsw_config_usb_mouse

Default to empty. Don't set this variable when using RDP or SR-IOV virtualization mode. This role creates a VM with nearly bare performance including devices connected to the Linux host. In order to perform this achievement, every computer, tower or laptop, should have 2 mice and 2 keyboards. Mousepad and laptop keyboard, in case of a laptop, count in the total. The device is passed on the VM via EVDEV. When you select the mouse dedicated to the VM, it becomes unavailable on the Linux host so be careful when passing a mouse/keyboard device to the VM. To find 2nd mouse or keyboard: `sudo ls -l /dev/input/by-id/usb-*-event-*`. It's possible to only have 2nd mouse or 2nd keyboard only attached to the VM. Here are multiple use case:


|             | 2nd mouse | 2nd keyboard | Result                                                                                                                                                                                                                                                                                                                                                                |
| :------------ | ----------- | -------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GVT-g       | no        | no           | OK. SPICE is used to connect via network 1st mouse and keyboard.`looking-glass-client -m 97 -F win:size=1920x1080 input:rawMouse input:GrabKeyboardOnFocus input:autoCapture`                                                                                                                                                                                         |
| GVT-g       | yes       | no           | OK. SPICE is used to connect via network 1st keyboard. 2nd mouse is linked via EVDEV to the VM. Linux host cannot use the 2nd mouse.`looking-glass-client -m 97 -F win:size=1920x1080 input:GrabKeyboardOnFocus input:autoCapture`                                                                                                                                    |
| GVT-g       | yes       | yes          | OK. SPICE is not used. 2nd mouse and keyboard are managed via EVDEV and not working on Linux Host.`looking-glass-client -m 97 -F win:size=1920x1080 -s`                                                                                                                                                                                                               |
| Passthrough | no        | no           | OK with Looking Glass installed. SPICE is used to connect via network 1st mouse and keyboard.`looking-glass-client -m 97 -F win:size=1920x1080 input:rawMouse input:GrabKeyboardOnFocus input:autoCapture`. NOK without Looking Glass, the VM has a display on second screen but is not useable.                                                                      |
| Passthrough | yes       | no           | OK with Looking Glass installed. SPICE is used to connect via network 1st keyboard. 2nd mouse is linked via EVDEV to the VM. Linux host cannot use 2nd mouse.`looking-glass-client -m 97 -F win:size=1920x1080 input:GrabKeyboardOnFocus input:autoCapture`. "OK" without Looking Glass, the VM has a display on second screen but only the 2nd mouse can control it. |
| Passthrough | yes       | yes          | OK with Looking Glass installed. SPICE is not in use. 2nd mouse and keyboard are linked via EVDEV to the VM. Linux host cannot use 2nd mouse and keyboard.`looking-glass-client -m 97 -F win:size=1920x1080 -s`. OK without Looking Glass, the VM has a display on second screen with 2nd mouse and keyboard working. You have maximum performance.                   |

### lsw_windows_usb_kbd

See **lsw_windows_usb_mouse**.

### lsw_windows_install_app_from_ninite

Default to **false**. Ninite is a web service which offers you to download one .exe file with many applications to install directly after a fresh install of Windows. Really helpful when you want your favorite Web browser (and more) directly at first login. If that interests you, set this var to **true** and follow the guide [here](../build/extra_packages/README.md).

### lsw_install_looking_glass

Default to **false**. Set it to **true** in case of **gvtg** value in the variable **lsw_virt_mode** or the role will fail. It's not mandatory to install it for **passthrough** mode but if you have a laptop (and a dummy HDMI plug), it can help you use the VM wherever you want only using your integrated screen so I really suggest you to also set this variable to true in all case. The guide to make you use it in your VM is [here](../build/extra_packages/README.md).

### lsw_looking_glass_memory

It's the memory allocated to Looking Glass to interact with it's host application on Windows VM. The default value (in MB) is **64** and is perfect for FullHD resolution. In case of 4K or other resolution wanted, follow this [link](https://looking-glass.io/docs/B7/install_libvirt/#determining-memory) to know which value you need.

### lsw_install_zen

Only applies for Debian and EndeavourOS, Nobara manages it's own optimized kernel. The default is **true** so you have a better kernel optimized for desktop and gaming usage but it's perfectly OK to not install it if you don't want it.

### lsw_windows_activate_rdp

Default to **false**. Set it to **true** in case of **sriov** value in the variable **lsw_virt_mode** or the role will fail. Set it to **true**, also if you need access to the VM via Remote Desktop Protocol. Remmina + FreeRDP will be installed and a basic configuration will be created for the VM(s).

## Passthrough variables

### lsw_passthrough_gpu_pci_base_addr

Example:

```shell
$ lspci | grep VGA
00:02.0 VGA compatible controller: Intel Corporation CoffeeLake-H GT2 [UHD Graphics 630]
01:00.0 VGA compatible controller: NVIDIA Corporation TU116M [GeForce GTX 1660 Ti Mobile] (rev a1)
```

In this example, the VGA compatible controller needed for a pasthrough virtualization is **NVIDIA Corporation TU116M**. It's PCI address is **01:00.0** so if I need this GPU for my passthrough virtualization, I will set **lsw_passthrough_gpu_pci_addr** to **01:00** (the default).

### lsw_config_is_laptop

If your computer is a laptop, dGPU cards like Nvidia need to "see" a battery in the system. A file called "acpitable.bin" is [here](../files/acpitable.bin). This file is needed for Nvidia works on laptop VM. The case of AMD and Intel dGPU are not tested if this is a need. Default value is **false**. Set it to **true** if you use this Ansible role on a laptop with Nvidia dGPU.

### lsw_config_gpu_nvidia_gtx

Default to **false**. This variable is only for Nvidia GTX dGPU. No need to set it to **true** when you have a Nvidia RTX dGPU. Follow the guide [here](PATCH_NVIDIA_FW.md) to create a patched firmware.

## OS specific variables

**NOTE:** these variables cannot be overloaded in a playbook. If you need to modify them, modify them directly in the vars folder or use other Ansible ways to modifify.

### lsw_distro_boot_location

Full path to boot files. **/boot** for Nobara and Debian (grub boot loader), **/efi** for EndeavourOS (systemd-boot boot loader).

### lsw_distro_boot_loader

Name of the boot loader used by the distro. **grub** for Nobara and Debian. **systemd-boot** for EndeavourOS. Change it at your own risks.

### lsw_distro_initramfs_binary

Name of initramfs program in charge of reloading kernel images. **dracut** for Nobara and EndeavourOS, **update-iniramfs** for Debian. Change it at your own risks.

### lsw_apt_keys

Only for Debian. List of keys to import in Debian for unofficial package repositories.

### lsw_apt_repos

Only for Debian. List of unofficial package repositories to install on the system.

### lsw_packages

Common to all distros. List of base packages needed to allow this role to work.

### lsw_zen_packages

Only for Debian and EndeavourOS. List of packages and version of the Zen/Liquorix kernel and headers to install. Zen/Liquorix kernel is modified kernel designed to enhance performance on desktop Linux. If using sriov in variable lsw_virt_mode, Zen/Liquorix kernel is nearly mandatory because the tests made with [strongtz](https://github.com/strongtz/i915-sriov-dkms) dkms package are on Zen/Liquorix kernels.

### lsw_zen_gvtg_packages

Only for EndeavourOS. List of packages and version of the Zen kernel and headers to install for GVT-g. GVT-g has been abandoned in 2020 by Intel. The best kernels still using fresh code of this technology are 5.15 LTS (EOL december 2025) and 6.1 LTS (EOL december 2027) kernels. So the role installs it to best match peripherals on your computer. These old kernels don't work on Debian 13 Trixie, that's why only Liquorix kernel 6.12 can be installed without errors.

### lsw_pycdlib_dependencies

Only for EndeavourOS. List of packages needed to build and install Python pycdlib on EndeavourOS.

### lsw_rm_pycdlib_dependencies

Only for EndeavourOS. Default to **false**. If you want to remove Python pycdlib dependencies, set the variable to **true**. Most of the time, these dependencies are needed by other packages on your Linux host. Removing them can lead to errors during the role's execution, that's why it's set to **false** by default.

### lsw_lg_version

Only for Debian and Nobara. See the guide for Looking Glass installation [here](../build/extra_packages/README.md) to select the same version for the Linux host and Windows VM.

### lsw_lg_url

Only for Debian and Nobara. Normally, don't change this setting except if it's not working. This variable is linked to **lsw_lg_version**.

### lsw_lg_dependencies

Common to all distros. List of packages needed to build and install Looking Glass on the Linux host.

### lsw_rm_lg_dependencies

Common to all distros. Default to false. If you want to remove Looking Glass dependencies, set the variable to **true**. Most of the time, these dependencies are needed by other packages on your Linux host. Removing them can lead to errors during the role's execution, that's why it's set to **false** by default.

### lsw_packer_version

Only for Debian and Nobara. The version to install for Hashicorp Packer. This role uses it to build the Windows image file for the VM. No need to modify this version, it works an all the 3 distros.

### lsw_packer_url

Only for Debian and Nobara. Linked to **lsw_packer_version** variable. No need to modify it except if the URL is dead.

### lsw_windows_ovmf_code_path

Common to all distros. Full path of the OVMF code file. It shouldn't be changed because these paths have been tested on all 3 distros.

### lsw_windows_ovmf_code_secboot_path

Common to all distros. Full path of the OVMF Secure Boot code file. It shouldn't be changed because these paths have been tested on all 3 distros.

### lsw_windows_ovmf_vars_path

Common to all distros. Full path of the OVMF vars file. It shouldn't be changed because these paths have been tested on all 3 distros.

### lsw_windows_uefi_shell_path

Common to all distros. Full path of the UEFI shell file. It shouldn't be changed because these paths have been tested on all 3 distros. This variable is only needed if the boot loader is systemd-boot for managing dual boot with Windows.

### lsw_sriov_rdp_packages

Common to all distros. List of packages to be installed for using RDP with Remmina and FreeRDP.

### lsw_sriov_pkg_version

Common to all distros. Needed when **sriov** set in **lsw_virt_mode**. Go on [strongtz](https://github.com/strongtz/i915-sriov-dkms/releases) repository and choose the release name you want.

### lsw_sriov_i915_pkg

Only for Debian and EndeavourOS. Name of the i915 package you need on your distro.

### lsw_sriov_pkg_url

Common to all distros. URL of strongtz (or other fork if you want) github repository with i915 module for SR-IOV. URL of the package for Debian and EndeavourOS. URL of the tarball (minus the .tar.gz suffix) for Nobara.
