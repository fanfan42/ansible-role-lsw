# GPU driver

In all case (even Intel for GVT-g), once the driver is downloaded, copy it in this folder and call it **gpudriver.exe** .

## Nvidia

Go to [https://www.nvidia.com/en-us/drivers/](https://www.nvidia.com/en-us/drivers/) (or search on your Web search engine "Nvidia driver download" to have the link for your country and language).

The product category should always be "GeForce".

The product Series should match your card (ex: GeForce RTX 40 Series). If you have a laptop, always choose the "(Notebooks)" series.

The Product is your card (ex: GeForce RTX 4080 Laptop GPU).

The Operating system can be "Windows 10 64-bit" or "Windows 11" depending on the Windows version you want.

The Language, do I really have to help you choose ?

## Intel

Go to [Intel download page](https://www.intel.com/content/www/us/en/search.html#sort=relevancy&f:@tabfilter=[Downloads]&f:@stm_10385_en=[Graphics]) for all case except SR-IOV virtualization mode. [Link](https://www.driverscloud.com/fr/services/GetInformationDriver/76514-0/intel-gfx-win-1016460-1016259exe) for SR-IOV virtualization mode.

### Passthrough with Intel dGPU

Choose a file like "Intel Arc Iris Xe Graphics - Windows".

### SR-IOV
Download the file with "Download Now button" on the dedicated link.

No idea why but only this file works for building the VM. The driver can be updated later on Windows VM.

### GVT-g

Choose a file like "Intel 7th-10th Gen Processor Graphics - Windows".

## AMD

Go to [AMD download page](https://www.amd.com/en/support/download/drivers.html#search-browse-drivers)

Browse products: Graphics.

Product family: your product family (ex: Radeon RX 9000 Series).

Product model: your model (ex: AMD Radeon RX 9060).

Click on continue, choose the Windows version you want according to your Windows version, you have 2 versions proposed:

* an "auto detect and install", don't download it.
* Something like "AMD Software: Adrenalin Edition", the file is ~800MB, download this one.

# Dotnet Runtime 9 

Since Windows 11 25H2, the Intel driver for using GVT-g virtualization mode needs .NET Desktop Runtime 9.

Go [here](https://dotnet.microsoft.com/en-us/download/dotnet/9.0) and download the latest **.NET Desktop Runtime** x64 installer. Copy the file in this folder and rename it to **dotnetruntime.exe**.

# Ninite

If you want to install apps with Ninite, go to [https://ninite.com/](https://ninite.com), choose the apps wanted and download the file. Copy the file in this folder and rename it to **NiniteInstaller.exe**. I highly recommend these packages:

* a web browser (Chrome, Opera, Firefox, Brave).
* .NET Destktop Runtime x64 8 (or 9 if Windows 11 when using GVT-g virtualization mode).
* an anti virus (Malwarebytes, Avast, AVG, Spybot 2, Avira, SUPERAntiSpyware) if security is your top priority.
* 7-Zip and WinRAR.
* All the VC++ Redistributables.

# Looking Glass

If you want to install Looking Glass, go to [https://looking-glass.io/downloads](https://looking-glass.io/downloads) choose the latest Official/Stable version (ex: B7) host exe file (the green button with Windows logo). Copy this file in this folder and rename it (if necessary) to **looking_glass_host_setup.exe** . Version of the client on your Linux musts be the same than the one for host (Windows). For Nobara and Debian, version is fixed in the vars folder. To get the version on EndeavourOS, `yay -Ss looking-glass` to get it in the description.
