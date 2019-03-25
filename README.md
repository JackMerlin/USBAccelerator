# USB Accelerator
**USB Accelerator can help you significantly improve the USB performance of your router.**
![USBAccelerator](https://raw.githubusercontent.com/JackMerlin/USBAccelerator/master/.github/Screenshot_1.png)

*This USB Accelerator is not about Google Tensor Processing Unit (TPU), This is a script running on router based on Asuswrt firmware. If you are looking Google TPU, [please check there](https://www.google.com/search?q=Google+TPU+USB+Accelerator).*
 
## Description
In the Asuswrt router, the default settings do not give you the best USB performance, So the USB Accelerator will help you get the best USB SMB read and write speed by changing some settings.

***I didn't know the computer language before, this is my first script, if there have error please forgive me.***

## USB Accelerator script will
### If you use Asuswrt-Merlin firmware or forks
1. Create a `/jffs/scripts/smb.postconf` file and change `socket options` and `strict locking` settings to increase SMB read and write speed.
2. Enable USB 3.0 mode, If your router has the USB 3.0 port.
3. Add an icon to WEB GUI to display the working status.
4. Automatically check for updates at each run it.

### If you use Asuswrt stock firmware
1. Create a `/jffs/scripts/sfsmb` file and this `sfsmb` file will be change `socket options` and `strict locking` settings to increase SMB read and write speed.
2. Let the `sfsmb` run when you mount the USB device to your router.
3. Enable USB 3.0 mode, If your router has the USB 3.0 port.
4. Add an icon to WEB GUI to display the working status.
5. Automatically check for updates at each run it.

## Requirements
* An Asus router with [Asuswrt-Merlin](https://asuswrt.lostrealm.ca/) firmware installed.

**or**

* An Asus router with using stock firmware (beta).

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
/usr/sbin/wget -c -T 30 --no-check-certificate "https://raw.githubusercontent.com/JackMerlin/USBAccelerator/master/usbaccelerator.sh" -O "/tmp/usbaccelerator.sh" && chmod 755 /tmp/usbaccelerator.sh && sh /tmp/usbaccelerator.sh
```
Don't forget to press Enter key ;)

## Verify that USB Accelerator is Working
* Open your browser to login your router, and check the USB icon at the top right have an "Plus", like the screenshot below.

![USBAccelerator](https://raw.githubusercontent.com/JackMerlin/USBAccelerator/master/.github/Screenshot_2.png)
* Check the system logs, USB Accelerator will report it running status.

## Updating or Reinstall or Remove
Using your SSH client to login to your router, then copy and paste the following command:
```
/jffs/scripts/usbaccelerator.sh
```

## Known Issues
Maybe in the stock firmware is not working, but I'm not sure.

## Feedback
You can feedback code error in the GitHub and help me make it better.

## FAQs
### Why is there no speed increase in the FTP?
It should only work in the SMB protocol. If you are a developer, you can help me make it work in the FTP.
### Why is no performance improvement on my router?
First check if it works, and if yes, maybe some settings don't apply to your router.
### Is it open source?
One hundred percent, check the [license](https://github.com/JackMerlin/USBAccelerator/blob/master/LICENSE).
