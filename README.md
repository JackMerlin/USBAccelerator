# USB Accelerator
Run the USB Accelerator to increase your router USB speed to +10% ~ +240%.
![USB Accelerator](https://raw.githubusercontent.com/JackMerlin/USBAccelerator/master/.github/Screenshot_1.png)
 
## Description
In the Asuswrt router, the default settings do not give you the best USB performance, so the USB Accelerator will be help your to get the best USB SMB read and write speed by changing some settings.</br>
</br>
**I didn't know the computer language before, this is my first script, if there have error please forgive me.**

### The USB Accelerator script will
1. Create a `/jffs/scripts/smb.postconf` file and change `socket options` and `strict locking` settings to increase SMB read and write speed.
2. Enable USB3.0 mode if your router supports it.
3. Add an icon to WEBGUI to show that USB Accelerator is enabled.
4. When you open `/jffs/scripts/usbaccelerator.sh` script it will automatically check for updates.

## Requirements
1. An Asus router with  [Asuswrt-Merlin](http://asuswrt.lostrealm.ca/) firmware installed.
2. Enable JFFS and custom scripts.

## Supported Models
* RT-AC66U_B1
* RT-AC68U
* RT-AC1900P
* RT-AC86U

## Installation
Using an SSH client to log in to your router, then copy and paste the following command:
```
curl --retry 3 "https://raw.githubusercontent.com/JackMerlin/USBAccelerator/master/usbaccelerator.sh" -o "/jffs/scripts/usbaccelerator.sh" && chmod 755 /jffs/scripts/usbaccelerator.sh && /jffs/scripts/usbaccelerator.sh
```
Don't forget to press Enter ;)

## Verify that USB Accelerator is Working
Open your browser and login to the router, and check the USB icon at the top right have an "Plus", like the screenshot below.
![USB Accelerator](https://raw.githubusercontent.com/JackMerlin/USBAccelerator/master/.github/Screenshot_2.png)


## Updating or Remove
Using your SSH client to log in to your router, then copy and paste the following command:
```
/jffs/scripts/usbaccelerator.sh
```
If there have an update, it will silently update when you run the script.

## Feedback
You can feedback code error in the Github and help me make it better.

## FAQs
### Why is no performance improvement on my router?
Maybe some settings don't apply to your router, I suggest you read and write tests before and after running the script.

### Is it open source?
Absolutely.

## Special thanks
[@Adamm](https://www.snbforums.com/threads/ac86u-smb-tweaking.44729/) of the SNB Forum, he found the key settings.
