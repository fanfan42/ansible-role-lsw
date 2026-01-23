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

Go to [Intel download page](https://www.intel.com/content/www/us/en/search.html#sort=relevancy&f:@tabfilter=[Downloads]&f:@stm_10385_en=[Graphics]).

### Passthrough with Intel dGPU

Choose a link like "Intel Arc Graphics - Windows" or "Intel Arc Pro Graphics - Windows", click on it and download the latest version.

### GVT-g

Choose a link like "Intel 7th-10th Gen Processor Graphics - Windows", click on it and download the latest version.

### SR-IOV

Choose a link like "Intel 11th – 14th Gen Processor Graphics - Windows", click on it and download the latest version.

## AMD

Go to [AMD download page](https://www.amd.com/en/support/download/drivers.html#search-browse-drivers)

Browse products: Graphics.

Product family: your product family (ex: Radeon RX 9000 Series).

Product model: your model (ex: AMD Radeon RX 9060).

Click on continue, choose the Windows version you want according to your Windows version, you have 2 versions proposed:

* an "auto detect and install", don't download it.
* Something like "AMD Software: Adrenalin Edition", the file is ~800MB, download this one.

# Looking Glass

If you want to install Looking Glass, go to [https://looking-glass.io/downloads](https://looking-glass.io/downloads), download the latest Official/Stable version (ex: B7) host file (the green button with Windows logo). Unzip the file, go in the directory, copy the exe file in this folder and rename it to **looking_glass_host_setup.exe**. Version of the client on your Linux musts be the same than the one for host (Windows).
