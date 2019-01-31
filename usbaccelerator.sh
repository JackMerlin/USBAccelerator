#!/bin/sh

###################################################################
######                USB Accelerator by Jack                ######
######                     Version 0.2.3                     ######
######                                                       ######
######     https://github.com/JackMerlin/USBAccelerator      ######
######                                                       ######
###################################################################

export PATH=/sbin:/bin:/usr/sbin:/usr/bin$PATH
GITHUB_DIR="https://raw.githubusercontent.com/JackMerlin/USBAccelerator/master"
SPATH="/jffs/scripts"
VERSION="0.2.3"
COLOR_WHITE='\033[0m'
COLOR_LIGHT_WHITE='\033[1;37m'
COLOR_GREEN='\033[0;32m'
COLOR_LIGHT_GREEN='\033[1;32m'

Select_language () {
printf '\n___________________________________________________________________\n'
printf '选择语言\n'
printf 'Please choose the display language.\n'
printf '\n'
printf '%b1%b 中文%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
printf '%b2%b English%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
printf '\n___________________________________________________________________\n'
printf '请输入对应数字\n'
printf 'Please enter the number\n'
printf '\n'
read -r "menu0"
case "$menu0" in
	1)Welcome_message_zh
	break
	;;
	2)Welcome_message
	break
	;;
esac
}

Welcome_message_zh () {
lang="zh"
printf '\n___________________________________________________________________\n'
printf '\n'
printf '感谢你使用%bUSB加速器%b v%s，它可以显著提升路由器SMB协议下的USB读写速度，\n' "$COLOR_GREEN" "$COLOR_WHITE" "$VERSION"
printf '根据测试，USB加速器提升效率高达百分之10~240。\n'
printf '在原始系统中一些参数被保守地锁定在较低的值内，\n'
printf '因此加速器的原理其实是精确调教系统参数来释放硬件应有的性能。\n' 
printf '___________________________________________________________________\n'
printf '\n'
printf '%b注意：%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf '这是一个相当早期的脚本，它目前仍处在预览阶段，\n'
printf '所以，如果有任何问题请反馈给我。\n'
printf '\n'
printf '%b版权：%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf '(c)2019 USB加速器由Jack制作，保留所有权利，使用GPLv3授权。\n'
printf '如果你尊重GPLv3授权，你可以自由地使用它。\n'
printf '源码在 https://github.com/JackMerlin/USBAccelerator\n'
printf '___________________________________________________________________\n'
CheckEnable="$(cat /etc/smb.conf 2>/dev/null | grep 'USB_Accelerator' | wc -l)"
if [ "$CheckEnable" != "1" ]; then
	printf '输入 %b1%b 开启%bUSB加速器\n' "$COLOR_LIGHT_GREEN" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
else
	printf '输入 %b2%b 关闭%bUSB加速器\n' "$COLOR_LIGHT_GREEN" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
fi
localmd5="$(md5sum "$SPATH/usbaccelerator.sh" | awk '{print $1}')"
remotemd5="$(curl -fsL --retry 3 "$GITHUB_DIR/usbaccelerator.sh" | md5sum | awk '{print $1}')"
if [ "$localmd5" != "$remotemd5" ]; then
	printf '输入 %b3%b 更新%bUSB加速器\n' "$COLOR_LIGHT_GREEN" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
fi
if [ "$CheckEnable" = "1" ]; then
	printf '输入 %b4%b 重装%bUSB加速器\n' "$COLOR_LIGHT_GREEN" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
fi
	printf '输入 %b5%b 查看%b致谢名单\n' "$COLOR_LIGHT_GREEN" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
	printf '输入 %b9%b 卸载%bUSB加速器\n' "$COLOR_LIGHT_GREEN" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
printf '___________________________________________________________________\n'
printf '请输入对应数字\n'
printf '\n'
read -r "menu1"
case "$menu1" in
0)Error_344_zh
break
;;
1)Select_firmware
break
;;
2)Disable
break
;;
3)Check_folder
Welcome_message_zh
break
;;
4)Reinstall
break
;;
5)Thanks_list_zh
break
;;
9)Remove
break
;;
*)
printf '请输入正确内容。\n'
Welcome_message_zh
break
;;
esac
}

Welcome_message () {
lang="en"
printf '\n___________________________________________________________________\n'
printf '\n \n'
printf 'Welcome to use the %bUSB Accelerator%b Version %s,\n' "$COLOR_GREEN" "$COLOR_WHITE" "$VERSION"
printf 'It can improve USB read and write performance when your router uses the SMB protocol.\n'
printf 'How does it work?\n'
printf 'Trust me, it does not have the magic, it just changes some settings to the best.\n' 
printf '___________________________________________________________________\n'
printf '\n'
printf '%bWarning%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf 'Now it is a preview version, I mean maybe something not working for you,\n'
printf 'But, your feedback can make it be better, so let me hear your voice.\n'
printf '\n'
printf '%bCopyright%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf '(c)2019 USB Accelerator by Jack, Use the GPLv3 license.\n'
printf 'You can find the source code or feedback below\n'
printf 'https://github.com/JackMerlin/USBAccelerator\n'
printf '___________________________________________________________________\n'
CheckEnable="$(cat /etc/smb.conf 2>/dev/null | grep 'USB_Accelerator' | wc -l)"
if [ "$CheckEnable" != "1" ]; then
	printf 'Enter %b1%b to %bEnable%b the USB Accelerator\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
else
	printf 'Enter %b2%b to %bDisable%b the USB Accelerator\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
fi
localmd5="$(md5sum "$SPATH/usbaccelerator.sh" | awk '{print $1}')"
remotemd5="$(curl -fsL --retry 3 "$GITHUB_DIR/usbaccelerator.sh" | md5sum | awk '{print $1}')"
if [ "$localmd5" != "$remotemd5" ]; then
	printf 'Enter %b3%b to %bUpdate%b the USB Accelerator\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
fi
if [ "$CheckEnable" = "1" ]; then
	printf 'Enter %b4%b to %bRe-install%b the USB Accelerator\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
fi
	printf 'Enter %b5%b to %bShow%b the thanks list\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
	printf 'Enter %b9%b to %bRemove%b the USB Accelerator\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
printf '___________________________________________________________________\n'
printf 'Please enter the number\n'
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
3)Check_folder 
Welcome_message
break
;;
4)Reinstall
break
;;
5)Thanks_list
break
;;
9)Remove
break
;;
*)
printf 'Please enter a valid option.\n'
Welcome_message
break
;;
esac
}

Select_firmware () {
if [ "$lang" = "zh" ]; then
	printf '___________________________________________________________________\n'
	printf '\n'
	printf '请选择安装模式\n'
	printf '\n'
	printf '输入 %b1%b 使用%b梅林模式%b安装（适用于原版Merlin和改版梅林固件的路由器）\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
	printf '输入 %b2%b 使用%b官方模式%b安装（适用于华硕官方和华硕官改固件的路由器）\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE" "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
	printf '其他固件请输入 %b3%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
	printf '___________________________________________________________________\n'
	printf '请输入对应数字\n'
	printf '\n'
	read -r "menu2"
	case "$menu2" in
	1)
	Enable
	break
	;;
	2)
	printf '此模式处于测试状态，可能效果并不明显。'
	SFW_Enable
	break
	;;
	3)
	printf '不支持其他固件，谢谢。'
	Select_firmware
	break
	;;
	*)
	printf '请输入正确内容。\n'
	Select_firmware
	break
	;;
	esac
else
	printf '___________________________________________________________________\n'
	printf '\n'
	printf 'Does your router running %Asuswrt-Merlin%b firmware?\n' "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
	printf '\n'
	printf '%by%b = Yes, it is true.\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
	printf '%bn%b = No, this is asus stock firmware.\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
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
	*)
	printf 'Please enter a valid option.\n'
	Select_firmware
	break
	;;
	esac
fi
}

Thanks_list_zh () {
printf '%b特别感谢：%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf ' （排名不分先后）\n'
printf 'SNBForums的Adamm发现的关键配置\n'
printf 'Koolshare的sadog协助兼容Asuswrt固件\n'
printf 'Koolshare对本项目的支持\n'
printf '52asus对本项目的支持\n'
printf '\n'
printf '%b没有以下测试人员抽出宝贵时间去测试，就没有这个脚本，感谢他们：%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf ' （排名不分先后）\n'
printf 'nyanmisaka、qiutian128、iphone8、pmc_griffon、tzh5278、samsul、特纳西特基欧、dbslsy、ricky1992、awee和Master等人\n'
Welcome_message_zh
}

Thanks_list () {
printf '%bSpecial thanks%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf 'Names not listed in order\n'
printf 'Adamm for SNBForums\n'
printf 'sadog for Koolshare\n'
printf 'Koolshare for supports the project\n'
printf '52asus for supports the project\n'
printf '\n'
printf '%bThanks also to the following testers%b\n' "$COLOR_LIGHT_GREEN" "$COLOR_WHITE"
printf 'Names not listed in order\n'
printf 'nyanmisaka, qiutian128, iphone8, pmc_griffon, tzh5278, samsul, 特纳西特基欧, dbslsy, ricky1992, awee, Master and others.\n'
Welcome_message
}

Error_344_zh () {
# Easter egg
printf '___________________________________________________________________\n'
printf '你的路由器即将在5秒后爆炸，请享受这个烟火表演。\n'
printf '___________________________________________________________________\n'
sleep 1
printf '5\n'
sleep 1
printf '4\n'
sleep 1
printf '3\n'
sleep 5
printf '___________________________________________________________________\n'
printf '糟糕，代码错误，引爆失败，请向作者报告这个错误。\n'
printf '___________________________________________________________________\n'
sleep 1
Welcome_message_zh
}

Error_344 () {
# Easter egg
printf '___________________________________________________________________\n'
printf 'Your router will be auto self-destruct, please enjoy bricked router.\n'
printf '___________________________________________________________________\n'
sleep 1
printf '5\n'
sleep 1
printf '4\n'
sleep 1
printf '3\n'
sleep 5
printf '___________________________________________________________________\n'
printf 'Error, please feedback this error code 344 to developers,\n'
printf 'we will fix this error in the future.\n'
printf '___________________________________________________________________\n'
sleep 1
Welcome_message
}

Check_folder () {
if [ -d "/jffs/scripts" ]; then
	Download_files
else
	mkdir $SPATH
	chmod 755 $SPATH
	Download_files
fi
}

Download_files () {
if [ -f "$SPATH/usbstatus.png" ]; then
iconlocalmd5="$(md5sum "$SPATH/usbstatus.png" | awk '{print $1}')"
iconremotemd5="$(curl -fsL --retry 3 "$GITHUB_DIR/usbstatus.png" | md5sum | awk '{print $1}')"
	if [ "$iconlocalmd5" != "$iconremotemd5" ]; then
		curl --retry 3 -s "$GITHUB_DIR/usbstatus.png" -o "$SPATH/usbstatus.png" && chmod 644 $SPATH/usbstatus.png
	fi
else
	curl --retry 3 -s "$GITHUB_DIR/usbstatus.png" -o "$SPATH/usbstatus.png" && chmod 644 $SPATH/usbstatus.png
fi

if [ -f "$SPATH/usbaccelerator.sh" ]; then
localmd5="$(md5sum "$SPATH/usbaccelerator.sh" | awk '{print $1}')"
remotemd5="$(curl -fsL --retry 3 "$GITHUB_DIR/usbaccelerator.sh" | md5sum | awk '{print $1}')"
	if [ "$localmd5" != "$remotemd5" ]; then
		curl --retry 3 -s "$GITHUB_DIR/usbaccelerator.sh" -o "$SPATH/usbaccelerator.sh" && chmod 755 $SPATH/usbaccelerator.sh
	fi
else
	curl --retry 3 -s "$GITHUB_DIR/usbaccelerator.sh" -o "$SPATH/usbaccelerator.sh" && chmod 755 $SPATH/usbaccelerator.sh
fi
}

Check_usbmode () {
USB3="$(nvram show 2>/dev/null | grep 'usb_usb3' | wc -l)"
if [ "$USB3" = "1" ]; then
	if [ "$(nvram show 2>/dev/null | grep 'usb_usb3=1')" != "usb_usb3=1" ]; then
		nvram set usb_usb3=1
		nvram commit
		USBON="1"
			if [ "$lang" = "zh" ]; then
				printf '已经为你开启USB 3.0。\n'
			else
				printf 'the USB Accelerator has enabled USB 3.0 mode for you.\n'
			fi
	fi
else
	if [ "$lang" = "zh" ]; then
		printf '你的路由器好像没有USB 3.0接口。\n'
	else
		printf 'Error, USB 3.0 port not found.\n'
	fi
fi
}

Umount_message () {
if [ "$(df -h | grep -c 'mnt')" -ge "1" ]; then
	if [ "$lang" = "zh" ]; then
		printf '___________________________________________________________________\n'
		printf 'USB加速器在安装时将暂时为你安全移除已经挂载的U盘,\n'
		printf '待安装完成后再自动帮你重新挂载。\n'
		printf '___________________________________________________________________\n'
		printf '按任意键继续\n'
		read -r "menu3"
		case "$menu3" in
		*)Umount_usb_file
		break
		;;
		esac
	else
		printf '___________________________________________________________________\n'
		printf 'For data security, the USB Accelerator will\n'
		printf 'unmount your USB devices for a little while.\n'
		printf '___________________________________________________________________\n'
		printf 'Enter any key to continue\n'
		read -r "menu3"
		case "$menu3" in
		*)Umount_usb_file
		break
		;;
		esac
	fi
fi
}

Umount_usb_file () {
echo "$(df -h | grep -i 'mnt')" > /tmp/Umountusblist
Umount_usb 
}

Umount_usb () {
if [ "$(df -h | grep -c 'mnt')" -ge "1" ]; then
umusb="$(df -h | grep -i 'mnt' | head -n 1 | cut -f 6 -d'/')"
	umount "$(df -h | grep -i 'mnt' | head -n 1 | awk '{print $NF}')" 2>/dev/null
	if [ "$?" -ne "0" ]; then
		if [ "$lang" = "zh" ]; then
			printf '___________________________________________________________________\n'
			echo "解除挂载失败，请在路由器管理页面手动解除 $(df -h | grep -i 'mnt' | cut -f 6 -d'/' | tr '\n' ' ')。"
			printf '___________________________________________________________________\n'
			printf '手动移除后按任意键继续\n'
			read -r "menu4"
			case "$menu4" in
			*)Umount_usb_file
			break
			;;
			esac
		else
			printf '___________________________________________________________________\n'
			echo "Maybe $(df -h | grep -i 'mnt' | cut -f 6 -d'/' | tr '\n' ' ')device is busy, please manually unmount in the WEB GUI."
			printf '___________________________________________________________________\n'
			printf 'Please manually unmount your USB devices and press any key to continue\n'
			read -r "menu4"
			case "$menu4" in
			*)Umount_usb_file
			break
			;;
			esac
		fi
	else
		if [ "$lang" = "zh" ]; then
			echo "$umusb 解除挂载成功。"
		else
			echo "Unmount $umusb successfully."
		fi
		while [ "$(df -h | grep -c 'mnt')" -ge "1" ]; do
			Umount_usb
		done
	fi
else 
	if [ "$lang" = "zh" ]; then
		echo "没有已经挂载的设备。"
	else
		echo "Can not found mounted devices."
	fi
fi
}

Mount_usb () {
if [ "$(cat /tmp/Umountusblist 2>/dev/null | grep -c 'mnt')" -ge "1" ]; then
mount "$(cat /tmp/Umountusblist | grep -i 'mnt' | head -n 1 | awk '{print $1}')" "$(cat /tmp/Umountusblist | grep -i 'mnt' | head -n 1 | awk '{print $NF}')"  2>/dev/null
	if [ "$?" -ne "0" ]; then
		if [ "$lang" = "zh" ]; then
			echo "尝试挂载 $(cat /tmp/Umountusblist | grep -i 'mnt' | head -n 1 | awk '{print $NF}') 失败，请手动挂载。"
		else
			echo "Mounting the $(cat /tmp/Umountusblist | grep -i 'mnt' | head -n 1 | awk '{print $NF}') device failed. Please mount it manually."
		fi
	else
		if [ "$lang" = "zh" ]; then
			echo "$(cat /tmp/Umountusblist | grep -i 'mnt' | head -n 1 | awk '{print $NF}') 挂载成功。"
		else
			echo "Mounting the $(cat /tmp/Umountusblist | grep -i 'mnt' | head -n 1 | awk '{print $NF}') device successfully."
		fi
		sed -i '1d' /tmp/Umountusblist
		while [ "$(cat /tmp/Umountusblist 2>/dev/null | grep -c 'mnt')" -ge "1" ]; do
		Mount_usb
		done
	fi
else
rm -f /tmp/Umountusblist
fi
}

Enable () {
Check_folder
Check_usbmode
SMB="$(cat /etc/smb.conf 2>/dev/null | grep 'USB_Accelerator' | wc -l)"
if [ "$SMB" != "1" ]; then
#	Umount_message
	echo '#!/bin/sh' > $SPATH/smb.postconf
	echo 'CONFIG="$1"' >> $SPATH/smb.postconf
	echo 'sed -i "\~socket options~d" "$CONFIG"' >> $SPATH/smb.postconf
	echo 'echo "strict locking = no" >> "$CONFIG"' >> $SPATH/smb.postconf
	echo 'echo "#USB_Accelerator" >> "$CONFIG"' >> $SPATH/smb.postconf
	echo 'mount --bind /jffs/scripts/usbstatus.png /www/images/New_ui/usbstatus.png' >> $SPATH/smb.postconf
	echo 'sleep 10' >> $SPATH/smb.postconf
	echo 'localmd5="$(md5sum "/jffs/scripts/usbaccelerator.sh" | awk "{print $1}")"' >> $SPATH/smb.postconf
	echo 'remotemd5="$(curl -fsL --retry 3 "https://raw.githubusercontent.com/JackMerlin/USBAccelerator/master/usbaccelerator.sh" | md5sum | awk "{print $1}")"' >> $SPATH/smb.postconf
	echo 'if [ "$localmd5" != "$remotemd5" ]; then' >> $SPATH/smb.postconf
	echo 'curl --retry 3 -s "https://raw.githubusercontent.com/JackMerlin/USBAccelerator/master/usbaccelerator.sh" -o "/jffs/scripts/usbaccelerator.sh" && chmod 755 /jffs/scripts/usbaccelerator.sh' >> $SPATH/smb.postconf
	echo 'fi' >> $SPATH/smb.postconf
	chmod 755 $SPATH/smb.postconf
	service restart_nasapps
#	Mount_usb
	Enable_Message="1"
	Enable_logs
else
	End_Message
fi
}

SFW_Enable () {
Check_folder
Check_usbmode
SMB="$(cat /etc/smb.conf 2>/dev/null | grep 'USB_Accelerator' | wc -l)"
if [ "$SMB" != "1" ]; then
	Umount_message
	sed -i "\~socket options~d" /etc/smb.conf
	echo "strict locking = no" >> /etc/smb.conf
	echo "#USB_Accelerator" >> /etc/smb.conf
	killall nmbd 2>/dev/null
	killall nmbd 2>/dev/null
	killall smbd 2>/dev/null
	killall nas 2>/dev/null
	nmbd -D -s /etc/smb.conf 2>/dev/null
	nmbd -D -s /etc/smb.conf 2>/dev/null
	/usr/sbin/smbd -D -s /etc/smb.conf 2>/dev/null
	nas 2>/dev/null
	Mount_usb
	mount --bind /jffs/scripts/usbstatus.png /www/images/New_ui/usbstatus.png
	sleep 1
	echo '#!/bin/sh' > $SPATH/sfsmb
	echo 'sleep 20' >> $SPATH/sfsmb
	echo 'sed -i "\~socket options~d" /etc/smb.conf' >> $SPATH/sfsmb
	echo 'echo "strict locking = no" >> /etc/smb.conf' >> $SPATH/sfsmb
	echo 'echo "#USB_Accelerator" >> /etc/smb.conf' >> $SPATH/sfsmb
	echo 'killall nmbd 2>/dev/null' >> $SPATH/sfsmb
	echo 'killall nmbd 2>/dev/null' >> $SPATH/sfsmb
	echo 'killall smbd 2>/dev/null' >> $SPATH/sfsmb
	echo 'killall nas 2>/dev/null' >> $SPATH/sfsmb
	echo 'nmbd -D -s /etc/smb.conf 2>/dev/null' >> $SPATH/sfsmb
	echo 'nmbd -D -s /etc/smb.conf 2>/dev/null' >> $SPATH/sfsmb
	echo '/usr/sbin/smbd -D -s /etc/smb.conf 2>/dev/null' >> $SPATH/sfsmb
	echo 'nas 2>/dev/null' >> $SPATH/sfsmb
	echo 'mount --bind /jffs/scripts/usbstatus.png /www/images/New_ui/usbstatus.png' >> $SPATH/sfsmb
	echo 'sleep 10' >> $SPATH/sfsmb
	echo 'localmd5="$(md5sum "/jffs/scripts/usbaccelerator.sh" | awk "{print $1}")"' >> $SPATH/sfsmb
	echo 'remotemd5="$(curl -fsL --retry 3 "https://raw.githubusercontent.com/JackMerlin/USBAccelerator/master/usbaccelerator.sh" | md5sum | awk "{print $1}")"' >> $SPATH/sfsmb
	echo 'if [ "$localmd5" != "$remotemd5" ]; then' >> $SPATH/sfsmb
	echo 'curl --retry 3 -s "https://raw.githubusercontent.com/JackMerlin/USBAccelerator/master/usbaccelerator.sh" -o "/jffs/scripts/usbaccelerator.sh" && chmod 755 /jffs/scripts/usbaccelerator.sh' >> $SPATH/sfsmb
	echo 'fi' >> $SPATH/sfsmb
	chmod 755 $SPATH/sfsmb
	nvram set script_usbmount="/jffs/scripts/sfsmb"
	nvram commit
	Enable_Message="0"
	Enable_logs
else
	End_Message
fi

}

Enable_logs () {
if [ "$Enable_Message" != "1" ]; then
	if [ "$lang" = "zh" ]; then
		echo 'logger -t "USB加速器" "USB加速器已经启动，代码 $(cat /etc/smb.conf | grep 'strict locking' | wc -l)$(cat /etc/smb.conf | grep 'socket options' | wc -l) 。"' >> $SPATH/sfsmb
	else
		echo 'logger -t "USB Accelerator" "The USB Accelerator has started, code $(cat /etc/smb.conf | grep 'strict locking' | wc -l)$(cat /etc/smb.conf | grep 'socket options' | wc -l)."' >> $SPATH/sfsmb
	fi
else
	if [ "$lang" = "zh" ]; then
		echo 'logger -t "USB加速器" "USB加速器已经启动，代码 $(cat /etc/smb.conf | grep 'strict locking' | wc -l)$(cat /etc/smb.conf | grep 'socket options' | wc -l) 。"' >> $SPATH/smb.postconf
	else
		echo 'logger -t "USB Accelerator" "The USB Accelerator has started, code $(cat /etc/smb.conf | grep 'strict locking' | wc -l)$(cat /etc/smb.conf | grep 'socket options' | wc -l)."' >> $SPATH/smb.postconf
	fi
fi
End_Message
}

End_Message () {
if [ "$USBON" != "1" ]; then
	if [ "$lang" = "zh" ]; then
		printf '___________________________________________________________________\n'
		printf '已经开启USB加速器！\n'
		printf '如果你需要管理USB加速器，则在SSH中输入下方代码\n'
		printf '%b/jffs/scripts/usbaccelerator.sh%b\n' "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
		printf '___________________________________________________________________\n'
	else
		printf '___________________________________________________________________\n'
		printf 'The USB Accelerator is enabled!\n'
		printf 'If you want to set the USB Accelerator, Please enter the code below\n'
		printf '%b/jffs/scripts/usbaccelerator.sh%b\n' "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
		printf '___________________________________________________________________\n'
	fi
else
	if [ "$lang" = "zh" ]; then
		printf '___________________________________________________________________\n'
		printf '已经开启USB加速器！\n'
		printf '你可能需要重新启动才能达到最佳速度。\n'
		printf '如果你需要管理USB加速器，则在SSH中输入下方代码\n'
		printf '%b/jffs/scripts/usbaccelerator.sh%b\n' "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
		printf '___________________________________________________________________\n'
	else
		printf '___________________________________________________________________\n'
		printf 'The USB Accelerator is enabled!\n'
		printf 'For get the best speed, you may need to reboot the router.\n'
		printf 'If you want to set the USB Accelerator, Please enter the code below\n'
		printf '%b/jffs/scripts/usbaccelerator.sh%b\n' "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
		printf '___________________________________________________________________\n'
	fi
fi
}

Disable () {
rm -f $SPATH/smb.postconf 2>/dev/null
nvram set script_usbmount=""
nvram commit
service restart_nasapps
umount -f /www/images/New_ui/usbstatus.png 2>/dev/null
if [ "$lang" = "zh" ]; then
	printf '___________________________________________________________________\n'
	printf 'USB加速器已经关闭，如果未来需要再次开启，则在SSH里输入下方代码：\n'
	printf '%b/jffs/scripts/usbaccelerator.sh%b\n' "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
	printf '___________________________________________________________________\n'
else
	printf '___________________________________________________________________\n'
	printf 'The USB Accelerator has been disabled, Enter the code below to enable it again\n'
	printf '%b/jffs/scripts/usbaccelerator.sh%b\n' "$COLOR_LIGHT_WHITE" "$COLOR_WHITE"
	printf '___________________________________________________________________\n'
fi
}

Reinstall () {
umount -f /www/images/New_ui/usbstatus.png 2>/dev/null
rm -f $SPATH/sfsmb 2>/dev/null
rm -f $SPATH/smb.postconf 2>/dev/null
rm -f $SPATH/usbstatus.png 2>/dev/null
rm -f $SPATH/usbaccelerator.sh 2>/dev/null
nvram set script_usbmount=""
nvram commit
service restart_nasapps
Download_files
if [ "$lang" = "zh" ]; then
	printf 'USB加速器已经重新安装。\n'
else
	printf 'The USB Accelerator has been re-install now.\n'
fi
$SPATH/usbaccelerator.sh
}

Remove () {
umount -f /www/images/New_ui/usbstatus.png 2>/dev/null
rm -f $SPATH/sfsmb 2>/dev/null
rm -f $SPATH/smb.postconf 2>/dev/null
rm -f $SPATH/usbstatus.png 2>/dev/null
nvram set script_usbmount=""
nvram commit
service restart_nasapps
if [ "$lang" = "zh" ]; then
	printf 'USB加速器已经完全卸载，所有的一切都恢复到了安装前的状态。\n'
else
	printf 'The USB Accelerator has been removed and everything changes before is restored to the default value.\n'
fi
rm -f $SPATH/usbaccelerator.sh 2>/dev/null
}

Select_language