#!/bin/sh

###################################################################
######                USB Accelerator by Jack                ######
######                     Version 0.1.0                     ######
######                                                       ######
######     https://github.com/JackMerlin/USBAccelerator      ######
######                                                       ######
###################################################################

export PATH=/sbin:/bin:/usr/sbin:/usr/bin$PATH
VERSION="0.1.0"
COLOR_WHITE='\033[0m'
COLOR_LIGHT_WHITE='\033[1;37m'
COLOR_GREEN='\033[0;32m'
COLOR_LIGHT_GREEN='\033[1;32m'

Select_language () {
while true; do
printf '\n___________________________________________________________________\n'
printf '选择语言\n'
printf 'Please choose display language.\n'
printf '\n'
printf '%b1%b 中文%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
printf '%b2%b English%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
printf '\n___________________________________________________________________\n'
printf '请输入对应数字\n'
printf 'Please enter the number\n'
read -r "menu1"
case "$menu1" in
	1)Welcome_message_zh
	break
	;;
	2)Welcome_message
	break
	;;
esac
done
}

Welcome_message_zh () {
lang="zh"
printf '\n___________________________________________________________________\n'
printf '\n'
printf '感谢你使用%bUSB加速器%b v%s，它可以显著提升你的路由器USB读写速度，\n' "$COLOR_GREEN" "$COLOR_WHITE" "$VERSION"
printf '根据测试，USB加速器提升效率高达百分之10~240。\n'
printf '在原始系统中一些参数被保守地锁定在较低的值内，\n'
printf '因此加速器的原理其实是精确调教系统参数来释放硬件的应有性能。\n' 
printf '___________________________________________________________________\n'
printf '\n'
printf '%b注意：%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf '这是一个相当早期的脚本，目前它仍处在测试阶段，\n'
printf '所以，如果有任何问题请反馈给我。\n'
printf '\n'
printf '%b版权：%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf '(c)2019 USB 加速器由 Jack 制作，保留所有权利，使用 GPLv3 授权。\n'
printf '如果你尊重 GPLv3 授权，你可以自由地使用它。\n'
printf 'https://github.com/JackMerlin/USBAccelerator\n'
printf '\n'
printf '%b特别感谢：%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf 'SmallNetBuilder 论坛的 @Adamm 发现了关键配置。\n'
printf '___________________________________________________________________\n'
Chk1="$(cat /tmp/etc/smb.conf | grep "strict locking" | wc -l)"
if [ "$Chk1" != "1" ]; then
	printf '输入 %b1%b 开启%bUSB加速器\n' "$COLOR_LIGHT_GREEN" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
fi
if [ "$Chk1" = "1" ]; then
	printf '输入 %b2%b 关闭%bUSB加速器\n' "$COLOR_LIGHT_GREEN" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
	printf '输入 %b3%b 卸载%bUSB加速器\n' "$COLOR_LIGHT_GREEN" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
fi
printf '___________________________________________________________________\n'
printf '请输入对应数字\n'
printf '\n'
read -r "menu1"
case "$menu1" in
1)
Enable
break
;;
2)
Disable
break
;;
3)
Remove
break
;;
esac
}

Welcome_message () {
lang="en"
printf '\n___________________________________________________________________\n'
printf '\n \n'
printf 'Welcome to use the %bUSB Accelerator%b Version %s,\n' "$COLOR_GREEN" "$COLOR_WHITE" "$VERSION"
printf 'It can improve the USB read and write performance of your router.\n'
printf 'How does it work?\n'
printf 'Trust me, it has no the magic, it just changes some settings to the best.\n' 
printf '___________________________________________________________________\n'
printf '\n'
printf '%bWarning%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf 'Maybe some settings not working for you,\n'
printf 'but if you find an error you can feedback to me.\n'
printf '\n'
printf '%bCopyright%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf '(c)2019 USB Accelerator by Jack, and all rights reserved,\n'
printf 'licensed using GPLv3.\n'
printf 'https://github.com/JackMerlin/USBAccelerator\n'
printf '\n'
printf '%bSpecial thanks%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf '@Adamm of the SmallNetBuilder forum found the best settings.\n'
printf '___________________________________________________________________\n'
Chk2="$(cat /tmp/etc/smb.conf | grep "strict locking" | wc -l)"
if [ "$Chk2" != "1" ]; then
	printf 'Enter %b1%b to %bEnable%b USB Accelerator\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
fi
if [ "$Chk2" = "1" ]; then
	printf 'Enter %b2%b to %bDisable%b USB Accelerator\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
	printf 'Enter %b3%b to %bRemove%b USB Accelerator\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
fi
printf '___________________________________________________________________\n'
printf 'Please enter the number\n'
printf '\n'
read -r "menu1"
case "$menu1" in
1)
Enable
break
;;
2)
Disable
break
;;
3)
Remove
break
;;
esac
}

GITHUB_DIR="https://raw.githubusercontent.com/JackMerlin/USBAccelerator/master"
spath="/jffs/scripts"

Check () {
JFFS="$(nvram show | grep 'jffs2_on=1' | wc -l)"
if [ "$JFFS" = "1" ]; then
	Scripts="$(nvram show | grep 'jffs2_scripts=1' | wc -l)"
	if [ "$Scripts" != "1" ]; then
		nvram set jffs2_scripts=1
		nvram commit
		mkdir $spath
		chmod 755 $spath
	fi
else
	if [ "$lang" = "zh" ]; then
		printf '请开启JFFS分区后再运行USB加速器\n'
	else
		printf 'Error, You must be enable the JFFS.\n'
	fi
fi

USB3="$(nvram show | grep 'usb_usb3' | wc -l)"
if [ "$USB3" = "1" ]; then
	USB3ON="$(nvram show | grep 'usb_usb3=1' | wc -l)"
		if [ "$USB3ON" != "1" ]; then
		nvram set usb_usb3=1
		nvram commit
		USBON="1"
		fi
else
	if [ "$lang" = "zh" ]; then
		printf '你的路由器好像没有 USB 3.0 接口\n'
	else
		printf 'Error, USB 3.0 port not found.\n'
	fi
fi
}

Download_files () {
iconlocalmd5="$(md5sum "$spath/usbstatus.png" | awk '{print $1}')"
iconremotemd5="$(curl -fsL --retry 3 "$GITHUB_DIR/usbstatus.png" | md5sum | awk '{print $1}')"
if [ "$iconlocalmd5" != "$iconremotemd5" ]; then
	curl --retry 3 "$GITHUB_DIR/usbstatus.png" -o "$spath/usbstatus.png" && chmod 644 $spath/usbstatus.png
fi

localmd5="$(md5sum "$spath/usbaccelerator.sh" | awk '{print $1}')"
remotemd5="$(curl -fsL --retry 3 "$GITHUB_DIR/usbaccelerator.sh" | md5sum | awk '{print $1}')"
if [ "$localmd5" != "$remotemd5" ]; then
	curl --retry 3 "$GITHUB_DIR/usbaccelerator.sh" -o "$spath/usbaccelerator.sh" && chmod 755 $spath/usbaccelerator.sh
fi
}

Enable () {
Check
Download_files
SMB="$(cat /tmp/etc/smb.conf | grep 'strict locking' | wc -l)"
if [ "$SMB" != "1" ]; then
	echo '#!/bin/sh' > $spath/smb.postconf
	echo 'CONFIG="$1"' >> $spath/smb.postconf
	echo 'sed -i "\~socket options~d" "$CONFIG"' >> $spath/smb.postconf
	echo 'echo "strict locking = no" >> "$CONFIG"' >> $spath/smb.postconf
	echo 'mount --bind /jffs/scripts/usbstatus.png /www/images/New_ui/usbstatus.png' >> $spath/smb.postconf
	chmod 755 $spath/smb.postconf
	service restart_nasapps
fi

if [ "$USBON" != "1" ]; then
	if [ "$lang" = "zh" ]; then
		printf '已经开启USB加速器！\n'
	else
		printf 'The USB Accelerator is enabled!\n'
	fi
else
	if [ "$lang" = "zh" ]; then
		printf '已经开启USB加速器！\n'
		printf '你可能需要重新启动才能达到最佳速度\n'
	else
		printf 'The USB Accelerator is enabled!\n'
		printf 'For get the best speed, you may need to reboot the router.\n'
	fi
fi
}

Disable () {
rm $spath/smb.postconf
service restart_nasapps
umount /www/images/New_ui/usbstatus.png
if [ "$lang" = "zh" ]; then
	printf 'USB加速器已经关闭，如果未来需要再次开启，你需要重新运行本脚本\n'
else
	printf 'The USB accelerator has been disabled and running this script again can be enabled again.\n'
fi
}

Remove () {
rm $spath/smb.postconf
rm $spath/usbstatus.png
rm $spath/usbaccelerator.sh
service restart_nasapps
umount /www/images/New_ui/usbstatus.png
if [ "$lang" = "zh" ]; then
	printf 'USB加速器已经完全卸载，所有一切都恢复到了原始状态\n'
else
	printf 'The USB accelerator has been removed and everything has been restored to default value.\n'
fi
}
Select_language