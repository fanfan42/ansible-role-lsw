# GPU driver

In all case, once the driver is downloaded, copy it in this folder and rename it **gpudriver.exe**.

## Nvidia

Go to [https://www.nvidia.com/en-us/drivers/](https://www.nvidia.com/en-us/drivers/) (or search on your Web search engine "Nvidia driver download" to have the link for your country and language).

The product category should always be "GeForce".

The product Series should match your card (ex: GeForce RTX 40 Series). If you have a laptop, always choose the "(Notebooks)" series.

The Product is your card (ex: GeForce RTX 4080 Laptop GPU).

The Operating system can be "Windows 10 64-bit" or "Windows 11" depending on the Windows version you want.

The Language, do I really have to help you choose ?

## Intel

Go to [Intel download page](https://www.intel.com/content/www/us/en/search.html#sort=relevancy&f:@tabfilter=[Downloads]&f:@stm_10385_en=[Graphics]) for all case except SR-IOV virtualization mode.

### Passthrough with Intel dGPU

Choose a link like "Intel Arc Graphics - Windows" or "Intel Arc Pro Graphics - Windows", click on it and download the latest version.

### GVT-g

Choose a link like "Intel 7th-10th Gen Processor Graphics - Windows", click on it and download the latest version.

### SR-IOV

Old [Link](https://www.driverscloud.com/fr/services/GetInformationDriver/76514-0/intel-gfx-win-1016460-1016259exe) for SR-IOV virtualization mode (not recommended anymore, only if the ones below don't work).

New links (32.0.101.7076 version):

* [Intel](https://www.intel.com/content/www/us/en/download/864990/intel-11th-14th-gen-processor-graphics-windows.html), the official one but may disappears in the future.
* [TLD](https://www.touslesdrivers.com/index.php?v_page=23&v_code=83122), Unofficial, just in case the Intel one doesn't work anymore. In French, search for "Téléchargement" and click the image below to download the file.

## AMD

Go to [AMD download page](https://www.amd.com/en/support/download/drivers.html#search-browse-drivers)

Browse products: Graphics.

Product family: your product family (ex: Radeon RX 9000 Series).

Product model: your model (ex: AMD Radeon RX 9060).

Click on continue, choose the Windows version you want according to your Windows version, you have 2 versions proposed:

* an "auto detect and install", don't download it.
* Something like "AMD Software: Adrenalin Edition", the file is ~800MB, download this one.
