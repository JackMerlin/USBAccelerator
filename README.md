# USB Accelerator
**Run the USB Accelerator to increase your router USB speed to +10% ~ +240%.**</br>
<img src="https://raw.githubusercontent.com/JackMerlin/USBAccelerator/master/.github/Screenshot_1.png" width="611" height="382" />
 
## Description
In the Asuswrt router, the default settings do not give you the best USB performance, So the USB Accelerator will help you get the best USB SMB read and write speed by changing some settings.</br>
</br>
**I didn't know the computer language before, this is my first script, if there have error please forgive me.**

### The USB Accelerator script will
1. Create a `/jffs/scripts/smb.postconf` file and change `socket options` and `strict locking` settings to increase SMB read and write speed.
2. Enable USB 3.0 mode, If your router has USB 3.0 port.
3. Add an icon to WEB GUI to show the USB Accelerator is enabled.
4. When you running `/jffs/scripts/usbaccelerator.sh` it will automatically check for updates.

## Requirements
1. An Asus router with  [Asuswrt-Merlin](https://asuswrt.lostrealm.ca/) firmware installed.
2. Enable JFFS and custom scripts.

## Supported Models
* RT-AC66U_B1
* RT-AC68U
* RT-AC1900P
* RT-AC86U

## Installation
Using an SSH client to login to your router, then copy and paste the following command:
```
curl --retry 3 "https://raw.githubusercontent.com/JackMerlin/USBAccelerator/master/usbaccelerator.sh" -o "/jffs/scripts/usbaccelerator.sh" && chmod 755 /jffs/scripts/usbaccelerator.sh && /jffs/scripts/usbaccelerator.sh
```
Don't forget to press Enter ;)

## Verify that USB Accelerator is Working
Open your browser and login to your router, and check the USB icon at the top right have an "Plus", like the screenshot below.</br>
![USB Accelerator](https://raw.githubusercontent.com/JackMerlin/USBAccelerator/master/.github/Screenshot_2.png)

## Updating or Remove
Using your SSH client to login to your router, then copy and paste the following command:
```
/jffs/scripts/usbaccelerator.sh
```
If there have an update, it will silently update when you run the script.

## Feedback
You can feedback code error in the Github and help me make it better.

## FAQs
### Why is no performance improvement on my router?
Maybe some settings don't apply to your router, I suggest you do some USB read and write tests before and after running the script.

### Is it open source?
One hundred percent, check the [license](https://github.com/JackMerlin/USBAccelerator/blob/master/LICENSE).

## Special thanks
[@Adamm](https://www.snbforums.com/threads/ac86u-smb-tweaking.44729/) of the SNBForums, he found the key settings.
