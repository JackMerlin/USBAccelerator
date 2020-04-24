# USB Accelerator
**USB Accelerator is a script that runs on Asuswrt and Asuswrt-Merlin firmware. It can help improve the usb transfer speed of your router when you use samba.**

![USBAccelerator](https://raw.githubusercontent.com/JackMerlin/USBAccelerator/master/.github/Screenshot_1.png)

## USB Accelerator script will
### When you use Asuswrt-Merlin firmware or forks
1. Create `/jffs/scripts/smb.postconf` file to change `socket options` `deadtime` and `strict locking` options of `smb.conf`.
2. Add an icon in WebGUI to show the working status.

### When you use Asuswrt Stock firmware
1. Create `/jffs/scripts/post-mount` file and to change `socket options` `deadtime` and `strict locking` options of `smb.conf`.
2. Use the `script_usbmount` variable to make `post-mount` run when the USB is mounted.
3. Add an icon in Web GUI to show the working status.

## Requirements
* An Asus router with [Asuswrt-Merlin](https://asuswrt.lostrealm.ca/) 380 and higher or stock firmware 380 and higher.

## Supported Models
* RT-AC66U_B1
* RT-AC68U
* RT-AC1900P
* RT-AC3200
* RT-AC86U
* RT-AC87U
* RT-AC88U
* RT-AC5300
* RT-AX88U

## Installation
Using an SSH client to login to your router, then copy and paste the following command:
```Shell
/usr/sbin/wget --tries=3 --timeout=3 --no-check-certificate -O "/tmp/usbaccelerator.sh" "https://raw.githubusercontent.com/JackMerlin/USBAccelerator/master/usbaccelerator.sh" && chmod 755 /tmp/usbaccelerator.sh && sh /tmp/usbaccelerator.sh --github --shellui
```
Don't forget to press Enter key ;)

## Verify that USB Accelerator is Working
* If it is working, you should see a "Plus" in the USB icon in the upper right corner of Web GUI, like the screenshot below.
![USBAccelerator](https://raw.githubusercontent.com/JackMerlin/USBAccelerator/master/.github/Screenshot_2.png)
* Check the system logs, USB Accelerator will report it running status.

## Disable or Update or Uninstall
Using your SSH client to login to your router, then copy and paste the following command:
```
sh /jffs/addons/usbaccelerator/usbaccelerator.sh
```

## Advanced Usage
You can use `--help` option to view all supported options
### Examples
#### Enable USB Accelerator:
```
sh <PATH>/usbaccelerator.sh --enable
```
#### Force Disable USB Accelerator:
```
sh <PATH>/usbaccelerator.sh --force --disable
```
#### Update USB Accelerator without logs output:
```
sh <PATH>/usbaccelerator.sh --quiet --update
```

## Privacy
USB Accelerator will not send any data, but it needs to be downloaded and updated from GitHub or GitLab. Please read their terms and privacy policy in detail before using GitHub or GitLab.

## Feedback
You can feedback in the [GitHub](https://github.com/JackMerlin/USBAccelerator/issues) and help me make it better.

## FAQs
### When will the USB Accelerator run?
When usb device is mounted, the USB Accelerator will run once to modify the `smb.conf`.

### Should I download USB Accelerator from GitHub or GitLab?
Please use GitHub and use [GitLab](https://gitlab.com/JackMerlin/USBAccelerator/) only when GitHub is not available.

### How to install from GitLab?
GitLab only supports TLS 1.2 and higher, If you use 380 stock firmware, you will not be able to install from GitLab, only `wget` with 384 stock firmware supports TLS 1.2.
If you think your firmware supports it, please use the following command to install:
```Shell
/usr/sbin/wget --tries=3 --timeout=3 --no-check-certificate -O "/tmp/usbaccelerator.sh" "https://gitlab.com/JackMerlin/USBAccelerator/raw/master/usbaccelerator.sh" && chmod 755 /tmp/usbaccelerator.sh && sh /tmp/usbaccelerator.sh --github --shellui
```

### Where should I report issues?
Only on GitHub.

### Why is there no speed increase in the FTP?
It should only work in the SMB protocol.

### Why is no performance improvement on my router?
First check if it works, and if yes, maybe some settings don't apply to your router.

## License
```
USB Accelerator 2.0
Copyleft :-) 2019-2020

This program is a free and open-source software ,   and you can
redistribute it and/or modify it under the terms of the GNU
General Public License version 3 (GPLv3).

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY,  without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the GNU General Public License version 3 for more details:
https://github.com/JackMerlin/USBAccelerator/blob/master/LICENSE
```
