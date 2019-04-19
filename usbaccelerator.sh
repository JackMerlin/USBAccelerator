#!/bin/sh

###################################################################
######                USB Accelerator by Jack                ######
######                      Version 1.0                      ######
######                                                       ######
######     https://github.com/JackMerlin/USBAccelerator      ######
######                                                       ######
###################################################################

export PATH=/sbin:/bin:/usr/sbin:/usr/bin:$PATH
VERSION='1.0'
SPATH='/jffs/scripts'
GITHUB='https://github.com/JackMerlin/USBAccelerator'
GITHUB_DIR='https://raw.githubusercontent.com/JackMerlin/USBAccelerator/master'
COLOR_WHITE='\033[0m'
COLOR_LIGHT_WHITE='\033[1;37m'
COLOR_GREEN='\033[0;32m'
COLOR_LIGHT_GREEN='\033[1;32m'

Select_language () {
User="1"
End_Message="1"
printf '\n___________________________________________________________________\n'
printf '请选择语言\n'
printf 'Please choose a language.\n'
printf '\n'
printf ' %b1%b 中文%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
printf ' %b2%b English%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
printf '___________________________________________________________________\n'
printf '请输入对应数字\n'
printf 'Please enter the number\n'
printf '\n'
read -r "menu0"
case "$menu0" in
	1)Welcome_message_zh
	;;
	2)Welcome_message
	;;
esac
}

Welcome_message_zh () {
Check_folder
while true; do
lang="zh"
printf '\n___________________________________________________________________\n'
printf '感谢你使用%bUSB加速器%bv%s，它可以显著提升路由器SMB协议下的USB读写速度，\n' "$COLOR_GREEN" "$COLOR_WHITE" "$VERSION"
printf '根据测试，USB加速器提升效率高达百分之10~240。\n'
printf '在原始系统中一些参数被保守地锁定在较低的值内，\n'
printf '因此加速器的原理其实是精确调教系统参数来释放硬件应有的性能。\n' 
printf '___________________________________________________________________\n'
printf '%b注意：%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf '这是一个比较早期的脚本，它可能会有些不尽如人意，\n'
printf '所以，如果有任何问题请反馈给我。\n'
printf '\n'
printf '%b版权：%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf '(c)2019 USB加速器由Jack制作，使用GPLv3许可证发布。\n'
printf '如果你遵循GPLv3许可证，你可以自由地使用它。\n'
printf '源码在 %s\n' "$GITHUB"
printf '许可证全文 %s/blob/master/LICENSE\n' "$GITHUB"
printf '___________________________________________________________________\n'
if [ "$CheckEnable" = "0" ]; then
	printf '输入 %b1%b 开启%bUSB加速器\n' "$COLOR_LIGHT_GREEN" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
fi
if [ "$CheckEnable" = "1" ]; then
	printf '输入 %b2%b 关闭%bUSB加速器\n' "$COLOR_LIGHT_GREEN" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
	printf '输入 %b3%b 重装%bUSB加速器\n' "$COLOR_LIGHT_GREEN" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
fi
if [ -f "$SPATH/usbaccelerator.sh" ]; then
	printf '输入 %b4%b 更新%bUSB加速器\n' "$COLOR_LIGHT_GREEN" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
fi
	printf '输入 %b5%b 查看%b致谢名单\n' "$COLOR_LIGHT_GREEN" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
	printf '输入 %b9%b 卸载%bUSB加速器\n' "$COLOR_LIGHT_GREEN" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
	printf '输入 %be%b 退出安装%bUSB加速器\n' "$COLOR_LIGHT_GREEN" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
printf '___________________________________________________________________\n'
printf '请输入对应内容\n'
printf '\n'
read -r "menu1"
case "$menu1" in
0)Error_344
break
;;
1)Select_firmware
break
;;
2)Disable
break
;;
3)Reinstall
break
;;
4)Check_updates
break
;;
5)Thanks_list
break
;;
9)Validate_removal
break
;;
e)exit 0
;;
*)printf '\n请输入正确内容。\n'
;;
esac
done
}

Welcome_message () {
Check_folder
while true; do
lang="en"
printf '\n___________________________________________________________________\n'
printf 'Welcome to use %bUSB Accelerator%b Version %s,\n' "$COLOR_GREEN" "$COLOR_WHITE" "$VERSION"
printf 'It can improve USB read and write performance when your router uses the SMB protocol.\n'
printf 'How does it work?\n'
printf 'Trust me, it does not have the magic, it just changes some settings to the best.\n' 
printf '___________________________________________________________________\n'
printf '%bWarning%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf 'Maybe some settings not working for you,\n'
printf 'But, your feedback can make it be better, so let me hear your voice.\n'
printf '\n'
printf '%bCopyright%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf '(c)2019 USB Accelerator by Jack, Use the GPLv3 license.\n'
printf 'You can find the source code or feedback below\n'
printf '%s\n' "$GITHUB"
printf 'The license: %s/blob/master/LICENSE\n' "$GITHUB"
printf '___________________________________________________________________\n'
if [ "$CheckEnable" = "0" ]; then
	printf 'Enter %b1%b to %bEnable%b USB Accelerator\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
fi
if [ "$CheckEnable" = "1" ]; then
	printf 'Enter %b2%b to %bDisable%b USB Accelerator\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
	printf 'Enter %b3%b to %bRe-install%b USB Accelerator\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
fi
if [ -f "$SPATH/usbaccelerator.sh" ]; then
		printf 'Enter %b4%b to %bUpdate%b USB Accelerator\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
fi
	printf 'Enter %b5%b to %bShow%b thanks list\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
	printf 'Enter %b9%b to %bRemove%b USB Accelerator\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
	printf 'Enter %be%b to %bExit%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
printf '___________________________________________________________________\n'
printf 'Please enter\n'
printf '\n'
read -r "menu1"
case "$menu1" in
0)Error_344
break
;;
1)Select_firmware
break
;;
2)Disable
break
;;
3)Reinstall
break
;;
4)Check_updates
break
;;
5)Thanks_list
break
;;
9)Validate_removal
break
;;
e)exit 0
;;
*)printf '\nPlease enter a valid option.\n'
;;
esac
done
}

Select_firmware () {
while true; do
if [ "$lang" = "zh" ]; then
printf '\n___________________________________________________________________\n'
printf '请选择安装模式\n'
printf '\n'
printf '输入 %b1%b 使用%b梅林模式%b安装（适用于原版Merlin和改版梅林固件的路由器）\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
printf '输入 %b2%b 使用%b官方模式%b安装（适用于华硕官方和华硕官改固件的路由器）\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
printf '输入 %b3%b 返回上级菜单\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf '___________________________________________________________________\n'
printf '请输入对应数字\n'
printf '\n'
read -r "menu2"
case "$menu2" in
1)Enable
break
;;
2)SFW_Enable
break
;;
3)Welcome_message_zh
break
;;
*)printf '\n请输入正确内容。\n'
;;
esac
else
printf '\n___________________________________________________________________\n'
printf 'Does your router running %bAsuswrt-Merlin%b firmware?\n' "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
printf '\n'
printf '%by%b = Yes, it is true.\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf '%bn%b = No, this is asus Stock firmware.\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf '%br%b = Return to the previous menu.\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf '___________________________________________________________________\n'
printf 'Please enter\n'
printf '\n'
read -r "menu2"
case "$menu2" in
y)Enable
break
;;
n)SFW_Enable
break
;;
r)Welcome_message
break
;;
*)printf '\nPlease enter a valid option.\n'
;;
esac
fi
done
}

Validate_removal () {
while true; do
if [ "$lang" = "zh" ]; then
printf '\n___________________________________________________________________\n'
printf '你确定卸载USB加速器吗？\n'
printf '\n'
printf '输入 %by%b 确定卸载\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf '输入 %bn%b 不卸载\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf '___________________________________________________________________\n'
printf '请输入对应字母\n'
printf '\n'
read -r "menu3"
case "$menu3" in
y)Remove
break
;;
n)Welcome_message_zh
break
;;
*)printf '\n请输入正确内容。\n'
;;
esac
else
printf '\n___________________________________________________________________\n'
printf 'Are you sure to remove USB Accelerator?\n'
printf '\n'
printf '%by%b = Yes, I am sure\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf '%bn%b = Cancel\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf '___________________________________________________________________\n'
printf 'Please enter\n'
printf '\n'
read -r "menu3"
case "$menu3" in
y)Remove
break
;;
n)Welcome_message
break
;;
*)printf '\nPlease enter a valid option.\n'
;;
esac
fi
done
}

Thanks_list () {
Names='nyanmisaka, qiutian128, iphone8, pmc_griffon, tzh5278, samsul, 特纳西特基欧, dbslsy, ricky1992, awee, Master, lesliesu255, zk0119, 全池泼洒, glk17, luoyulong, kimhai, xiaole51, vipnetant, vvwn'
if [ "$lang" = "zh" ]; then
printf '\n___________________________________________________________________\n'
printf '%b特别感谢：%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf '（排名不分先后）\n'
printf 'SNBForums的Adamm发现的关键配置\n'
printf 'Koolshare对本项目的支持\n'
printf '52asus对本项目的支持\n'
printf '\n'
printf '%b没有以下测试人员抽出宝贵时间去测试，就没有这个脚本，感谢他们：%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf '（排名不分先后）\n'
printf '%s等人\n' "$Names"
printf '___________________________________________________________________\n'
printf '按任意键继续\n'
read -r "menu4"
case "$menu4" in
	*)Welcome_message_zh
	;;
esac
else
printf '\n___________________________________________________________________\n'
printf '%bSpecial thanks%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf '(Names not listed in order)\n'
printf 'Adamm for SNBForums\n'
printf 'Koolshare for supports the project\n'
printf '52asus for supports the project\n'
printf '\n'
printf '%bThanks testers%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf '(Names not listed in order)\n'
printf '%s and others.\n' "$Names"
printf '___________________________________________________________________\n'
printf 'Enter any key to continue\n'
read -r "menu4"
case "$menu4" in
	*)Welcome_message
	;;
esac
fi
}

Error_344 () {
# Easter egg
if [ "$lang" = "zh" ]; then
printf '\n___________________________________________________________________\n'
printf '这是一个隐藏信息，以感谢你对此脚本的使用。\n'
printf '___________________________________________________________________\n'
printf '按任意键继续\n'
read -r "menu5"
case "$menu5" in
	*)Welcome_message_zh
	;;
esac
else
printf '\n___________________________________________________________________\n'
printf 'This is a easter egg to thank you for your use.\n'
printf '___________________________________________________________________\n'
printf 'Enter any key to continue\n'
read -r "menu5"
case "$menu5" in
	*)Welcome_message
	;;
esac
fi
}

Check_folder () {
if [ -d "$SPATH" ]; then
	Download_files
else
	mkdir $SPATH 2>/dev/null
	chmod 755 $SPATH 2>/dev/null
	Download_files
fi
}

Download_files () {
Checkinternet="0"
while [ "$(nvram get ntp_ready)" = "0" ] && [ "$Checkinternet" -lt "300" ]; do
	Checkinternet=$((Checkinternet+1))
	sleep 1
done

if [ "$Checkinternet" -ge "300" ]; then
	if [ "$lang" = "zh" ]; then
		printf '\n网络连接错误，请联网后再试。\n'
		logger -t "USB加速器" "网络连接错误，请联网后再试。"
	else
		printf '\nThere is no internet connection.\n'
		logger -t "USB Accelerator" "There is no internet connection."
	fi
exit 1
fi

if [ -f "$SPATH/usbstatus.png" ]; then
iconlocalmd5="$(md5sum "$SPATH/usbstatus.png" | awk '{print $1}')"
	if [ -f "/rom/etc/ssl/certs/ca-certificates.crt" ]; then
		iconremotemd5="$(wget -q -c -T 30 --ca-certificate=/rom/etc/ssl/certs/ca-certificates.crt "$GITHUB_DIR/usbstatus.png" -O /tmp/usbstatus.check && md5sum /tmp/usbstatus.check | awk '{print $1}')"
	else
		iconremotemd5="$(wget -q -c -T 30 --no-check-certificate "$GITHUB_DIR/usbstatus.png" -O /tmp/usbstatus.check && md5sum /tmp/usbstatus.check | awk '{print $1}')"
	fi
	if [ "$iconlocalmd5" != "$iconremotemd5" ]; then
		mv -f /tmp/usbstatus.check $SPATH/usbstatus.png 2>/dev/null && chmod 644 $SPATH/usbstatus.png 2>/dev/null
	else
		rm -f /tmp/usbstatus.check 2>/dev/null
	fi
else
	if [ -f "/rom/etc/ssl/certs/ca-certificates.crt" ]; then
		wget -q -c -T 30 --ca-certificate=/rom/etc/ssl/certs/ca-certificates.crt "$GITHUB_DIR/usbstatus.png" -O "$SPATH/usbstatus.png" && chmod 644 $SPATH/usbstatus.png
	else
		wget -q -c -T 30 --no-check-certificate "$GITHUB_DIR/usbstatus.png" -O "$SPATH/usbstatus.png" && chmod 644 $SPATH/usbstatus.png
	fi
fi

if [ -f "$SPATH/usbaccelerator.sh" ]; then
localmd5="$(md5sum "$SPATH/usbaccelerator.sh" | awk '{print $1}')"
	if [ -f "/rom/etc/ssl/certs/ca-certificates.crt" ]; then
		remotemd5="$(wget -q -c -T 30 --ca-certificate=/rom/etc/ssl/certs/ca-certificates.crt "$GITHUB_DIR/usbaccelerator.sh" -O /tmp/usbaccelerator.check && md5sum /tmp/usbaccelerator.check | awk '{print $1}')"
	else
		remotemd5="$(wget -q -c -T 30 --no-check-certificate "$GITHUB_DIR/usbaccelerator.sh" -O /tmp/usbaccelerator.check && md5sum /tmp/usbaccelerator.check | awk '{print $1}')"
	fi
		if [ "$localmd5" != "$remotemd5" ]; then
		mv -f /tmp/usbaccelerator.check $SPATH/usbaccelerator.sh 2>/dev/null && chmod 755 $SPATH/usbaccelerator.sh 2>/dev/null
		Checkupdates="1"
	else
		rm -f /tmp/usbaccelerator.check 2>/dev/null
		Checkupdates="0"
	fi
else
	if [ -f "/rom/etc/ssl/certs/ca-certificates.crt" ]; then
		wget -q -c -T 30 --ca-certificate=/rom/etc/ssl/certs/ca-certificates.crt "$GITHUB_DIR/usbaccelerator.sh" -O "$SPATH/usbaccelerator.sh" && chmod 755 $SPATH/usbaccelerator.sh
	else
		wget -q -c -T 30 --no-check-certificate "$GITHUB_DIR/usbaccelerator.sh" -O "$SPATH/usbaccelerator.sh" && chmod 755 $SPATH/usbaccelerator.sh
	fi
	Checkupdates="1"
fi
}

Check_updates () {
if [ "$Checkupdates" = "1" ]; then
printf '\n___________________________________________________________________\n'
	if [ "$lang" = "zh" ]; then
		printf '更新完成，接下来将返回主菜单，建议手动关闭加速器并重新开启。\n'
		printf '___________________________________________________________________\n'
		printf '按任意键继续\n'
		read -r "menu6"
		case "$menu6" in
		*)$SPATH/usbaccelerator.sh
		;;
		esac
	fi
	if [ "$lang" = "en" ]; then
		printf 'Update completed! Please disable the USB accelerator and enable it again.\n'
		printf '___________________________________________________________________\n'
		printf 'Enter any key to continue\n'
		read -r "menu6"
		case "$menu6" in
		*)$SPATH/usbaccelerator.sh
		;;
		esac
	fi
fi

if [ "$Checkupdates" = "0" ]; then
printf '\n___________________________________________________________________\n'
	if [ "$lang" = "zh" ]; then
		printf '暂无可用的更新。\n'
		printf '___________________________________________________________________\n'
		printf '按任意键继续\n'
		read -r "menu6"
		case "$menu6" in
		*)Welcome_message_zh
		;;
		esac
	fi
	if [ "$lang" = "en" ]; then
		printf 'No updates is available.\n'
		printf '___________________________________________________________________\n'
		printf 'Enter any key to continue\n'
		read -r "menu6"
		case "$menu6" in
		*)Welcome_message
		;;
		esac
	fi
fi
}

Check_jffs () {
if [ "$(nvram get jffs2_scripts)" != "1" ]; then
nvram set jffs2_scripts="1"
nvram commit
Needtoreboot="1"
fi
}

Check_usbmode () {
USB3="$(nvram show 2>/dev/null | grep 'usb_usb3' | wc -l)"
if [ "$USB3" = "1" ]; then
	if [ "$(nvram get usb_usb3)" != "1" ]; then
		nvram set usb_usb3="1"
		nvram commit
		Needtoreboot="1"
			if [ "$lang" = "zh" ]; then
				printf '\n已经为你开启USB 3.0。\n'
			fi
			if [ "$lang" = "en" ]; then
				printf '\nUSB Accelerator has enabled USB 3.0 mode for you.\n'
			fi
	fi
else
	if [ "$lang" = "zh" ]; then
		printf '\n你的路由器好像没有USB 3.0接口。\n'
	fi
	if [ "$lang" = "en" ]; then
		printf '\nThe USB 3.0 port not found.\n'
	fi
fi
}

Umount_message () {
if [ "$(df -h | grep -c 'mnt')" -ge "1" ]; then
	if [ "$lang" = "zh" ]; then
		echo "___________________________________________________________________"
		printf '安装完成前请不要读写USB。\n'
		echo "___________________________________________________________________"
	fi
	if [ "$lang" = "en" ]; then
		echo "___________________________________________________________________"
		printf 'For data security, do not read or write any data to \n'
		printf 'Router USB devices before the installation is done.\n'
		echo "___________________________________________________________________"
	fi
	
fi
}

Enable () {
Check_usbmode
Check_jffs
if [ -f "$SPATH/smb.postconf" ]; then
	cp -f $SPATH/smb.postconf $SPATH/smb.postconf.old
fi
echo '#!/bin/sh' > $SPATH/smb.postconf
echo "#USB_Accelerator_v$VERSION" >> $SPATH/smb.postconf
echo 'CONFIG="$1"' >> $SPATH/smb.postconf
echo 'sed -i "\\~socket options~d" "$CONFIG"' >> $SPATH/smb.postconf
echo 'echo "socket options = IPTOS_LOWDELAY TCP_NODELAY SO_KEEPALIVE" >> "$CONFIG"' >> $SPATH/smb.postconf
echo 'echo "strict locking = no" >> "$CONFIG"' >> $SPATH/smb.postconf
echo "echo '#USB_Accelerator_v$VERSION' >> /etc/smb.conf" >> $SPATH/smb.postconf
if [ "$lang" = "zh" ]; then
	echo "$SPATH/usbaccelerator.sh -DLZ" >> $SPATH/smb.postconf
else
	echo "$SPATH/usbaccelerator.sh -DL" >> $SPATH/smb.postconf
fi
echo 'sleep 10' >> $SPATH/smb.postconf
echo "$SPATH/usbaccelerator.sh -Check"  >> $SPATH/smb.postconf
chmod 755 $SPATH/smb.postconf
service restart_nasapps >/dev/null 2>&1

if [ "$End_Message" = "1" ]; then
End_Message
fi
}

SFW_Enable () {
if [ "$User" = "1" ]; then
	Umount_message
	Check_usbmode
	echo '#!/bin/sh' > $SPATH/sfsmb
	echo "#USB_Accelerator_v$VERSION" >> $SPATH/sfsmb
	echo 'sleep 5' >> $SPATH/sfsmb
	echo "$SPATH/usbaccelerator.sh -SFW" >> $SPATH/sfsmb
	if [ "$lang" = "zh" ]; then
		echo "$SPATH/usbaccelerator.sh -DLZ" >> $SPATH/sfsmb
	else
		echo "$SPATH/usbaccelerator.sh -DL" >> $SPATH/sfsmb
	fi
	echo 'sleep 10' >> $SPATH/sfsmb
	echo "$SPATH/usbaccelerator.sh -Check"  >> $SPATH/sfsmb
	chmod 755 $SPATH/sfsmb
	if [ -f "/jffs/post-mount" ]; then
		if [ "$(grep 'sfsmb' /jffs/post-mount 2>/dev/null | wc -l)" = "0" ]; then
			echo "$SPATH/sfsmb" >> /jffs/post-mount
			if [ -n "$(nvram get script_usbmount)" ] && [ "$(nvram get script_usbmount)" != "/jffs/post-mount" ]; then
				echo "$(nvram get script_usbmount)" >> /jffs/post-mount
			fi
			chmod 755 /jffs/post-mount
		fi
	else
		echo '#!/bin/sh' > /jffs/post-mount
		echo "$SPATH/sfsmb" >> /jffs/post-mount
		if [ -n "$(nvram get script_usbmount)" ] && [ "$(nvram get script_usbmount)" != "/jffs/post-mount" ]; then
			echo "$(nvram get script_usbmount)" >> /jffs/post-mount
		fi
		chmod 755 /jffs/post-mount
	fi
	nvram set script_usbmount="/jffs/post-mount"
	nvram commit
fi

if [ "$(grep USB_Accelerator /etc/smb.conf 2>/dev/null | wc -l)" = "0" ]; then	
	if [ "$(ps -w | grep smbd | grep -v grep | wc -l)" -ge "1" ]; then
		while [ "$(ps -w | grep smbd | grep -v grep | wc -l)" -ge "1" ]; do
			kill $(ps -w | grep smbd | grep -v grep | head -n 1 | awk '{print $1}') 2>/dev/null
			kill $(ps -w | grep nmbd | grep -v grep | head -n 1 | awk '{print $1}') 2>/dev/null
		done
		sleep 1
		sed -i "\\~socket options~d" /etc/smb.conf
		echo "socket options = IPTOS_LOWDELAY TCP_NODELAY SO_KEEPALIVE" >> /etc/smb.conf
		echo "strict locking = no" >> /etc/smb.conf
		echo "#USB_Accelerator_v$VERSION" >> /etc/smb.conf
		nmbd -D -s /etc/smb.conf 2>/dev/null
		/usr/sbin/smbd -D -s /etc/smb.conf 2>/dev/null
	fi
fi

if [ "$End_Message" = "1" ]; then
End_Message
fi

if [ "$User" = "1" ]; then
	if [ "$lang" = "zh" ]; then
		Enable_logs_zh
	else
		Enable_logs
	fi
fi
}

Enable_logs_zh () {
if [ "$(grep 'IPTOS_LOWDELAY TCP_NODELAY SO_KEEPALIVE' /etc/smb.conf 2>/dev/null | wc -l)$(grep 'socket options' /etc/smb.conf 2>/dev/null | wc -l)" = "11" ]; then
	Logout="成功"
else
	Logout="几乎成功"
fi
logger -t "USB加速器" "USB加速器v$(grep USB_Accelerator /etc/smb.conf | awk -F 'v' '{print $2}')$Logout启动。"
logger -t "USB加速器" "如果你需要管理USB加速器，则在SSH中输入： $SPATH/usbaccelerator.sh"
if [ "$(df -h | grep -c 'usbstatus.png')" = "0" ]; then
mount --bind $SPATH/usbstatus.png /www/images/New_ui/usbstatus.png
fi
}

Enable_logs () {
if [ "$(grep 'IPTOS_LOWDELAY TCP_NODELAY SO_KEEPALIVE' /etc/smb.conf 2>/dev/null | wc -l)$(grep 'socket options' /etc/smb.conf 2>/dev/null | wc -l)" = "11" ]; then
	Logout="successfully"
else
	Logout="almost successfully"
fi
logger -t "USB Accelerator" "USB Accelerator v$(grep USB_Accelerator /etc/smb.conf | awk -F 'v' '{print $2}') has been $Logout started."
logger -t "USB Accelerator" "If you want to set USB Accelerator, Please enter the code in the SSH client: $SPATH/usbaccelerator.sh"
if [ "$(df -h | grep -c 'usbstatus.png')" = "0" ]; then
mount --bind $SPATH/usbstatus.png /www/images/New_ui/usbstatus.png
fi
}

End_Message () {
printf '\n___________________________________________________________________\n'
if [ "$lang" = "zh" ]; then
	printf '已经开启USB加速器！\n'
		if [ "$Needtoreboot" = "1" ]; then
			printf '你可能需要重新启动才能达到最佳速度。\n'
		fi
	printf '如果你需要管理USB加速器，则在SSH中输入下方代码\n'
else
	printf 'USB Accelerator is enabled!\n'
		if [ "$Needtoreboot" = "1" ]; then
			printf 'For get the best speed, you may need to reboot the router.\n'
		fi
	printf 'If you want to set USB Accelerator, Please enter the code below in the SSH client\n'
fi
printf '%b%s/usbaccelerator.sh%b\n' "$COLOR_LIGHT_WHITE" "$SPATH" "$COLOR_WHITE"
printf '___________________________________________________________________\n'
}

Disable () {
rm -f $SPATH/sfsmb 2>/dev/null
sed -i "\\~sfsmb~d" /jffs/post-mount 2>/dev/null
rm -f $SPATH/smb.postconf 2>/dev/null
if [ "$(cat /jffs/post-mount 2>/dev/null | wc -l)" -le "1" ]; then
	nvram set script_usbmount=""
	nvram commit
fi
service restart_nasapps >/dev/null 2>&1
umount -f /www/images/New_ui/usbstatus.png 2>/dev/null
printf '\n___________________________________________________________________\n'
if [ "$lang" = "zh" ]; then
	printf 'USB加速器已经关闭，如果未来需要再次开启，则在SSH里输入下方代码：\n'
else
	printf 'USB Accelerator has been disabled, Enter the code below to enable it again\n'
fi
printf '%b%s/usbaccelerator.sh%b\n' "$COLOR_LIGHT_WHITE" "$SPATH" "$COLOR_WHITE"
printf '___________________________________________________________________\n'
}

Reinstall () {
Remove
Download_files
if [ "$lang" = "zh" ]; then
	printf '\nUSB加速器已经重新安装。\n'
else
	printf '\nUSB Accelerator has been re-install now.\n'
fi
$SPATH/usbaccelerator.sh
}

Remove () {
umount -f /www/images/New_ui/usbstatus.png 2>/dev/null
rm -f $SPATH/sfsmb 2>/dev/null
sed -i "\\~sfsmb~d" /jffs/post-mount 2>/dev/null
rm -f $SPATH/smb.postconf 2>/dev/null
rm -f $SPATH/usbstatus.png 2>/dev/null
rm -f $SPATH/usbaccelerator.sh 2>/dev/null
if [ "$(cat /jffs/post-mount 2>/dev/null | wc -l)" -le "1" ]; then
	nvram set script_usbmount=""
	nvram commit
	rm -f /jffs/post-mount 2>/dev/null
fi
service restart_nasapps >/dev/null 2>&1
if [ "$lang" = "zh" ]; then
	printf '\nUSB加速器已经完全卸载，所有的一切都恢复到了安装前的状态。\n'
else
	printf '\nUSB Accelerator has been removed and everything changes before is restored to the default value.\n'
fi
}

CheckEnable="0"
if [ -f "$SPATH/smb.postconf" ]; then
	if [ "$(grep USB_Accelerator_v$VERSION $SPATH/smb.postconf 2>/dev/null | wc -l)" = "0" ]; then
		Check_folder
		Enable
		CheckEnable="1"
	else
		CheckEnable="1"
	fi
fi

if [ -f "$SPATH/sfsmb" ]; then
	if [ "$(grep USB_Accelerator_v$VERSION $SPATH/sfsmb 2>/dev/null | wc -l)" = "0" ]; then
		Check_folder
		User="1"
		SFW_Enable
		CheckEnable="1"
	else
		CheckEnable="1"
	fi
fi

clear
case "$1" in
-SFW)SFW_Enable
;;
-Check)Download_files
;;
-DLZ)Enable_logs_zh
;;
-DL)Enable_logs
;;
*)Select_language
;;
esac
