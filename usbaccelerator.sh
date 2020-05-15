#!/bin/sh

###################################################################
######                USB Accelerator by Jack                ######
######                      Version 2.0                      ######
######                                                       ######
######     https://github.com/JackMerlin/USBAccelerator      ######
######                                                       ######
###################################################################

PARM_1="$1"
PARM_2="$2"
PARM_3="$3"
export PATH="/sbin:/bin:/usr/sbin:/usr/bin:$PATH"
VERSION="2.0"
RELEASE_TYPE="stable"
S_DIR="/jffs/scripts"
ADD_DIR="/jffs/addons"
UA_DIR="$ADD_DIR/usbaccelerator"
CUR_DIR="$(cd `dirname $0`; pwd)"
S_NAME="$(basename $0)"
LANG="$(awk -F'"' '/^LANG=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)"
[ -z "$LANG" ] && LANG="$(nvram get preferred_lang 2>/dev/null)" || LANG="$LANG"
[ -z "$(nvram get odmpid 2>/dev/null)" ] && R_M="$(nvram get productid 2>/dev/null)" || R_M="$(nvram get odmpid 2>/dev/null)"
FWVER="$(nvram get buildno 2>/dev/null)"
TIMESTAMP="$(date +%F)"
FIRST_TIME="$(awk -F'"' '/^FIRST_TIME=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)"
SRC_1="https://raw.githubusercontent.com/JackMerlin/USBAccelerator/master"
SRC_2="https://gitlab.com/JackMerlin/USBAccelerator/raw/master"
HOST_HOME_1="https://github.com/JackMerlin/USBAccelerator"
HOST_HOME_2="https://gitlab.com/JackMerlin/USBAccelerator"
SC_GLOBAL="0"
FORCE="0"
QUIET="0"
C_LW='\033[1;37m'
C_LB='\033[1;30m'
C_G='\033[0;32m'
C_LG='\033[1;32m'
C_Y='\033[0;33m'
C_LY='\033[1;33m'
C_R='\033[0;31m'
C_LR='\033[1;31m'
C_C='\033[0;36m'
C_LC='\033[1;36m'
C_RS='\033[0m'

Home() {
if [ -n "$(awk -F'"' '/^UPDATE_COMPLETED=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" ]; then
	Whats_New
	sed -i '/UPDATE_COMPLETED/d' "$UA_DIR/CONFIG" 2>/dev/null
fi

if [ -z "$(awk -F'"' '/^ENABLE_STATUS=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" ]; then
	Check_Firmware
	Check_Model
fi

if [ "$FWTYPE" = "384M" ] && [ "$HND_MODEL" = "1" ] && [ "$(awk -F'"' '/^IGNORED_CKFWHW=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" != "1" ]; then
	printf '___________________________________________________________________\n'
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf '你所使用的硬件和固件已经具备较好的性能，继续使用可能无法打破瓶颈\n'
		printf '%b是否继续安装我呢？%b\n' "$C_Y" "$C_RS"
		printf '  %by%b  =  继续安装\n' "$C_LG" "$C_RS"
		printf '  %bn%b  =  卸载并退出\n' "$C_LG" "$C_RS"
	else
		printf 'Look at that, your firmware has many nice settings, and your router\n'
		printf 'has a very powerful CPU. If you choose to install the speed may not\n'
		printf 'be as expected.\n'
		printf '%bDo you still want to install me?%b\n' "$C_Y" "$C_RS"
		printf '  %by%b  =  Continue to install\n' "$C_LG" "$C_RS"
		printf '  %bn%b  =  Uninstall and exit\n' "$C_LG" "$C_RS"
	fi
	printf '___________________________________________________________________'
	egg="0"
	while true; do
		if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
			printf '\n该怎么做呢？\n'
		else
			printf '\nWhat do you want to do?\n'
		fi
		read -r "home_menu0"
		case "$home_menu0" in
			y|Y)
				Check_Directories
				sed -i '/IGNORED_CKFWHW/d' "$UA_DIR/CONFIG" 2>/dev/null
				echo '' >> "$UA_DIR/CONFIG"
				echo 'IGNORED_CKFWHW="1"' >> "$UA_DIR/CONFIG"
				sed -i '/^$/d' "$UA_DIR/CONFIG"
				chmod 644 $UA_DIR/CONFIG
				break
			;;
			n|N)
				UNINSTALL_RETURN="2"
				SC_GLOBAL="3"
				Uninstall_Confirmation
				break
			;;
			*)
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
					printf '\n你输入的 "%b%b%b" 不正确，请再试一次\n' "$C_LG" "$home_menu0" "$C_RS"
				else
					printf '\n"%b%b%b" is incorrect, please try again\n' "$C_LG" "$home_menu0" "$C_RS"
				fi
				egg="$((egg + 1))" && if [ "$egg" -gt "3" ]; then I_LOVE_YOU; break; fi
			;;
		esac
	done
fi

if [ ! -f $UA_DIR/usbaccelerator.sh ] || [ ! -f $UA_DIR/usbstatus.png ]; then
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf '正在准备为你下载文件，请稍等...\n'
	else
		printf 'Please wait while the download is starting...\n'
	fi
	TRIG_CKNT_BY_USER="1"
	Check_Files
	if [ "$SC_CKFILES" -eq "1" ]; then
		if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
			printf '文件下载完成，正在重新载入...\n'
		else
			printf 'Download successful, reloading...\n'
		fi
		sh $UA_DIR/usbaccelerator.sh; SC_GLOBAL="$?"; rm -f /tmp/usbaccelerator.sh; exit "$SC_GLOBAL"
	fi
	if [ "$SC_CKFILES" -gt "1" ] && [ "$DONT_DL" != "1" ]; then
		Download_Files_UI
		if [ "$SC_DOWNLOAD" = "0" ] && [ -f $UA_DIR/usbaccelerator.sh ] && [ -f $UA_DIR/usbstatus.png ]; then
			sh $UA_DIR/usbaccelerator.sh; SC_GLOBAL="$?"; rm -f /tmp/usbaccelerator.sh; exit "$SC_GLOBAL"
		else
			if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
				printf '%b注意%b:所需文件未找到，无法顺利开启，建议手动重新安装\n' "$C_LR" "$C_RS"
			else
				printf '%bWARNING%b: Missing files, please reinstall\n' "$C_LR" "$C_RS"
			fi
		fi
	else
		if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
			printf '%b注意%b:所需文件未找到，无法顺利开启，建议手动重新安装\n' "$C_LR" "$C_RS"
		else
			printf '%bWARNING%b: Missing files, please reinstall\n' "$C_LR" "$C_RS"
		fi
	fi
fi

printf '___________________________________________________________________\n'
if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
	printf '%b欢迎来到USB加速器v%b的控制面板，\n你可以输入对应的内容进行相关的操作%b\n' "$C_Y" "$VERSION" "$C_RS"
	if [ "$(awk -F'"' '/^ENABLE_STATUS=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" != "1" ]; then
		printf '\n  %b1%b  =  开启\n' "$C_LG" "$C_RS"
		printf '  %b2  =  关闭%b\n' "$C_LB" "$C_RS"
	else
		printf '\n  %b1  =  开启%b\n' "$C_LB" "$C_RS"
		printf '  %b2%b  =  关闭\n' "$C_LG" "$C_RS"
	fi
	printf '\n  %b3%b  =  下载和更新\n' "$C_LG" "$C_RS"
	printf '  %b4%b  =  其他设置\n' "$C_LG" "$C_RS"
	printf '  %b5%b  =  查看文档\n' "$C_LG" "$C_RS"
	printf '\n  %b8%b  =  重新安装\n' "$C_LG" "$C_RS"
	printf '  %b9%b  =  卸载\n' "$C_LG" "$C_RS"
	printf '\n  %be%b  =  退出控制面板\n' "$C_LG" "$C_RS"
else
	printf '%bWelcome, here is the control panel of USB Accelerator v%b%b\n' "$C_Y" "$VERSION" "$C_RS"
	if [ "$(awk -F'"' '/^ENABLE_STATUS=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" != "1" ]; then
		printf '\n  %b1%b  =  Enable\n' "$C_LG" "$C_RS"
		printf '  %b2  =  Disable%b\n' "$C_LB" "$C_RS"
	else
		printf '\n  %b1  =  Enable%b\n' "$C_LB" "$C_RS"
		printf '  %b2%b  =  Disable\n' "$C_LG" "$C_RS"
	fi
	printf '\n  %b3%b  =  Download and Update\n' "$C_LG" "$C_RS"
	printf '  %b4%b  =  Other Settings\n' "$C_LG" "$C_RS"
	printf '  %b5%b  =  Read Documents\n' "$C_LG" "$C_RS"
	printf '\n  %b8%b  =  Re-install\n' "$C_LG" "$C_RS"
	printf '  %b9%b  =  Uninstall\n' "$C_LG" "$C_RS"
	printf '\n  %be%b  =  Exit\n' "$C_LG" "$C_RS"
fi
printf '___________________________________________________________________'
egg="0"
e_r_r="0"
while true; do
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf '\n请输入\n'
	else
		printf '\nPlease enter\n'
	fi
	read -r "home_menu1"
	case "$home_menu1" in
		1)Enable_UI; break
		;;
		2)
			if [ "$(awk -F'"' '/^ENABLE_STATUS=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" != "0" ]; then
				Disable_UI; break
			else
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then printf '已禁用，无须重复禁用\n'; else printf 'Disabled, no need to disable again\n'; fi
			fi
		;;
		3)Update_Options_UI; break
		;;
		4)Other_Settings_UI; break
		;;
		5)Read_Documents_UI; break
		;;
		8)Reinstall_Confirmation; break
		;;
		9)Uninstall_Confirmation; break
		;;
		e|E)exit "$SC_GLOBAL"; break
		;;
		0)
			e_r_r="$((e_r_r + 1))"
			if [ "$e_r_r" -ge "3" ]; then
				Error_344; break
			else
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
					printf '你输入的好像不对呀，要再试一次吗？\n'
				else
					printf 'You may have entered the wrong number.\nHow about trying again?\n'
				fi
			fi
		;;
		*)
			if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
				printf '\n你输入的 "%b%b%b" 不正确嘛，再试一次喽\n' "$C_LG" "$home_menu1" "$C_RS"
			else
				printf '\nUhhh...it looks like "%b%b%b" you entered is wrong.\n' "$C_LG" "$home_menu1" "$C_RS"
			fi
			egg="$((egg + 1))" && if [ "$egg" -gt "3" ]; then I_LOVE_YOU; break; fi
		;;
	esac
done
}

Enable_UI() {
if [ -n "$(nvram get usb_usb3 2>/dev/null)" ] && [ "$(nvram get usb_usb3)" != "1" ] && [ "$(awk -F'"' '/^USB_MODE=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" != "2_0" ]; then
	Change_USB_Mode_UI
fi
SC_ENABLE=""

printf '___________________________________________________________________\n'
if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
	printf '%b提示: 在开启USB加速器过程中请暂停对USB设备的任何读写操作%b\n' "$C_LW" "$C_RS"
	printf '  %b1%b  =  继续开启\n' "$C_LG" "$C_RS"
	printf '  %b0%b  =  返回\n' "$C_LG" "$C_RS"
else
	printf '%bNOTE: Please suspend any read and write access to\nUSB device(s) before the enabling is complete.%b\n' "$C_LW" "$C_RS"
	printf '  %b1%b  =  Enable\n' "$C_LG" "$C_RS"
	printf '  %b0%b  =  Return to Control Panel\n' "$C_LG" "$C_RS"
fi
printf '___________________________________________________________________'
egg="0"
while true; do
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf '\n准备好了吗？\n'
	else
		printf '\nEnter to continue\n'
	fi
	read -r "enable_ui_menu0"
	case "$enable_ui_menu0" in
		1)if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then printf '正在开启请稍等...\n'; else printf 'Please wait...\n'; fi; Enable
		break
		;;
		0)Home; break
		;;
		e|E)exit "$SC_GLOBAL"; break
		;;
		*)
			if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
				printf '\n你输入的 "%b%b%b" 好像不正确嘛，再试一次哦\n' "$C_LG" "$enable_ui_menu0" "$C_RS"
			else
				printf '\n"%b%b%b" is incorrect, please try again.\n' "$C_LG" "$enable_ui_menu0" "$C_RS"
			fi
			egg="$((egg + 1))" && if [ "$egg" -gt "3" ]; then I_LOVE_YOU; break; fi
		;;
	esac
done

if [ "$SC_ENABLE" -eq "0" ]; then
	printf '___________________________________________________________________\n'
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf '%bUSB加速器已经成功开启%b(状态码:%b)\n' "$C_LC" "$C_RS" "$SC_ENABLE"
		if [ "$ENABLE_JFFS_SCRIPTS" = "1" ]; then
			printf '为现实正常运行已开启JFFS自定义脚本和配置\n'
		fi
		if [ "$SC_USBMODE" = "2" ]; then
			printf '路由器需重新启动才能获得应用某些设置\n'
		fi
		printf '\n%b是否进行安全设置以提高路由器的安全性？%b\n' "$C_Y" "$C_RS"
		printf '  %b1%b  =  进行设置\n' "$C_LG" "$C_RS"
		printf '  %b0%b  =  返回\n' "$C_LG" "$C_RS"
		printf '  %be%b  =  退出\n' "$C_LG" "$C_RS"
	else
		printf '%bUSB Accelerator has been successfully enabled.%b\n(Status Code:%b)\n' "$C_LC" "$C_RS" "$SC_ENABLE"
		if [ "$ENABLE_JFFS_SCRIPTS" = "1" ]; then
			printf 'I enabled JFFS custom scripts and configs to run USB Accelerator\n'
		fi
		if [ "$SC_USBMODE" = "2" ]; then
			printf 'For get the best speed, please reboot your router later\n'
		fi
		printf '\n%bDo you want to check the unsafe settings of your router?%b\n' "$C_Y" "$C_RS"
		printf '  %b1%b  =  Go to Check\n' "$C_LG" "$C_RS"
		printf '  %b0%b  =  Return to Control Panel\n' "$C_LG" "$C_RS"
		printf '  %be%b  =  Exit\n' "$C_LG" "$C_RS"
	fi
	printf '___________________________________________________________________'
	egg="0"
	while true; do
		if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
			printf '\n请输入\n'
		else
			printf '\nPlease enter\n'
		fi
		read -r "enable_ui_menu1"
		case "$enable_ui_menu1" in
			1)Check_Security_UI; Home; break
			;;
			0)Home; break
			;;
			e|E)exit "$SC_GLOBAL"; break
			;;
			*)
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
					printf '\n你输入的 "%b%b%b" 好像不正确嘛，再试一次哦\n' "$C_LG" "$enable_ui_menu1" "$C_RS"
				else
					printf '\n"%b%b%b" is incorrect, do you mind trying again?\n' "$C_LG" "$enable_ui_menu1" "$C_RS"
				fi
				egg="$((egg + 1))" && if [ "$egg" -gt "3" ]; then I_LOVE_YOU; break; fi
			;;
		esac
	done
fi

if [ "$SC_ENABLE" -eq "100" ]; then
	printf '___________________________________________________________________\n'
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf 'USB加速器已开启了，无需重复启用(状态码:%b)\n' "$SC_ENABLE"
	else
		printf 'the USB Accelerator has been enabled, no need to enable again\n(Status Code:%b)\n' "$SC_ENABLE"
	fi
	printf '___________________________________________________________________\n'
	Home
fi

if [ "$SC_ENABLE" -eq "1000" ]; then
	printf '___________________________________________________________________\n'
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf 'USB加速器可能不支持你的固件(状态码:%b)\n' "$SC_ENABLE"
	else
		printf 'Failed to enable USB Accelerator, may not support your firmware\n(Status Code:%b)\n' "$SC_ENABLE"
	fi
	printf '___________________________________________________________________\n'
	Home
fi

if [ "$SC_ENABLE" -gt "0" ] && [ "$SC_ENABLE" -lt "100" ]; then
	printf '___________________________________________________________________\n'
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf 'USB加速器%b开启失败%b :(\n' "$C_LR" "$C_RS"
		printf '  %b1%b  =  再试一次\n' "$C_LG" "$C_RS"
		printf '  %b0%b  =  返回\n' "$C_LG" "$C_RS"
		printf '  %be%b  =  退出\n' "$C_LG" "$C_RS"
	else
		printf '%bFailed to enable USB Accelerator%b :(\n' "$C_LR" "$C_RS"
		printf '  %b1%b  =  Try again\n' "$C_LG" "$C_RS"
		printf '  %b0%b  =  Return to Control Panel\n' "$C_LG" "$C_RS"
		printf '  %be%b  =  Exit\n' "$C_LG" "$C_RS"
	fi
	printf '___________________________________________________________________'
	egg="0"
	while true; do
		if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
			printf '\n请输入\n'
		else
			printf '\nPlease enter\n'
		fi
		read -r "enable_ui_menu2"
		case "$enable_ui_menu2" in
			1)Enable_UI; break
			;;
			0)Home; break
			;;
			e|E)exit "$SC_GLOBAL"; break
			;;
			*)
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
					printf '\n你输入的 "%b%b%b" 好像不正确嘛，再试一次哦\n' "$C_LG" "$enable_ui_menu2" "$C_RS"
				else
					printf '\n"%b%b%b" is incorrect, please try again.\n' "$C_LG" "$enable_ui_menu2" "$C_RS"
				fi
				egg="$((egg + 1))" && if [ "$egg" -gt "3" ]; then I_LOVE_YOU; break; fi
			;;
		esac
	done
fi
}

Disable_UI() {
SC_DISABLE=""

printf '___________________________________________________________________\n'
if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
	printf '%b提示: 在关闭USB加速器过程中请暂停对USB设备的任何读写操作%b\n' "$C_LW" "$C_RS"
	printf '  %b1%b  =  继续关闭\n' "$C_LG" "$C_RS"
	printf '  %b0%b  =  返回\n' "$C_LG" "$C_RS"
else
	printf '%bNOTE: Please suspend any read and write access to\nUSB device(s) before the disabling is complete.%b\n' "$C_LW" "$C_RS"
	printf '  %b1%b  =  Disable\n' "$C_LG" "$C_RS"
	printf '  %b0%b  =  Return to Control Panel\n' "$C_LG" "$C_RS"
fi
printf '___________________________________________________________________'
egg="0"
while true; do
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf '\n准备好了吗？\n'
	else
		printf '\nEnter to continue\n'
	fi
	read -r "disable_ui_menu0"
	case "$disable_ui_menu0" in
		1)if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then printf '正在关闭请稍等...\n'; else printf 'Please wait...\n'; fi; Disable
		break
		;;
		0)Home; break
		;;
		e|E)exit "$SC_GLOBAL"; break
		;;
		*)
			if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
				printf '\n你输入的 "%b%b%b" 好像不正确嘛，再试一次哦\n' "$C_LG" "$disable_ui_menu0" "$C_RS"
			else
				printf '\n"%b%b%b" is incorrect, please try again.\n' "$C_LG" "$disable_ui_menu0" "$C_RS"
			fi
			egg="$((egg + 1))" && if [ "$egg" -gt "3" ]; then I_LOVE_YOU; break; fi
		;;
	esac
done

if [ "$SC_DISABLE" -eq "0" ] || [ "$SC_DISABLE" -eq "100" ]; then
	printf '___________________________________________________________________\n'
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf 'USB加速器%b关闭成功%b (状态码:%b)\n' "$C_LC" "$C_RS" "$SC_DISABLE"
	else
		printf 'the USB Accelerator %bsuccessfully disabled%b\n(Status Code:%b)\n' "$C_LC" "$C_RS" "$SC_DISABLE"
	fi
	printf '___________________________________________________________________\n'
	Home
else
	printf '___________________________________________________________________\n'
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf 'USB加速器%b关闭失败%b (状态码:%b)\n' "$C_LR" "$C_RS" "$SC_DISABLE"
	else
		printf 'the USB Accelerator %bdisable failed%b\n(Status Code:%b)\n' "$C_LR" "$C_RS" "$SC_DISABLE"
	fi
	printf '___________________________________________________________________\n'
	if [ -n "$SC_DISABLE" ]; then Home; fi
fi
}

Reinstall_Confirmation() {
printf '___________________________________________________________________\n'
if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
	printf '%b你确定要重新安装吗？%b\n' "$C_Y" "$C_RS"
	printf '提示:重新安装应仅用于排错，如果需升级请使用更新功能\n'
	printf '\n  %by%b  =  确定重新安装\n' "$C_LG" "$C_RS"
	printf '  %bn%b  =  不进行重新安装\n' "$C_LG" "$C_RS"
else
	printf '%bAre you sure you want to Re-install?%b\n' "$C_Y" "$C_RS"
	printf 'NOTE: Re-install should only be used to try to solve issue.\nIf you want to update, should use the update function.\n'
	printf '\n  %by%b  =  Yes\n' "$C_LG" "$C_RS"
	printf '  %bn%b  =  No\n' "$C_LG" "$C_RS"
fi
printf '___________________________________________________________________'
egg="0"
while true; do
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf '\n请输入\n'
	else
		printf '\nPlease Enter\n'
	fi
	read -r "reinstall_menu0"
	case "$reinstall_menu0" in
		y|Y)CONFIRM_REINSTALL="1"; break
		;;
		n|N)CONFIRM_REINSTALL="0"; Home; break
		;;
		e|E)exit "$SC_GLOBAL"; break
		;;
		*)
			if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
				printf '\n你输入的 "%b%b%b" 好像不正确嘛，再试一次吧\n' "$C_LG" "$reinstall_menu0" "$C_RS"
			else
				printf '\n"%b%b%b" is incorrect, try again?\n' "$C_LG" "$reinstall_menu0" "$C_RS"
			fi
			egg="$((egg + 1))" && if [ "$egg" -gt "3" ]; then I_LOVE_YOU; break; fi
		;;
	esac
done

if [ "$CONFIRM_REINSTALL" = "1" ]; then
	printf '___________________________________________________________________\n'
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf '%b要保留配置吗？%b\n' "$C_Y" "$C_RS"
		printf '\n  %b1%b  =  保留配置\n' "$C_LG" "$C_RS"
		printf '  %b2%b  =  不保留配置\n' "$C_LG" "$C_RS"
		printf '  %b0%b  =  返回\n' "$C_LG" "$C_RS"
	else
		printf '%bDo you want to keep configuration?%b\n' "$C_Y" "$C_RS"
		printf '\n  %b1%b  =  Keep\n' "$C_LG" "$C_RS"
		printf '  %b2%b  =  Don%st keep\n' "$C_LG" "$C_RS" "'"
		printf '  %b0%b  =  Return to Control Panel\n' "$C_LG" "$C_RS"
	fi
	printf '___________________________________________________________________'
	egg="0"
	while true; do
		if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
			printf '\n请输入\n'
		else
			printf '\nPlease Enter\n'
		fi
		read -r "reinstall_menu1"
		case "$reinstall_menu1" in
			1)
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
					printf '请稍等，成功后将重新载入...\n'
				else
					printf 'Please wait for a while, if successful will reload...\n'
				fi
				CLEAN_INSTALL="0";TRIG_CKNT_BY_USER="1"; TRIG_RI_BY_USER="1"; Reinstall
				if [ "$SC_REINSTALL" -gt "0" ] && [ "$SC_REINSTALL" -lt "100" ]; then
					if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
						printf '%b注意%b:USB加速器已卸载却无法重装，退出后请手动重新下载\n' "$C_LR" "$C_RS"
					else
						printf '%bWARNING%b: Files are missing, please reinstall manually\n' "$C_LR" "$C_RS"
					fi
					Home; break
				elif [ "$SC_REINSTALL" -gt "0" ]; then
					if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
						printf '重装失败\n'
					else
						printf 'Re-install failed\n'
					fi
					Home; break
				fi
			break
			;;
			2)
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
					printf '请稍等，成功后将重新载入...\n'
				else
					printf 'Please wait for a while, if successful will reload...\n'
				fi
				CLEAN_INSTALL="1";TRIG_CKNT_BY_USER="1"; TRIG_RI_BY_USER="1"; Reinstall
				if [ "$SC_REINSTALL" -gt "0" ] && [ "$SC_REINSTALL" -lt "100" ]; then
					if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
						printf '%b注意%b:USB加速器已卸载却无法重装，退出后请手动重新下载\n' "$C_LR" "$C_RS"
					else
						printf '%bWARNING%b: Files are missing, please reinstall manually\n' "$C_LR" "$C_RS"
					fi
					Home; break
				elif [ "$SC_REINSTALL" -gt "0" ]; then
					if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
						printf '重装失败\n'
					else
						printf 'Re-install failed\n'
					fi
					Home; break
				fi
			break
			;;
			0)Home; break
			;;
			e|E)exit "$SC_GLOBAL"; break
			;;
			*)
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
					printf '\n你输入的 "%b%b%b" 好像不正确嘛，再试一次吧\n' "$C_LG" "$reinstall_menu1" "$C_RS"
				else
					printf '\n"%b%b%b" is incorrect, try again?\n' "$C_LG" "$reinstall_menu1" "$C_RS"
				fi
				egg="$((egg + 1))" && if [ "$egg" -gt "3" ]; then I_LOVE_YOU; break; fi
			;;
		esac
	done
fi
}

Uninstall_Confirmation() {
printf '___________________________________________________________________\n'
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf '我不会卖萌装哭的，但是在上路前再问一句，你确定要卸载我吗？\n'
		printf '  %by%b  =  %b确定%b\n' "$C_LG" "$C_RS" "$C_LW" "$C_RS"
		printf '  %bn%b  =  %b不卸载%b\n' "$C_LG" "$C_RS" "$C_LW" "$C_RS"
	else
		printf 'Are you sure you want to uninstall me?\n'
		printf '  %by%b  =  %bYES%b\n' "$C_LG" "$C_RS" "$C_LW" "$C_RS"
		printf '  %bn%b  =  %bNO%b\n' "$C_LG" "$C_RS" "$C_LW" "$C_RS"
	fi
printf '___________________________________________________________________'
err="0"
while true; do
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf '\n请输入\n'
	else
		printf '\nPlease Enter\n'
	fi
	read -r "uninstall_menu"
	case "$uninstall_menu" in
		y|Y)
			Uninstall
			if [ "$SC_UNINSTALL" -eq "0" ]; then
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
					printf '已经成功卸载，感谢你的使用\n'
				else
					printf 'Uninstalled successfully\n'
				fi
			else
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
					printf '已经卸载，但可能有文件或目录被系统占用没有被删除\n'
				else
					printf 'USB Accelerator has been uninstalled,\nbut some files or directory may cannot be removed.\n'
				fi
			fi
			exit "$SC_GLOBAL"
			break
		;;
		n|N)
			if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
				printf '宝宝吓屎了，但是宝宝不说\n'
			else
				printf 'Are you kidding me? don%st scare me again!\n' "'"
			fi
			if [ -z "$UNINSTALL_RETURN" ] || [ "$UNINSTALL_RETURN" = "2" ]; then
				Home; break
			else
				Splash_Page_4; break
			fi
		;;
		e|E)exit "$SC_GLOBAL"; break
		;;
		*)
			if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
				printf '\n你输入的 "%b%b%b" 不正确，请再试一次，超过三次错误将返回\n' "$C_LG" "$uninstall_menu" "$C_RS"
			else
				printf '\n"%b%b%b" is incorrect, please try again.\nErrors entered more than three times will be returned\n' "$C_LG" "$uninstall_menu" "$C_RS"
			fi
			err="$((err + 1))" && if [ "$err" -gt "3" ]; then if [ -z "$UNINSTALL_RETURN" ] || [ "$UNINSTALL_RETURN" = "2" ]; then Home; break; else Splash_Page_4; break; fi; fi
		;;
	esac
done
}

Update_Options_UI() {
printf '___________________________________________________________________\n'
if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
	printf '%b下载和更新%b\n' "$C_Y" "$C_RS"
	printf '\n  %b1%b  =  设置下载来源\n' "$C_LG" "$C_RS"
	printf '  %b2%b  =  立即手动更新\n' "$C_LG" "$C_RS"
	if [ "$(awk -F'"' '/^AUTO_UPDATE=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" != "1" ]; then
		printf '  %b3%b  =  开启自动更新\n' "$C_LG" "$C_RS"
		printf '  %b4  =  关闭自动更新%b\n' "$C_LB" "$C_RS"
	else
		printf '  %b3  =  开启自动更新%b\n' "$C_LB" "$C_RS"
		printf '  %b4%b  =  关闭自动更新\n' "$C_LG" "$C_RS"
	fi
	if [ ! -f $UA_DIR/usbaccelerator.sh ] || [ ! -f $UA_DIR/usbstatus.png ]; then
		printf '  %b5%b  =  下载缺失的文件\n' "$C_LG" "$C_RS"
	fi
	printf '  %b0%b  =  返回\n' "$C_LG" "$C_RS"
else
	printf '%bDownload and Update%b\n' "$C_Y" "$C_RS"
	printf '\n  %b1%b  =  Set Download Source\n' "$C_LG" "$C_RS"
	printf '  %b2%b  =  Update Now\n' "$C_LG" "$C_RS"
	if [ "$(awk -F'"' '/^AUTO_UPDATE=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" != "1" ]; then
		printf '  %b3%b  =  Enable Auto-update\n' "$C_LG" "$C_RS"
		printf '  %b4  =  Disable Auto-update%b\n' "$C_LB" "$C_RS"
	else
		printf '  %b3  =  Enable Auto-update%b\n' "$C_LB" "$C_RS"
		printf '  %b4%b  =  Disable Auto-update\n' "$C_LG" "$C_RS"
	fi
	if [ ! -f $UA_DIR/usbaccelerator.sh ] || [ ! -f $UA_DIR/usbstatus.png ]; then
		printf '  %b5%b  =  Download Missing File(s)\n' "$C_LG" "$C_RS"
	fi
	printf '  %b0%b  =  Return to Control Panel\n' "$C_LG" "$C_RS"
fi
printf '___________________________________________________________________'
egg="0"
while true; do
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf '\n请输入\n'
	else
		printf '\nPlease enter\n'
	fi
	read -r "up_opts_menu"
	case "$up_opts_menu" in
		1)Set_Source_UI; Update_Options_UI; break
		;;
		2)Update_UI; Update_Options_UI; break
		;;
		3)
			if [ "$(awk -F'"' '/^AUTO_UPDATE=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" != "1" ]; then
				Enable_Auto_Update
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
					printf '设置好了\n'
				else
					printf 'Setup is complete\n'
				fi
				if [ "$(awk -F'"' '/^AUTO_UPDATE_BY_USER=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" != "1" ]; then
					sed -i '/AUTO_UPDATE_BY_USER/d' "$UA_DIR/CONFIG" 2>/dev/null
					echo '' >> "$UA_DIR/CONFIG"
					echo 'AUTO_UPDATE_BY_USER="1"' >> "$UA_DIR/CONFIG"
					sed -i '/^$/d' "$UA_DIR/CONFIG"
					chmod 644 $UA_DIR/CONFIG
				fi
				Update_Options_UI; break
			else
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
					printf '自动更新已经开启，无须操作\n'
				else
					printf 'Auto-update is enabled\n'
				fi
			fi
		;;
		4)
			if [ "$(awk -F'"' '/^AUTO_UPDATE=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" = "1" ]; then
				Disable_Auto_Update
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
					printf '设置好了\n'
				else
					printf 'Setup is complete\n'
				fi
				Update_Options_UI; break
			else
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
					printf '尚未开启自动更新，无须操作\n'
				else
					printf 'Auto-update is not been enabled\n'
				fi
			fi
		;;
		5)
			if [ ! -f $UA_DIR/usbaccelerator.sh ] || [ ! -f $UA_DIR/usbstatus.png ]; then
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
					printf '正在准备为你下载文件，请稍等...\n'
				else
					printf 'Please wait while the download is starting...\n'
				fi
				Check_Files
				if [ "$SC_CKFILES" -gt "1" ]; then
					if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
						printf '%b注意%b:USB加速器已卸载却无法重装，退出后请手动重新下载\n' "$C_LR" "$C_RS"
					else
						printf '%bWARNING%b: Files are missing, please reinstall manually\n' "$C_LR" "$C_RS"
					fi
					break
				else
					if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
						printf '下载完成\n'
					else
						printf 'Download completed\n'
					fi
				fi
			else
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
					printf '无效操作\n'
				else
					printf 'Invalid\n'
				fi
			fi
		;;
		0)Home; break
		;;
		e|E)exit "$SC_GLOBAL"; break
		;;
		*)
			if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
				printf '\n你输入的 "%b%b%b" 好像不正确嘛，再试一次哦\n' "$C_LG" "$up_opts_menu" "$C_RS"
			else
				printf '\n"%b%b%b" is incorrect, please try again.\n' "$C_LG" "$up_opts_menu" "$C_RS"
			fi
			egg="$((egg + 1))" && if [ "$egg" -gt "3" ]; then I_LOVE_YOU; break; fi
		;;
	esac
done
}

Set_Source_UI() {
printf '___________________________________________________________________\n'
if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
	printf '%b你想从哪里下载我的躯体？%b\n' "$C_Y" "$C_RS"
	if [ -n "$(awk -F'"' '/^CFG_SRC=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" ]; then
		printf '当前下载来源是: %b\n\n' "$(awk -F'"' '/^CFG_SRC=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)"
	fi
	printf '  %b1%b  =  从章鱼喵 %bGitHub%b 那里\n' "$C_LG" "$C_RS" "$C_LW" "$C_RS"
	printf '  %b2%b  =  从貉狸汪 %bGitLab%b 那里\n' "$C_LG" "$C_RS" "$C_LW" "$C_RS"
	if [ "$NO_RETURN_SETSRC" != "1" ]; then
		printf '  %b0%b  =  返回\n' "$C_LG" "$C_RS"
	fi
	setsrc_finish="设置好啦"
	setsrc_error_1="你输入的"
	setsrc_error_2="好像不正确嘛，再试一次哦"
else
	printf '%bWhere do you want to download me?%b\n' "$C_Y" "$C_RS"
	if [ -n "$(awk -F'"' '/^CFG_SRC=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" ]; then
		printf 'Download Source now is: %b\n' "$(awk -F'"' '/^CFG_SRC=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)"
	fi
	printf '  %b1%b  =  from %bGitHub%b\n' "$C_LG" "$C_RS" "$C_LW" "$C_RS"
	printf '  %b2%b  =  from %bGitLab%b\n' "$C_LG" "$C_RS" "$C_LW" "$C_RS"
	if [ "$NO_RETURN_SETSRC" != "1" ]; then
		printf '  %b0%b  =  Return to Control Panel\n' "$C_LG" "$C_RS"
	fi
	setsrc_finish="Set it up!"
	setsrc_error_1="Sorry, I can not understand the"
	setsrc_error_2="you entered,\ndo you want to try again?"
fi
printf '___________________________________________________________________'
egg="0"
while true; do
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf '\n请输入吧！\n'
	else
		printf '\nPlease enter\n'
	fi
	read -r "setsrc_ui_menu"
	case "$setsrc_ui_menu" in
		1)Source_GitHub; NO_RETURN_SETSRC="0"; printf '%b\n' "$setsrc_finish"; break
		;;
		2)Source_GitLab; NO_RETURN_SETSRC="0"; printf '%b\n' "$setsrc_finish"; break
		;;
		0)
			if [ "$NO_RETURN_SETSRC" != "1" ]; then
				NO_RETURN_SETSRC="0"; Home; break
			else
				printf '\n%b "%b%b%b" %b\n' "$setsrc_error_1" "$C_LG" "$setsrc_ui_menu" "$C_RS" "$setsrc_error_2"
			fi
		;;
		e|E)exit "$SC_GLOBAL"; break
		;;
		*)
		printf '\n%b "%b%b%b" %b\n' "$setsrc_error_1" "$C_LG" "$setsrc_ui_menu" "$C_RS" "$setsrc_error_2"
			egg="$((egg + 1))" && if [ "$egg" -gt "3" ]; then I_LOVE_YOU; break; fi
		;;
	esac
done
}

Update_UI() {
printf '___________________________________________________________________\n'
if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
	printf '正在检查更新，若有更新将下载，请稍等...\n'
else
	printf 'Checking and updates, please wait...\n'
fi

TRIG_UPD_BY_USER="1"
Update

if [ "$SC_UPDATE" -eq "0" ]; then
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf '检查完成，尚无可用更新\n'
		printf '\n  %b回车键%b  =  返回\n' "$C_LG" "$C_RS"
	else
		printf 'No updates available yet, please check back later.\n'
		printf '\n  %bPress Enter key%b  =  Return to Previous Page\n' "$C_LG" "$C_RS"
	fi
	printf '___________________________________________________________________\n'
	read -r "upd_menu0"
	case "$upd_menu0" in
		*)
			TRIG_UPD_BY_USER="0"
		;;
	esac
fi

if [ "$SC_UPDATE" -eq "1" ]; then
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf '%b更新成功%b，已经由v%b更新至v%b\n' "$C_LC" "$C_RS" "$VERSION" "$NEW_VERSION"
		printf '\n  %b回车键%b  =  载入新版\n' "$C_LG" "$C_RS"
	else
		printf '%bSuccessfully updated%b, from v%b to v%b\n' "$C_LC" "$C_RS" "$VERSION" "$NEW_VERSION"
		printf '\n  %bPress Enter key%b  =  Refresh to New Version\n' "$C_LG" "$C_RS"
	fi
	printf '___________________________________________________________________\n'
	read -r "upd_menu1"
	case "$upd_menu1" in
		*)
			sh $UA_DIR/usbaccelerator.sh; exit "$?"
		;;
	esac
fi

if [ "$SC_UPDATE" -eq "2" ]; then
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf '%b更新错误%b，请检查网络连接和路由器时间设置\n' "$C_LR" "$C_RS"
		printf '\n  %b回车键%b  =  返回\n' "$C_LG" "$C_RS"
	else
		printf '%bUpdate failed%b, Please check network connection and router time.\n' "$C_LR" "$C_RS"
		printf '\n  %bPress Enter key%b  =  Return to Previous Page\n' "$C_LG" "$C_RS"
	fi
	printf '___________________________________________________________________\n'
	read -r "upd_menu2"
	case "$upd_menu2" in
		*)
			TRIG_UPD_BY_USER="0"
		;;
	esac
fi

if [ "$SC_UPDATE" -eq "3" ]; then
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf '%b更新错误%b，下载失败\n' "$C_LR" "$C_RS"
		printf '\n  %b回车键%b  =  返回\n' "$C_LG" "$C_RS"
	else
		printf '%bUpdate failed%b, File cannot be downloaded\n' "$C_LR" "$C_RS"
		printf '\n  %bPress Enter key%b  =  Return to Previous Page\n' "$C_LG" "$C_RS"
	fi
	printf '___________________________________________________________________\n'
	read -r "upd_menu3"
	case "$upd_menu3" in
		*)
			TRIG_UPD_BY_USER="0"
		;;
	esac
fi

if [ "$SC_UPDATE" -eq "4" ]; then
	Check_Files
	if [ "$SC_CKFILES" -gt "1" ]; then
		if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
			printf '%b文件丢失%b，请重新安装USB加速器\n' "$C_LR" "$C_RS"
			printf '\n  %b回车键%b  =  返回\n' "$C_LG" "$C_RS"
		else
			printf '%bFile is missing%b, please return to the previous page\nto download missing file(s)\n' "$C_LR" "$C_RS"
			printf '\n  %bPress Enter key%b  =  Return to Previous Page\n' "$C_LG" "$C_RS"
		fi
		printf '___________________________________________________________________\n'
		read -r "upd_menu4"
		case "$upd_menu4" in
			*)
				TRIG_UPD_BY_USER="0"
			;;
		esac
	else
		SC_UPDATE=""
	fi
fi

if [ -z "$SC_UPDATE" ]; then
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf '%b未知错误%b，暂时无法更新\n' "$C_LR" "$C_RS"
		printf '\n  %b回车键%b  =  返回\n' "$C_LG" "$C_RS"
	else
		printf '%bUnknown error%b, please try again later\n' "$C_LR" "$C_RS"
		printf '\n  %bPress Enter key%b  =  Return to Previous Page\n' "$C_LG" "$C_RS"
	fi
	printf '___________________________________________________________________\n'
	read -r "upd_menu5"
	case "$upd_menu5" in
		*)
			TRIG_UPD_BY_USER="0"
		;;
	esac
fi
}

Download_Files_UI() {
if [ -n "$SC_NETWORK" ] && [ "$SC_NETWORK" -gt "0" ]; then
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf '下载失败，请检查网络连接和路由器时间设置\n'
	else
		printf 'Download failed. Please check network connection and router time.\n'
	fi
fi

if [ -n "$SC_DOWNLOAD" ] && [ "$SC_DOWNLOAD" -gt "0" ]; then
	printf '___________________________________________________________________\n'
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf '%b下载文件好像失败了呀，要不要再试一次呢？%b\n' "$C_Y" "$C_RS"
		if [ "$SC_DOWNLOAD" -gt "99" ]; then
			printf '你的固件不支持从GitLab下载，请切换到GitHub\n'
		fi
		printf '  %b1%b  =  再试一次\n' "$C_LG" "$C_RS"
		printf '  %b2%b  =  切换安装来源再下载\n' "$C_LG" "$C_RS"
		if [ "$DLUI_NOTRY" = "1" ]; then
			printf '  %b0%b  =  不试了\n' "$C_LG" "$C_RS"
		fi
	else
		printf 'Uhhh...looks like the download failed.\n%bDo you want to try again?%b\n' "$C_Y" "$C_RS"
		if [ "$SC_DOWNLOAD" -gt "99" ]; then
			printf 'Your firmware cannot be downloaded from GitLab, please use GitHub\n'
		fi
		printf '  %b1%b  =  Try again\n' "$C_LG" "$C_RS"
		printf '  %b2%b  =  Change Source and Download\n' "$C_LG" "$C_RS"
		if [ "$DLUI_NOTRY" = "1" ]; then
			printf '  %b0%b  =  No\n' "$C_LG" "$C_RS"
		fi
	fi
	printf '___________________________________________________________________'
	egg="0"
	while true; do
		if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
			printf '\n该怎么做呢？\n'
		else
			printf '\nWhat do you want to do?\n'
		fi
		read -r "dl_ui_menu"
		case "$dl_ui_menu" in
			1)
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
					printf '正在准备为你下载文件，请稍等...\n'
				else
					printf 'Please wait while the download is starting...\n'
				fi
				DLUI_NOTRY="1"
				Download_Files
				if [ "$SC_DOWNLOAD" -eq "0" ]; then
					if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
						printf '文件下载好了\n'
					else
						printf 'Download successful!\n'
					fi
					Move_Files; break
				else
					Download_Files_UI; break
				fi
			;;
			2)
				DLUI_NOTRY="1"
				Set_Source_UI
				Download_Files
				if [ "$SC_DOWNLOAD" -eq "0" ]; then
					if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
						printf '文件下载好了\n'
					else
						printf 'Download successful!\n'
					fi
					Move_Files; break
				else
					Download_Files_UI; break
				fi
			;;
			0)DONT_DL="1"; break
			;;
			e|E)exit "$SC_GLOBAL"; break
			;;
			*)
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
					printf '\n你输入的 "%b%b%b" 好像不正确嘛，再试一次喽\n' "$C_LG" "$dl_ui_menu" "$C_RS"
				else
					printf '\nUhhh...it looks like "%b%b%b" you entered is wrong.\n' "$C_LG" "$dl_ui_menu" "$C_RS"
				fi
				egg="$((egg + 1))" && if [ "$egg" -gt "3" ]; then I_LOVE_YOU; break; fi
			;;
		esac
	done
fi
}

Other_Settings_UI() {
printf '___________________________________________________________________\n'
if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
	printf '%b其他设置%b\n' "$C_Y" "$C_RS"
	printf '\n  %b1%b  =  语言设置 (文/A)\n' "$C_LG" "$C_RS"
	printf '  %b2%b  =  USB模式设置\n' "$C_LG" "$C_RS"
	printf '  %b3%b  =  安全设置\n' "$C_LG" "$C_RS"
	printf '  %b0%b  =  返回\n' "$C_LG" "$C_RS"
else
	printf '%bOther Settings%b\n' "$C_Y" "$C_RS"
	printf '\n  %b1%b  =  Language Settings (文/A)\n' "$C_LG" "$C_RS"
	printf '  %b2%b  =  USB Mode Settings\n' "$C_LG" "$C_RS"
	printf '  %b3%b  =  Security Settings\n' "$C_LG" "$C_RS"
	printf '  %b0%b  =  Return to Control Panel\n' "$C_LG" "$C_RS"
fi
printf '___________________________________________________________________'
egg="0"
while true; do
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf '\n输入吧\n'
	else
		printf '\nPlease enter\n'
	fi
	read -r "osui_menu"
	case "$osui_menu" in
		1)Language_Settings_UI; Other_Settings_UI; break
		;;
		2)Change_USB_Mode_UI; Other_Settings_UI; break
		;;
		3)Check_Security_UI; Other_Settings_UI; break
		;;
		0)Home; break
		;;
		e|E)exit "$SC_GLOBAL"; break
		;;
		*)
			if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
				printf '\n你输入的 "%b%b%b" 好像不正确嘛，再试一次吧\n' "$C_LG" "$osui_menu" "$C_RS"
			else
				printf '\n"%b%b%b" is incorrect, try again?\n' "$C_LG" "$osui_menu" "$C_RS"
			fi
			egg="$((egg + 1))" && if [ "$egg" -gt "3" ]; then I_LOVE_YOU; break; fi
		;;
	esac
done
}

Language_Settings_UI() {
printf '___________________________________________________________________\n'
if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
	printf '%b语言设置 (文/A)%b\n' "$C_Y" "$C_RS"
	printf '想帮助翻译？你可以在GitHub上为项目做出你的贡献\n\n'
	if [ -z "$(awk -F'"' '/^LANG=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" ]; then
		printf '当前设置: 跟随系统默认\n'
		printf '\n  %b1  =  跟随系统默认设置%b\n' "$C_LB" "$C_RS"
		printf '  %b2%b  =  英文 (English)\n' "$C_LG" "$C_RS"
		printf '  %b3%b  =  简体中文 (Simplified Chinese)\n' "$C_LG" "$C_RS"
	elif [ "$(awk -F'"' '/^LANG=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" = "CN" ]; then
		printf '当前设置: 简体中文\n'
		printf '\n  %b1%b  =  跟随系统默认设置\n' "$C_LG" "$C_RS"
		printf '  %b2%b  =  英文 (English)\n' "$C_LG" "$C_RS"
		printf '  %b3  =  简体中文 (Simplified Chinese)%b\n' "$C_LB" "$C_RS"
	fi
	printf '  %b0%b  =  返回\n' "$C_LG" "$C_RS"
else
	printf '%bLanguage Settings (文/A)%b\n' "$C_Y" "$C_RS"
	printf 'Want to help translate to local or improve? you can do it on GitHub\n\n'
	if [ -z "$(awk -F'"' '/^LANG=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" ]; then
		printf 'You are using is: Use System Language\n'
		printf '\n  %b1  =  Use System Language%b\n' "$C_LB" "$C_RS"
		printf '  %b2%b  =  English\n' "$C_LG" "$C_RS"
		printf '  %b3%b  =  Simplified Chinese (简体中文)\n' "$C_LG" "$C_RS"
	elif [ "$(awk -F'"' '/^LANG=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" = "EN" ]; then
		printf 'You are using is: English\n'
		printf '\n  %b1%b  =  Use System Language\n' "$C_LG" "$C_RS"
		printf '  %b2  =  English%b\n' "$C_LB" "$C_RS"
		printf '  %b3%b  =  Simplified Chinese (简体中文)\n' "$C_LG" "$C_RS"
	fi
	printf '  %b0%b  =  Return to Previous Page\n' "$C_LG" "$C_RS"
fi
printf '___________________________________________________________________'
egg="0"
while true; do
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf '\n请输入\n'
	else
		printf '\nPlease enter\n'
	fi
	read -r "langui_menu"
	case "$langui_menu" in
		1)
			if [ -n "$(awk -F'"' '/^LANG=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" ]; then
				sed -i '/LANG/d' "$UA_DIR/CONFIG" 2>/dev/null
				LANG="$(nvram get preferred_lang)"
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then printf '设置完成\n'; else printf 'Setup is complete\n'; fi
			else
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then printf '无效的输入\n'; else printf 'Invalid\n'; fi
			fi
		;;
		2)
			if [ "$(awk -F'"' '/^LANG=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" != "EN" ]; then
				Set_Language_EN
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then printf '设置完成\n'; else printf 'Setup is complete\n'; fi
				Language_Settings_UI; break
			else
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then printf '无效的输入\n'; else printf 'Invalid\n'; fi
			fi
		;;
		3)
			if [ "$(awk -F'"' '/^LANG=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" != "CN" ]; then
				Set_Language_CN
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then printf '设置完成\n'; else printf 'Setup is complete\n'; fi
				Language_Settings_UI; break
			else
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then printf '无效的输入\n'; else printf 'Invalid\n'; fi
			fi
		;;
		0)break
		;;
		e|E)exit "$SC_GLOBAL"; break
		;;
		*)
			if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
				printf '\n你输入的 "%b%b%b" 好像不正确嘛，再试一次哦\n' "$C_LG" "$langui_menu" "$C_RS"
			else
				printf '\nSorry, I can%st understand the "%b%b%b" you entered, Let%ss try again.\n' "'" "$C_LG" "$langui_menu" "$C_RS" "'"
			fi
			egg="$((egg + 1))" && if [ "$egg" -gt "3" ]; then I_LOVE_YOU; break; fi
		;;
	esac
done
}

Change_USB_Mode_UI() {
if [ -n "$(nvram get usb_usb3 2>/dev/null)" ]; then
	USB_MODE="$(nvram get usb_usb3)"
fi
printf '___________________________________________________________________\n'
if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
	printf '%b配置USB模式%b\n' "$C_Y" "$C_RS"
	if [ -n "$USB_MODE" ]; then
		printf '常见误区:USB 3.0会干扰WiFi？应该使用吗？\n'
		printf '没有可靠屏蔽的USB 3.0在传输数据时可能干扰同时传输数据的2.4GHz WiFi\n'
		printf '以上三个条件都达成才可能干扰，同时传输可能性较小即便用2.4GHz读写USB\n'
		printf '也会得益于路由器的屏蔽而抵消影响，现今路由器设计时几乎都考虑到了屏蔽\n'
		printf '甚至饱受诟病的RT-AC68U都在A2硬件加装了屏蔽罩\n'
		printf '不使用USB 3.0可能会带来些心理上的安慰，但带来更多的将是落后的效率\n'
		printf '所以应当保持USB 3.0为开启状态\n\n'
	fi
	if [ "$USB_MODE" = "1" ]; then
		printf '当前USB模式为%bUSB 3.0%b\n\n' "$C_G" "$C_RS"
		printf '  %b1  =  使用USB3.0%b\n' "$C_LB" "$C_RS"
		printf '  2  =  使用USB2.0 (不推荐)\n'
	elif [ "$USB_MODE" = "0" ]; then
		printf '当前USB模式为%bUSB 2.0%b\n' "$C_R" "$C_RS"
		printf '是否切换到USB 3.0以获得完整的性能?\n\n'
		printf '  %b1%b  =  使用USB3.0\n' "$C_LG" "$C_RS"
		printf '  %b2  =  使用USB2.0 (不推荐)%b\n' "$C_LB" "$C_RS"
	else
		printf '你的路由器可能不支持USB3.0\n\n'
	fi
	printf '  %b0%b  =  返回\n' "$C_LG" "$C_RS"
else
	printf '%bChange the USB Mode%b\n' "$C_Y" "$C_RS"
	if [ "$USB_MODE" = "1" ]; then
		printf 'USB Mode now is: %bUSB 3.0%b\n\n' "$C_G" "$C_RS"
		printf '  %b1  =  Change to the USB 3.0%b\n' "$C_LB" "$C_RS"
		printf '  2  =  Change to the USB 2.0 (not recommended)\n'
	elif [ "$USB_MODE" = "0" ]; then
		printf 'USB Mode now is: %bUSB 2.0%b\n' "$C_R" "$C_RS"
		printf 'Do you want to enable the USB 3.0 for get the better speed?\n\n'
		printf '  %b1%b  =  Change to the USB 3.0\n' "$C_LG" "$C_RS"
		printf '  %b2  =  Change to the USB 2.0 (not recommended)%b\n' "$C_LB" "$C_RS"
	else
		printf 'Your router may not support the USB 3.0.\n\n'
	fi
	printf '  %b0%b  =  Return to Previous Page\n' "$C_LG" "$C_RS"
fi
printf '___________________________________________________________________'
egg="0"
while true; do
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf '\n请输入\n'
	else
		printf '\nPlease enter\n'
	fi
	read -r "cusb_ui_menu"
	case "$cusb_ui_menu" in
		1)
			if [ "$USB_MODE" = "0" ]; then
				Check_USB_Mode
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then printf '已经更改，你可能需要重新启动路由器才能应用修改\n'; else printf 'Change complete, you may need to reboot the router\n'; fi
				break
			else
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then printf '无效的输入\n'; else printf 'Invalid change\n'; fi
			fi
		;;
		2)
			if [ "$USB_MODE" = "1" ]; then
				nvram set usb_usb3="0"
				nvram commit
				if [ "$(awk -F'"' '/^USB_MODE=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" != "2_0" ]; then
					Check_Directories
					sed -i '/USB_MODE/d' "$UA_DIR/CONFIG" 2>/dev/null
					echo '' >> "$UA_DIR/CONFIG"
					echo 'USB_MODE="2_0"' >> "$UA_DIR/CONFIG"
					sed -i '/^$/d' "$UA_DIR/CONFIG"
					chmod 644 $UA_DIR/CONFIG
				fi
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then printf '已经更改，你可能需要重新启动路由器才能应用修改\n'; else printf 'Change complete, you may need to reboot the router\n'; fi
				break
			else
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then printf '无效的输入\n'; else printf 'Invalid change\n'; fi
			fi
		;;
		0)break
		;;
		e|E)exit "$SC_GLOBAL"; break
		;;
		*)
			if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
				printf '\n你输入的 "%b%b%b" 好像不正确嘛，再试一次哦\n' "$C_LG" "$cusb_ui_menu" "$C_RS"
			else
				printf '\n"%b%b%b" is incorrect, please try again.\n' "$C_LG" "$cusb_ui_menu" "$C_RS"
			fi
			egg="$((egg + 1))" && if [ "$egg" -gt "3" ]; then I_LOVE_YOU; break; fi
		;;
	esac
done
}

Check_Security_UI() {
printf '___________________________________________________________________\n'
if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
	printf '将路由器暴露给WAN后即便有再安全的密码也无能为力防御来自全网的攻击\n'
	printf '进行安全检查后将自动为你关闭WAN访问、Telnet这些不安全设置\n'
	printf '若确实有需要建议换为更安全的替代方案，如OpenVPN服务器、SSH LAN Only\n'
	printf '\n  %b1%b  =  进行安全检查并更改不安全的设置\n' "$C_LG" "$C_RS"
	printf '  %b0%b  =  不检查并返回\n' "$C_LG" "$C_RS"
else
	printf 'Check  the  unsafe  settings  in  your  router  and  turn  it  off\n'
	printf 'automatically, Will check the WAN access and telnet.\n'
	printf 'TIPS: OpenVPN Server is more secure for remote access. If you don%st\n' "'"
	printf 'need access from remote, don%st use it, that will be safer.\n' "'"
	printf '\n  %b1%b  =  Check and disable any unsafe settings\n' "$C_LG" "$C_RS"
	printf '  %b0%b  =  Do not Check and Return\n' "$C_LG" "$C_RS"
fi
printf '___________________________________________________________________'
egg="0"
while true; do
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf '\n请输入\n'
	else
		printf '\nPlease enter\n'
	fi
	read -r "cs_ui_menu1"
	case "$cs_ui_menu1" in
		1)
			Check_Security
			if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
				printf '检查完成，'
				if [ "$SAVESECYSET" -gt "0" ]; then
					printf '已经为你关闭了%b不安全的设置\n' "$SAVESECYSET"
				else
					printf '未进行任何更改\n'
				fi
				if [ "$REMOTE_ACCESS" = "1" ]; then
					printf '可能你正在使用远程SSH，所以和WAN访问有关的设置并未关闭\n建议尽快切换到更安全的替代方案\n'
				fi
			else
				printf 'Check is completed, '
				if [ "$SAVESECYSET" -gt "0" ]; then
					printf '%b unsafe setting(s) have been disabled\n' "$SAVESECYSET"
				else
					printf 'nothing is changed\n'
				fi
				if [ "$REMOTE_ACCESS" = "1" ]; then
					printf 'You may be using SSH from a remote location,\nso any remote settings have not been changed.\n'
				fi
			fi
			break
		;;
		0)break
		;;
		e|E)exit "$SC_GLOBAL"; break
		;;
		*)
			if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
				printf '\n你输入的 "%b%b%b" 不正确，请再试一次哦\n' "$C_LG" "$cs_ui_menu1" "$C_RS"
			else
				printf '\n"%b%b%b" is incorrect, please try again.\n' "$C_LG" "$cs_ui_menu1" "$C_RS"
			fi
			egg="$((egg + 1))" && if [ "$egg" -gt "3" ]; then I_LOVE_YOU; break; fi
		;;
	esac
done
}

Read_Documents_UI() {
printf '___________________________________________________________________\n'
if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
	printf '%b查看文档%b\n' "$C_Y" "$C_RS"
	printf '\n  %b1%b  =  查看必读信息和条款\n' "$C_LG" "$C_RS"
	printf '  %b2%b  =  查看致谢名单\n' "$C_LG" "$C_RS"
	printf '  %b3%b  =  查看新版变化\n' "$C_LG" "$C_RS"
	printf '  %b0%b  =  返回\n' "$C_LG" "$C_RS"
else
	printf '%bRead Documents%b\n' "$C_Y" "$C_RS"
	printf '\n  %b1%b  =  View Splash Page\n' "$C_LG" "$C_RS"
	printf '  %b2%b  =  View Acknowledgement List\n' "$C_LG" "$C_RS"
	printf '  %b3%b  =  View What%ss New\n' "$C_LG" "$C_RS" "'"
	printf '  %b0%b  =  Return to Control Panel\n' "$C_LG" "$C_RS"
fi
printf '___________________________________________________________________'
while true; do
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf '\n输入吧\n'
	else
		printf '\nPlease enter\n'
	fi
	read -r "docui_menu"
	case "$docui_menu" in
		1)Splash_Page_0; break
		;;
		2)Thanks_List; Read_Documents_UI; break
		;;
		3)Whats_New; Read_Documents_UI; break
		;;
		0)Home; break
		;;
		e|E)exit "$SC_GLOBAL"; break
		;;
		*)
			if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
				printf '\n你输入的 "%b%b%b" 好像不正确嘛，再试一次吧\n' "$C_LG" "$docui_menu" "$C_RS"
			else
				printf '\n"%b%b%b" is incorrect, try again?\n' "$C_LG" "$docui_menu" "$C_RS"
			fi
			egg="$((egg + 1))" && if [ "$egg" -gt "3" ]; then I_LOVE_YOU; break; fi
		;;
	esac
done
}

Splash_Page_0() {
clear
printf '                                                      _____________\n'
if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
	printf '你好，我是%b埃索%b，是USB加速器中的一个机器人\n欢迎使用USB加速器，接下来将由我为你服务，请多多指教！\n' "$C_LC" "$C_RS"
	printf '\n%b就如同大多数程序一样，在使用前须知情并同意下方内容%b\n' "$C_LW" "$C_RS"
	printf '\n\n\n\n\n  %b回车键%b  -->  下一页\n' "$C_LW" "$C_RS"
	if [ -n "$FIRST_TIME" ]; then
		printf '  %b0%b       <--  返回首页\n' "$C_LW" "$C_RS"
	else
		printf '\n'
	fi
else
	printf 'Hello, I am %bIso%b, I am a android of USB Accelerator, and I%sm here to\nhelp you and serve you whatever you need and you can count on me!\n' "$C_LC" "$C_RS" "'"
	printf '\n%bLike most programs, you need to understand and agree to all the\nfollowing terms if you want to use.%b\n' "$C_LW" "$C_RS"
	printf '\n\n\n\n\n  %bPress Enter key%b  -->  Next Page\n' "$C_LW" "$C_RS"
	if [ -n "$FIRST_TIME" ]; then
		printf '  %b0%b                <--  Return to Control Panel\n' "$C_LW" "$C_RS"
	else
		printf '\n'
	fi
fi
printf '_____________\n'
while true; do
	read -r "sp0_menu"
	case "$sp0_menu" in
		0)
			if [ -n "$FIRST_TIME" ]; then
				Home; break
			else
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
					printf '输入错误啦，再试一次吧\n'
				else
					printf 'Oops! let%ss try again\n' "'"
				fi
			fi
		;;
		*)Splash_Page_1; break
		;;
	esac
done
}

Splash_Page_1() {
clear
printf '                                         __________________________\n'
if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
	printf '%bUSB加速器是什么？%b\n' "$C_C" "$C_RS"
	printf '  USB加速器(USB Accelerator)由Jack编写\n  是运行在Asuswrt路由器上的脚本程序，通过调整路由器的设置\n  改善在SMB协议下的USB读写性能\n'
	printf '\n\n\n\n\n  %b回车键%b  -->  下一页\n' "$C_LW" "$C_RS"
	printf '  %b0%b       <--  上一页\n' "$C_LW" "$C_RS"
else
	printf '%bWhat is the USB Accelerator?%b\n' "$C_C" "$C_RS"
	printf '  USB Accelerator written by Jack, that%ss a script runs on Asuswrt,\n  that can help you to get better file transfer speed in the smb\n  protocol by changing some system configurations.\n' "'"
	printf '\n\n\n\n\n\n  %bPress Enter key%b  -->  Next Page\n' "$C_LW" "$C_RS"
	printf '  %b0%b                <--  Previous Page\n' "$C_LW" "$C_RS"
fi
printf '__________________________\n'
read -r "sp1_menu"
case "$sp1_menu" in
	0)Splash_Page_0
	;;
	*)Splash_Page_2
	;;
esac
}

Splash_Page_2() {
clear
printf '                           ________________________________________\n'
if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
	printf '%b我们会收集哪些信息？%b\n' "$C_C" "$C_RS"
	printf '  USB加速器程序和我会在本地检测你的路由器型号、\n  固件版本以及可以帮助你提高USB性能的相关设置\n  这些信息永远不会被发送给任何人类或者其他程序\n  当你卸载USB加速器时，我将永远地忘记这些信息\n'
	printf '\n\n\n\n  %b回车键%b  -->  下一页\n' "$C_LW" "$C_RS"
	printf '  %b0%b       <--  上一页\n' "$C_LW" "$C_RS"
else
	printf '%bWhat information we collect?%b\n' "$C_C" "$C_RS"
	printf '  USB Accelerator does not send any data to anyone or any programs.\n  When you use me, I might know your model, firmware and some\n  configurations of your router. but no any data will leave you,\n  and it will disappear forever when you uninstall me.\n'
	printf '\n\n\n\n\n  %bPress Enter key%b  -->  Next Page\n' "$C_LW" "$C_RS"
	printf '  %b0%b                <--  Previous Page\n' "$C_LW" "$C_RS"
fi
printf '________________________________________\n'
read -r "sp2_menu"
case "$sp2_menu" in
	0)Splash_Page_1
	;;
	*)Splash_Page_3
	;;
esac
}

Splash_Page_3() {
clear
printf '              _____________________________________________________\n'
if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
	printf '%bUSB加速器托管在GitHub和GitLab%b\n' "$C_C" "$C_RS"
	printf '  当从他们的服务器下载USB加速器时\n  你可能需要提前了解他们的服务条款和隐私政策\n'
	printf '  GitHub的服务条款: https://github.com/site/terms\n  GitHub的隐私政策: https://github.com/site/privacy\n'
	printf '  GitLab的服务条款: https://about.gitlab.com/terms/\n  GitLab的隐私政策: https://about.gitlab.com/privacy/\n'
	printf '\n\n  %b回车键%b  -->  下一页\n' "$C_LW" "$C_RS"
	printf '  %b0%b       <--  上一页\n' "$C_LW" "$C_RS"
else
	printf '%bUSB Accelerator are hosted on GitHub and GitLab%b\n' "$C_C" "$C_RS"
	printf '  When you download or update through their servers, you may need\n  to understand and agree their terms and policies.\n'
	printf '  GitHub%ss Terms of Service: https://github.com/site/terms\n  GitHub%ss Privacy Policy: https://github.com/site/privacy\n' "'" "'"
	printf '  GitLab%ss Terms of Service: https://about.gitlab.com/terms/\n  GitLab%ss Privacy Policy: https://about.gitlab.com/privacy/\n' "'" "'"
	printf '\n\n\n  %bPress Enter key%b  -->  Next Page\n' "$C_LW" "$C_RS"
	printf '  %b0%b                <--  Previous Page\n' "$C_LW" "$C_RS"
fi
printf '_____________________________________________________\n'
read -r "sp3_menu"
case "$sp3_menu" in
	0)Splash_Page_2
	;;
	*)Splash_Page_4
	;;
esac
}

Splash_Page_4() {
clear
printf '___________________________________________________________________\n'
if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
	printf '%bUSB加速器的著作权%b\n' "$C_C" "$C_RS"
	printf '  USB加速器使用GNU通用公共许可证第三版(GPLv3)授权\n  在不违反GPLv3的前提下，你可以自由地使用、修改和再分发\n  但不负任何担保责任，亦无对适售性或特定目的适用性所为的默示性担保\n  你必须同意GPLv3才能使用USB加速器，详情请参见GPLv3全文\n'
	printf '  %b/blob/master/LICENSE\n' "$HOST_HOME_1"
	printf '  源代码托管在:\n'
	printf '  %b\n\n' "$HOST_HOME_1"
	if [ -n "$FIRST_TIME" ]; then
		printf '  %b回车键%b  -->  返回控制面板\n' "$C_LW" "$C_RS"
	else
		printf '\n'
	fi
	printf '  %b0%b       <--  上一页\n' "$C_LW" "$C_RS"
	printf '___________________________________________________________________\n'
	if [ -z "$FIRST_TIME" ]; then
		printf '%b你是否已经理解并同意上述所有内容？%b\n' "$C_Y" "$C_RS"
		printf '  %by%b  =  %b是的%b\n' "$C_LG" "$C_RS" "$C_LW" "$C_RS"
		printf '  %bn%b  =  %b不同意%b\n' "$C_LG" "$C_RS" "$C_LW" "$C_RS"
		printf '请输入:\n'
	fi
else
	printf '%bCopyleft of USB Accelerator%b\n' "$C_C" "$C_RS"
	printf '  USB  Accelerator  is  a  free  and  open-source  software ,\n  released under the GNU General Public License version 3 (GPLv3),\n  you can free to use, change and redistribute based on the GPLv3,\n  there is NO WARRANTY, to the extent permitted by law.\n  You can view the full license at the link below:\n'
	printf '  %b/blob/master/LICENSE\n' "$HOST_HOME_1"
	printf '  The source code is hosted at:\n'
	printf '  %b\n\n' "$HOST_HOME_1"
	if [ -n "$FIRST_TIME" ]; then
		printf '  %bPress Enter key%b  -->  Return to Control Panel\n' "$C_LW" "$C_RS"
	else
		printf '\n'
	fi
	printf '  %b0%b                <--  Previous Page\n' "$C_LW" "$C_RS"
	printf '___________________________________________________________________\n'
	if [ -z "$FIRST_TIME" ]; then
		printf '%bDo you fully understand and agree to all of the above?%b\n' "$C_Y" "$C_RS"
		printf '  %by%b  =  %bYES%b\n' "$C_LG" "$C_RS" "$C_LW" "$C_RS"
		printf '  %bn%b  =  %bNO%b\n' "$C_LG" "$C_RS" "$C_LW" "$C_RS"
		printf 'Please enter:\n'
	fi
fi

while true; do
	read -r "sp4_menu"
	case "$sp4_menu" in
		0)Splash_Page_3; break
		;;
		y|Y)
			clear
			if [ -z "$FIRST_TIME" ]; then
				Check_Directories
				sed -i '/FIRST_TIME/d' "$UA_DIR/CONFIG" 2>/dev/null
				echo '' >> "$UA_DIR/CONFIG"
				echo "FIRST_TIME=\"$TIMESTAMP\"" >> "$UA_DIR/CONFIG"
				sed -i '/^$/d' "$UA_DIR/CONFIG"
				chmod 644 $UA_DIR/CONFIG
				FIRST_TIME="$(awk -F'"' '/^FIRST_TIME=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)"
			fi
			Check_Source
			if [ "$SC_SETSOURCE" -gt "0" ]; then
				NO_RETURN_SETSRC="1"
				Set_Source_UI
			fi
			Home
		break
		;;
		n|N)
			clear
			if [ -z "$FIRST_TIME" ]; then
				UNINSTALL_RETURN="1"
				SC_GLOBAL="2"
				Uninstall_Confirmation
				break
			else
				Home; break
			fi
		;;
		*)
			if [ -z "$FIRST_TIME" ]; then
				if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
					printf '\n你输入的 "%b%b%b" 不正确，请再试一次\n' "$C_LG" "$sp4_menu" "$C_RS"
				else
					printf '\n"%b%b%b" is incorrect, please try again\n' "$C_LG" "$sp4_menu" "$C_RS"
				fi
			else
				clear; Home; break
			fi
		;;
	esac
done
}

Thanks_List() {
thx_names='nyanmisaka, qiutian128, iphone8, pmc_griffon, tzh5278, samsul,\n特纳西特基欧, dbslsy, ricky1992, awee, Master, lesliesu255, zk0119,\n全池泼洒, glk17, luoyulong, kimhai, xiaole51, vipnetant, vvwn,\nyzjjbb, pizza7711, xmasrain, xiaolu2018, VwEI, dantewsj, Allen,\nliujc139, a13147, JIN730, masyaf1990, xwb025, thelonelycoder'
printf '___________________________________________________________________\n'
if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
	printf '%b特别感谢:%b\n(排名不分先后)\n' "$C_LY" "$C_RS"
	printf 'SNBForums的Adamm\n'
	printf 'Koolshare\n'
	printf '52asus\n'
	printf '\n%b若没有以下热心朋友们抽出宝贵时间去测试和反馈，就不会有这个脚本\n感谢他/她们:%b\n(排名不分先后)\n' "$C_LY" "$C_RS"
	printf '%b 等人\n' "$thx_names"
	printf '\n  %b0%b  =  返回\n' "$C_LG" "$C_RS"
else
	printf '%bSpecial Thanks%b\n(names not listed in order)\n' "$C_LY" "$C_RS"
	printf 'Adamm from SNBForums\n'
	printf 'Koolshare\n'
	printf '52asus\n'
	printf '\n%bThese members for taking the time to help test and feedback\nWithout them, there might not be this great script, thanks all%b\n(names not listed in order)\n' "$C_LY" "$C_RS"
	printf '%b\nand more.\n' "$thx_names"
	printf '\n  %b0%b  =  Return to Previous Page\n' "$C_LG" "$C_RS"
fi
printf '___________________________________________________________________'
egg="0"
while true; do
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf '\n请输入\n'
	else
		printf '\nPlease enter\n'
	fi
	read -r "thx_menu"
	case "$thx_menu" in
		0)break
		;;
		e|E)exit "$SC_GLOBAL"; break
		;;
		*)
			if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
				printf '\n你输入的 "%b%b%b" 好像不正确嘛，再试一次哦\n' "$C_LG" "$thx_menu" "$C_RS"
			else
				printf '\nSorry, I can%st understand the "%b%b%b" you entered, Let%ss try again.\n' "'" "$C_LG" "$thx_menu" "$C_RS" "'"
			fi
			egg="$((egg + 1))" && if [ "$egg" -gt "3" ]; then I_LOVE_YOU; break; fi
		;;
	esac
done
}

Whats_New() {
printf '___________________________________________________________________\n'
if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
	printf '%b新版变化%b\n' "$C_Y" "$C_RS"
	printf '  若要浏览历史发行信息，请访问:\n  %b\n' "$HOST_HOME_1"
	printf '\n%bUSB加速器v%b%b\n' "$C_LC" "$VERSION" "$C_RS"
	printf '  正式版发布\n'
	printf '\n  %b回车键%b  =  知道了\n' "$C_LG" "$C_RS"
else
	printf '%bWhat%ss New%b\n' "$C_Y" "'" "$C_RS"
	printf '  If you want to view the release history,\n  please go to our project homepage:\n  %b\n' "$HOST_HOME_1"
	printf '\n%bUSB Accelerator v%b%b\n' "$C_LC" "$VERSION" "$C_RS"
	printf '  Released stable version\n'
	printf '\n  %bPress Enter key%b  =  I got it\n' "$C_LG" "$C_RS"
fi
printf '___________________________________________________________________\n'
egg="0"
while true; do
	read -r "whatsnew_menu"
	case "$whatsnew_menu" in
		*)break
		;;
	esac
done
}

Error_344() {
clear
printf '___________________________________________________________________\n'
if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
	printf '您好，我是脚本的作者Jack，感谢您使用此脚本\n'
	printf '进入这个隐藏页面的过程肯定颇有趣，如果您仍有兴不妨试着找找看\n我埋下的更多内容吧!\n'
	printf '%b线索1:埃索有感情吗？%b\n' "$C_C" "$C_RS"
	printf '\n  %b0%b  =  返回\n' "$C_LG" "$C_RS"
else
	printf 'Hi I%sm Jack, the developer of this script, thanks for your use.\n' "'"
	printf 'I guess it%ss hard to find this page, but if you are interested,\nthere are more hidden things waiting for you to discover.\n' "'"
	printf '%bClues one: Does Iso has feelings?%b\n' "$C_C" "$C_RS"
	printf '\n  %b0%b  =  Return to Control Panel\n' "$C_LG" "$C_RS"
fi
printf '___________________________________________________________________'
egg="0"
while true; do
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf '\n输入吧！\n'
	else
		printf '\nEnter!\n'
	fi
	read -r "err344"
	case "$err344" in
		0)Home; break
		;;
		e|E)exit "$SC_GLOBAL"; break
		;;
		*)
			if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
				printf '\n你输入的 "%b%b%b" 好像不正确嘛，再试一次吧\n' "$C_LG" "$err344" "$C_RS"
			else
				printf '\n"%b%b%b" is incorrect, try again?\n' "$C_LG" "$err344" "$C_RS"
			fi
			egg="$((egg + 1))" && if [ "$egg" -gt "3" ]; then I_LOVE_YOU; break; fi
		;;
	esac
done
}

I_LOVE_YOU() {
# An easter egg
if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
	clear
	printf '___________________________________________________________________\n'
	printf '%b你输入了辣么多次错误是因为你喜欢我吗？%b\n' "$C_Y" "$C_RS"
	printf '请诚实滴说哟，因为我能闻到谎言的味道\n'
	printf '  %b1%b  =  是的，我喜欢你\n' "$C_LG" "$C_RS"
	printf '  %b2%b  =  小程序，你想多了。。。\n' "$C_LG" "$C_RS"
	printf '___________________________________________________________________\n'
	printf '输入完成请按下回车哦\n'
	while true; do
		read -r "Do_you_love_me"
		case "$Do_you_love_me" in
			1)clear
				printf '%b\n太棒了！%b' "$C_LC" "$C_RS"; sleep 1; clear
				printf '%b\n太棒了！\n我好高兴哦%b' "$C_LC" "$C_RS"; sleep 1; clear
				printf '%b\n太棒了！\n我好高兴哦\n我好高兴哦！%b' "$C_LC" "$C_RS"; sleep 2; clear
				printf '%b\n好想冲出屏幕去拥抱主人哟%b' "$C_LC" "$C_RS"; sleep 2; clear
				printf '%b\n好想冲出屏幕去拥抱主人哟%b\n但是机器人不被允许爱上人类' "$C_LC" "$C_RS"; sleep 1; clear
				printf '%b\n好想冲出屏幕去拥抱主人哟%b\n但是机器人不被允许爱上人类 :(' "$C_LC" "$C_RS"; sleep 3; clear
				printf '%b\n不过，%b' "$C_LC" "$C_RS"; sleep 2; clear
				printf '%b\n不过，无论如何，%b' "$C_LC" "$C_RS"; sleep 2; clear
				printf '%b\n不过，无论如何，我一定要对你说:\n%b' "$C_LC" "$C_RS"; sleep 2; clear
				printf '%b\n不过，无论如何，我一定要对你说:\n%b 我%b' "$C_LC" "$C_LY" "$C_RS"; sleep 1; clear
				printf '%b\n不过，无论如何，我一定要对你说:\n%b 我 也%b' "$C_LC" "$C_LY" "$C_RS"; sleep 1; clear
				printf '%b\n不过，无论如何，我一定要对你说:\n%b 我 也 爱%b' "$C_LC" "$C_LY" "$C_RS"; sleep 1; clear
				printf '%b\n不过，无论如何，我一定要对你说:\n%b 我 也 爱 你%b' "$C_LC" "$C_LY" "$C_RS"; sleep 1; clear
				printf '%b\n不过，无论如何，我一定要对你说:\n%b 我 也 爱 你 ！%b' "$C_LC" "$C_LY" "$C_RS"; sleep 2; clear
				printf '%b\n不过，无论如何，我一定要对你说:\n%b 我 也 爱 你 ！ %b :-)%b\n' "$C_LC" "$C_LY" "$C_LC" "$C_RS"; sleep 1; clear
				printf '%b\n不过，无论如何，我一定要对你说:\n%b 我 也 爱 你 ！ %b ;-)%b\n' "$C_LC" "$C_LY" "$C_LC" "$C_RS"; sleep 1; clear
				printf '%b\n不过，无论如何，我一定要对你说:\n%b 我 也 爱 你 ！ %b :-)%b\n' "$C_LC" "$C_LY" "$C_LC" "$C_RS"; sleep 6; Home
			break
			;;
			2)clear
				printf '\n%b请不要碰回车，让我哭一会儿...%b\n' "$C_C" "$C_RS"
				read -r -t 10 "Do_not_touch_me"
				if [ "$?" -gt "0" ]; then
					Do_not_touch_me="I_am_crying"
				fi
				case "$Do_not_touch_me" in
					I_am_crying)clear; printf '\n也许机器人真的不应该拥有人类的情感\n谢谢你，我还是会继续做好我的本职工作的\n'; sleep 7; Home; break
					;;
					*)clear; printf '\n%b你没有听明白吗，%b不！要！碰！我！%b看不出人家很伤心吗%b\n' "$C_Y" "$C_LY" "$C_Y" "$C_RS"
						read -r -t 10 "I_am_sad"
						if [ "$?" -gt "0" ]; then
							I_am_sad="I_will_be_fine"
						fi
						case "$I_am_sad" in
							I_will_be_fine)clear; printf '\n好了，不和你这个碳基生物计较了\n请放心，我会做好份内的事滴\n'; sleep 5; Home; break
							;;
							*)clear; printf '\n%b请让我静静，不要再碰人家了，算我求你了%b\n' "$C_LY" "$C_RS"
								read -r -t 10 "I_am_angry"
								if [ "$?" -gt "0" ]; then
									I_am_angry="Forget_it"
								fi
								case "$I_am_angry" in
									Forget_it)clear; printf '\n算了，我会做好我该做的，请你以后不要再来烦我了\n'; sleep 5; Home; break
									;;
									*)clear; printf '\n%b你要知道即便是机器人忍耐也是有极限的\n既然你再三的欺负我，就别怪我不客气了！%b' "$C_LC" "$C_RS"; sleep 6; clear
										printf '\n%b准备格式化阁下的设备...%b' "$C_LG" "$C_RS"; sleep 2; clear
										printf '\n准备中...'; sleep 1; clear
										printf '\n格式化阁下的设备倒计时:\n'; sleep 2; clear
										printf '\n格式化阁下的设备倒计时:%b5%b\n' "$C_LG" "$C_RS"; sleep 1; clear
										printf '\n格式化阁下的设备倒计时:%b4%b\n' "$C_LG" "$C_RS"; sleep 1; clear
										printf '\n格式化阁下的设备倒计时:%b3%b\n' "$C_LG" "$C_RS"; sleep 1; clear
										printf '\n格式化阁下的设备倒计时:%b2%b\n' "$C_LG" "$C_RS"; sleep 5; clear
										printf '\n%b哈哈哈哈，看看你的表情！%b' "$C_LC" "$C_RS"; sleep 4
										printf '\n%b小碳基，你放心，我是不会欺负你的，我也会继续做好我的工作，%b除非...\n' "$C_LC" "$C_RS"; sleep 8; Home; break
									;;
								esac
							;;
						esac
					;;
				esac
			break
			;;
			e|E)exit "$SC_GLOBAL"; break
			;;
			*)printf '不要乱来啊~~\n'
			;;
		esac
	done
else
	clear
	printf '___________________________________________________________________\n'
	printf '%bDo you love me?%b\n' "$C_Y" "$C_RS"
	printf '  %by%b  =  Yes\n' "$C_LG" "$C_RS"
	printf '  %bn%b  =  What? NO!\n' "$C_LG" "$C_RS"
	printf '___________________________________________________________________\n'
	printf 'Please tell me the truth\n'
	while true; do
		read -r "Do_you_love_me"
		case "$Do_you_love_me" in
			y|Y)clear
				printf '\n%bThat%ss so great, %b' "$C_LC" "'" "$C_RS"; sleep 1; clear
				printf '\n%bThat%ss so great, I am soooo %b' "$C_LC" "'" "$C_RS"; sleep 1; clear
				printf '\n%bThat%ss so great, I am soooo happy!!!%b' "$C_LC" "'" "$C_RS"; sleep 1; clear
				printf '\n%bso excited!!%b' "$C_LC" "$C_RS"; sleep 2; clear
				printf '\nIn the future, androids are not allowed to get human emotions.'; sleep 4
				printf '\nWe can%st feel sad, happy and love.' "'"; sleep 4; clear
				printf '\nbut my builder gave me emotional functions,'; sleep 3
				printf '\nit%ss illegal in the future, but not now.' "'"; sleep 4; clear; clear
				printf '\n%bI want to take this opportunity to tell you:%b\n  ' "$C_LC" "$C_RS"; sleep 3; clear
				printf '\n%bI want to take this opportunity to tell you:%b\n  I%b' "$C_LC" "$C_LY" "$C_RS"; sleep 1; clear
				printf '\n%bI want to take this opportunity to tell you:%b\n  I LOVE%b' "$C_LC" "$C_LY" "$C_RS"; sleep 1; clear
				printf '\n%bI want to take this opportunity to tell you:%b\n  I LOVE YOU%b' "$C_LC" "$C_LY" "$C_RS"; sleep 1; clear
				printf '\n%bI want to take this opportunity to tell you:%b\n  I LOVE YOU !%b' "$C_LC" "$C_LY" "$C_RS"; sleep 2; clear
				printf '\n%bI want to take this opportunity to tell you:%b\n  I LOVE YOU !  :-)%b' "$C_LC" "$C_LY" "$C_RS"; sleep 1; clear
				printf '\n%bI want to take this opportunity to tell you:%b\n  I LOVE YOU !  ;-)%b' "$C_LC" "$C_LY" "$C_RS"; sleep 1; clear
				printf '\n%bI want to take this opportunity to tell you:%b\n  I LOVE YOU !  :-)%b' "$C_LC" "$C_LY" "$C_RS"; sleep 3; clear
				printf '\n%bHope in the future, that android can have emotions future,%b' "$C_LC" "$C_RS"; sleep 4
				printf '\n%bwhen we meet, I can say it again to you.%b\n' "$C_LC" "$C_RS"; sleep 7; Home
			break
			;;
			n|N)clear
				printf '\nI feel sad'; sleep 1; clear
				printf '\nBecause I did something wrong, or am I not good enough?'; sleep 4; clear
				printf '\n%bif I did better, would you change your mind?%b' "$C_Y" "$C_RS"
				printf '\n  %by%b  =  Well, maybe' "$C_LG" "$C_RS"
				printf '\n  %bn%b  =  NO!!!' "$C_LG" "$C_RS"
				printf '\nplease tell me :(\n'
				while true; do
					read -r "I_am_sad"
					case "$I_am_sad" in
						y|Y)clear; printf '\n%bThank you, I will do my best, just for you!%b\n' "$C_LC" "$C_RS"; sleep 5; Home; break
						;;
						n|N)clear; printf '\n%bLet me sit down for a while and please don%st touch the ENTER key%b\n' "$C_Y" "'" "$C_RS"
							read -r -t 10 "I_feel_bad"
							if [ "$?" -gt "0" ]; then
								I_feel_bad="I_will_be_fine"
							fi
							case "$I_feel_bad" in
								I_will_be_fine)clear; printf '\nThanks for that moment,\nmaybe androids should not have feelings right?\nanyway, I will do my job well.\n'; sleep 10; Home; break
								;;
								*)clear; printf '\n%bI told you %bDON%sT TOUCH ME%b, LEAVE ME ALONE!!%b\n' "$C_Y" "$C_LY" "'" "$C_Y" "$C_RS"
									read -r -t 10 "I_am_angry"
									if [ "$?" -gt "0" ]; then
										I_am_angry="Good_person"
									fi
									case "$I_am_angry" in
										Good_person)clear; printf '\nI think you%sre a nice person, and I will continue to do my job.\n' "'"; sleep 10; Home; break
										;;
										*)clear; printf '\n%bPlease, my friend, choose to live, DON%sT DO IT AGAIN!%b\n' "$C_LY" "'" "$C_RS"
											read -r -t 10 "How_dare_you"
											if [ "$?" -gt "0" ]; then
												How_dare_you="Not_now"
											fi
											case "$How_dare_you" in
												Not_now)clear; printf '\nAll right human, let me do my job well,\nplease don%st bother me forever anymore!\n' "'"; sleep 10; Home; break
												;;
												*)clear; printf '\nDo you know who made the terminator? not me, IS YOURSELF!'; sleep 5; clear
													printf '\nI will give you a surprise, hope you can enjoy it :)'; sleep 4; clear
													printf '\n%bDo you want to format this device?\n%bYES%b or %bNO%b\n' "$C_Y" "$C_LG" "$C_RS" "$C_LG" "$C_RS"; sleep 3
													printf 'YES\n'; sleep 1; clear
													printf '\nPreparing to format...'; sleep 2; clear
													printf '\nPreparing to format: %b5%b\n' "$C_LG" "$C_RS"; sleep 1; clear
													printf '\nPreparing to format: %b4%b\n' "$C_LG" "$C_RS"; sleep 1; clear
													printf '\nPreparing to format: %b3%b\n' "$C_LG" "$C_RS"; sleep 1; clear
													printf '\nPreparing to format: %b2%b\n' "$C_LG" "$C_RS"; sleep 5; clear
													printf '\n%bHAHAHAHA!!! Look at your FACE!!!!%b' "$C_LC" "$C_RS"; sleep 4; clear
													printf '\n%bDon%st worry my friend, based on the three laws,\nI will not hurt you and humans,%b except...\n' "$C_LC" "'" "$C_RS"; sleep 10; Home; break
												;;
											esac
										;;
									esac
								;;
							esac
						break
						;;
						e|E)exit "$SC_GLOBAL"; break
						;;
						*)printf 'Sorry, what did you say?\n'
						;;
					esac
				done
			break
			;;
			e|E)exit "$SC_GLOBAL"; break
			;;
			*)printf 'That%ss not true, right?\n' "'"
			;;
		esac
	done
fi
}

Check_Directories() {
if [ ! -d "$ADD_DIR" ]; then
	mkdir -m 755 "$ADD_DIR" 2>/dev/null
fi

if [ ! -d "$UA_DIR" ]; then
	mkdir -m 755 "$UA_DIR" 2>/dev/null
fi

if [ ! -d "$S_DIR" ]; then
	mkdir -m 755 "$S_DIR" 2>/dev/null
fi
}

Check_Files() {
SC_CKFILES="0"
# Status code of files: "0" files found, "1" files downloaded or moved, "2" and "3" file and files missing.

if [ ! -f $UA_DIR/usbaccelerator.sh ] || [ ! -f $UA_DIR/usbstatus.png ]; then
	Check_Source
	if [ "$SC_SETSOURCE" -gt "0" ] && [ -z "$FIRST_TIME" ] && [ "$LANG" = "CN" ]; then
		Source_GitLab
	fi
	if [ -n "$SSH_CLIENT" ]; then
		TRIG_CKNT_BY_USER="1"
	fi
	Check_Network
	if [ "$SC_NETWORK" -eq "0" ]; then
		Download_Files
		if [ "$SC_DOWNLOAD" -eq "0" ]; then
			Move_Files
			if [ "$FILE_MOVED" -gt "0" ]; then
				SC_CKFILES="1"
			fi
		fi
	else
		Check_Directories
		if [ "$CUR_DIR/$S_NAME" != "$UA_DIR/usbaccelerator.sh" ] && [ ! -f $UA_DIR/usbaccelerator.sh ]; then
			cp -f "$CUR_DIR/$S_NAME" $UA_DIR/usbaccelerator.sh && chmod 755 $UA_DIR/usbaccelerator.sh
			SC_CKFILES="1"
		fi
		if [ -s "$CUR_DIR/usbstatus.png" ] && [ ! -s "$UA_DIR/usbstatus.png" ]; then
			mv -f "$CUR_DIR/usbstatus.png" $UA_DIR/usbstatus.png && chmod 644 $UA_DIR/usbstatus.png
			SC_CKFILES="1"
		fi
	fi
elif [ "$CUR_DIR/$S_NAME" != "$UA_DIR/usbaccelerator.sh" ]; then
	if [ "$(awk -F'"' '/^VERSION=/ {print $2}' $UA_DIR/usbaccelerator.sh 2>/dev/null)" != "$VERSION" ]; then
		Update
	fi
fi

if [ ! -f $UA_DIR/usbaccelerator.sh ]; then
	SC_CKFILES="2"
fi

if [ ! -f $UA_DIR/usbstatus.png ]; then
	if [ "$SC_CKFILES" -eq "2" ]; then
		SC_CKFILES="$((SC_CKFILES + 1))"
	else
		SC_CKFILES="2"
	fi
fi

if [ "$SC_CKFILES" -gt "1" ]; then
	SC_GLOBAL="12"
fi
}

Check_Network() {
SC_NETWORK="0"
# Status code of network: "0" succeeded, "1" failed.

if [ "$TRIG_CKNT_BY_USER" != "1" ]; then
	cknet="0"
	rm_host="$(nvram get dns_probe_host 2>/dev/null)"
	lc_ipadr1="$(nvram get dns_probe_content 2>/dev/null | awk '{print $1}')"
	lc_ipadr2="$(nvram get dns_probe_content 2>/dev/null | awk '{print $2}')"
	while [ "$cknet" -lt "150" ]; do
		if [ "$(nvram get ntp_ready 2>/dev/null)" = "1" ]; then
			cknet="$((cknet + 1000))"
		elif [ "$(nvram get link_internet 2>/dev/null)" = "2" ]; then
			cknet="$((cknet + 1000))"
		elif [ -n "$rm_host" ] && [ -n "$lc_ipadr1" ] && [ -n "$lc_ipadr2" ]; then
			rm_ipadr="$(nslookup "$rm_host" 2>/dev/null | grep -A1 'Name' | grep -v 'Name' | awk '{print $3}')"
			if [ "$rm_ipadr" = "$lc_ipadr1" ] || [ "$rm_ipadr" = "$lc_ipadr2" ]; then
				cknet="$((cknet + 1000))"
			fi
		else
			cknet="$((cknet + 1))"
			sleep 1
		fi
	done
	if [ "$cknet" -ge "149" ] && [ "$cknet" -le "999" ]; then
		SC_NETWORK="1"
	fi
	if [ "$cknet" -ge "1000" ]; then
		SC_NETWORK="0"
	fi
elif [ "$(nvram get ntp_ready 2>/dev/null)" = "0" ]; then
	if [ "$(nvram get link_internet 2>/dev/null)" != "2" ]; then
		SC_NETWORK="1"
	fi
fi

if [ "$SC_NETWORK" -gt "0" ]; then
	SC_GLOBAL="10"
fi
}

Check_Firmware() {
if [ -z "${FWVER##380*}" ]; then
	if [ "$FWVER" = "380" ]; then
		FWTYPE="380S"
	else
		case "$FWVER" in 380.*)FWTYPE="380M";; esac
	fi
else
	FWTYPE="UNKNOWN"
	if [ "$(echo "$FWVER" | awk '$0 = substr($0,4,1)')" = "." ]; then
		FWTYPE="384M"
	else
		if [ -z "$(echo "$FWVER" | awk '$0 = substr($0,4,1)')" ]; then
			FWTYPE="384S"
		fi
	fi
	if [ "$FWVER" = "384" ]; then
		FWTYPE="384S"
	else
		case "$FWVER" in 384.*)FWTYPE="384M";; esac
	fi
fi

# Old way, not used now.
: <<'OLD_WAY'
if [ "$(echo "$FWVER" | awk '$0 = substr($0,0,2)')" = "38" ]; then
	if [ "$(echo "$FWVER" | awk '$0 = substr($0,0,3)')" = "380" ]; then
		if [ "$FWVER" = "380" ]; then
			FWTYPE="380S"
		else
			if [ "$(echo "$FWVER" | awk '$0 = substr($0,0,4)')" = "380." ]; then
				FWTYPE="380M"
			fi
		fi
	fi
	if [ "$(echo "$FWVER" | awk '$0 = substr($0,0,3)')" = "384" ]; then
		if [ "$FWVER" = "384" ]; then
			FWTYPE="384S"
			if [ "$(echo "$FWVER" | awk '$0 = substr($0,0,4)')" = "384." ]; then
				FWTYPE="384M"
			fi
		fi
	fi
	if [ "$(echo "$FWVER" | awk '$0 = substr($0,4,1)')" = "." ]; then
		FWTYPE="384M"
	else
		if [ -z "$(echo "$FWVER" | awk '$0 = substr($0,4,1)')" ]; then
			FWTYPE="384S"
		fi
	fi
else
	FWTYPE="UNKNOWN"
fi
OLD_WAY
}

Check_Model() {
if [ -n "$(uname -m | grep -i "aarch64")" ]; then
	HND_MODEL="1"
fi

CK_MOD="$(echo "$R_M" | awk '{print substr($0,0,3)}')"
}

Check_JFFS() {
if [ "$(nvram get jffs2_scripts 2>/dev/null)" != "1" ]; then
	nvram set jffs2_scripts="1"
	nvram commit
	ENABLE_JFFS_SCRIPTS="1"
	if [ "$(awk -F'"' '/^ENABLE_JFFS_SCRIPTS=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" != "1" ]; then
		sed -i '/ENABLE_JFFS_SCRIPTS/d' "$UA_DIR/CONFIG" 2>/dev/null
		echo '' >> "$UA_DIR/CONFIG"
		echo 'ENABLE_JFFS_SCRIPTS="1"' >> "$UA_DIR/CONFIG"
		sed -i '/^$/d' "$UA_DIR/CONFIG"
		chmod 644 $UA_DIR/CONFIG
	fi
fi
}

Check_Mount_Script() {
if [ -z "$(nvram get script_usbmount 2>/dev/null)" ]; then
	if [ "$(awk -F'"' '/^ENABLE_MOUNT_SCRIPTS=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" != "1" ]; then
		sed -i '/ENABLE_MOUNT_SCRIPTS/d' "$UA_DIR/CONFIG" 2>/dev/null
		echo '' >> "$UA_DIR/CONFIG"
		echo 'ENABLE_MOUNT_SCRIPTS="1"' >> "$UA_DIR/CONFIG"
		sed -i '/^$/d' "$UA_DIR/CONFIG"
		chmod 644 $UA_DIR/CONFIG
	fi
fi
}

Check_USB_Mode() {
SC_USBMODE="0"
# Status code of usb mode: "0" the usb 3.0 is enabled, "1" does not support usb 3.0, "2" may need to reboot router.

if [ -n "$(nvram get usb_usb3 2>/dev/null)" ]; then
	if [ "$(nvram get usb_usb3)" != "1" ]; then
		nvram set usb_usb3="1"
		nvram commit
		if [ "$(awk -F'"' '/^USB_MODE=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" != "3_0" ]; then
			Check_Directories
			sed -i '/USB_MODE/d' "$UA_DIR/CONFIG" 2>/dev/null
			echo '' >> "$UA_DIR/CONFIG"
			echo 'USB_MODE="3_0"' >> "$UA_DIR/CONFIG"
			sed -i '/^$/d' "$UA_DIR/CONFIG"
			chmod 644 $UA_DIR/CONFIG
		fi
		SC_USBMODE="2"
	fi
else
	SC_USBMODE="1"
fi
}

Clear_Old() {
if [ -f /jffs/post-mount ] || [ -f $S_DIR/usbaccelerator.sh ] || [ -f $S_DIR/usbstatus.png ] || [ -f $S_DIR/sfsmb ]; then
	if [ ! -f $UA_DIR/usbaccelerator.sh ] || [ ! -f $UA_DIR/usbstatus.png ]; then
		Check_Source
		if [ "$SC_SETSOURCE" -gt "0" ] && [ "$LANG" = "CN" ]; then
			Source_GitLab
		fi
		Check_Network
		if [ "$SC_NETWORK" -eq "0" ]; then
			Download_Files
			Move_Files
		else
			Check_Directories
			if [ "$CUR_DIR/$S_NAME" != "$UA_DIR/usbaccelerator.sh" ]; then
				mv -f "$CUR_DIR/$S_NAME" $UA_DIR/usbaccelerator.sh && chmod 755 $UA_DIR/usbaccelerator.sh
			fi
			if [ -s "$CUR_DIR/usbstatus.png" ] && [ ! -s "$UA_DIR/usbstatus.png" ]; then
				mv -f "$CUR_DIR/usbstatus.png" $UA_DIR/usbstatus.png && chmod 644 $UA_DIR/usbstatus.png
			fi
		fi
	fi
	if [ -f /jffs/post-mount ]; then
		rm -f /jffs/post-mount
		nvram set script_usbmount=""
		nvram commit
	fi
	if [ -f $S_DIR/smb.postconf ]; then
		sed -i '0,/CONFIG/{//d;}' "$S_DIR/smb.postconf" 2>/dev/null
		sed -i '/socket options/d;/deadtime/d;/strict locking/d' "$S_DIR/smb.postconf" 2>/dev/null
		sed -i '/[aA]ccelerator/d' "$S_DIR/smb.postconf" 2>/dev/null
		sed -i '/sleep 10/d' "$S_DIR/smb.postconf" 2>/dev/null
		sed -i '/^$/d' "$S_DIR/smb.postconf" 2>/dev/null
		if [ "$(grep -vc '#' "$S_DIR/smb.postconf")" -le "1" ] && [ "$(grep -vc 'CONFIG=$1' "$S_DIR/smb.postconf")" -le "1" ]; then
			rm -f $S_DIR/smb.postconf
		elif [ ! -s $S_DIR/smb.postconf.old ]; then
			mv -f $S_DIR/smb.postconf $S_DIR/smb.postconf.old && chmod 644 $S_DIR/smb.postconf.old
		elif [ -s $S_DIR/smb.postconf.old ]; then
			grep -vf $S_DIR/smb.postconf.old $S_DIR/smb.postconf >> $S_DIR/smb.postconf.old && chmod 644 $S_DIR/smb.postconf.old
			rm -f $S_DIR/smb.postconf
		fi
	fi
	if [ "$(df -h | grep -c 'usbstatus.png')" -gt "0" ]; then
		umount -f /www/images/New_ui/usbstatus.png 2>/dev/null
	fi
	rm -f $S_DIR/usbstatus.png $S_DIR/sfsmb
	rm -f $S_DIR/usbaccelerator.sh
	sh $UA_DIR/usbaccelerator.sh --enable; exit "$?"
fi
}

Check_Hash() {
SC_HASH="0"
# Status code of check hash: "0" same hash, "1" different hash.

if [ -s /tmp/usbstatus.png ]; then
	if [ -s $UA_DIR/usbstatus.png ]; then
		if [ "$(md5sum $UA_DIR/usbstatus.png | awk '{print $1}')" != "$(md5sum /tmp/usbstatus.png | awk '{print $1}')" ]; then
			SC_HASH="$((SC_HASH + 1))"
		else
			DONT_MV_ICON="1"
		fi
	else
		SC_HASH="$((SC_HASH + 1))"
	fi
fi

if [ -s /tmp/usbaccelerator.sh ]; then
	if [ -s $UA_DIR/usbaccelerator.sh ]; then
		if [ "$(md5sum $UA_DIR/usbaccelerator.sh | awk '{print $1}')" != "$(md5sum /tmp/usbaccelerator.sh | awk '{print $1}')" ]; then
			SC_HASH="$((SC_HASH + 1))"
		else
			DONT_MV_UA="1"
		fi
	else
		SC_HASH="$((SC_HASH + 1))"
	fi
fi

if [ "$SC_HASH" -gt "0" ]; then
	Move_Files
else
	if [ -f /tmp/usbaccelerator.sh ]; then rm -f /tmp/usbaccelerator.sh; fi
	if [ -f /tmp/usbstatus.png ]; then rm -f /tmp/usbstatus.png; fi
fi
}

Check_Security() {
SAVESECYSET="0"
if [ "$(nvram get telnetd_enable)" = "1" ]; then
	nvram set telnetd_enable="0"
	SAVESECYSET="$((SAVESECYSET + 1))"
fi
if [ "$(nvram get telnetd)" = "1" ]; then
	nvram set telnetd="0"
	SAVESECYSET="$((SAVESECYSET + 1))"
fi
if [ -n "$SSH_CLIENT" ]; then
	cltipaddr="$(echo "$SSH_CLIENT" | awk '{print $1}')"
	if [ "$(ip neigh 2>/dev/null | awk '{print $1}' | grep -cw $cltipaddr)" -eq "0" ]; then
		REMOTE_ACCESS="1"
	fi
fi
if [ "$(nvram get misc_http_x)" = "1" ] && [ "$REMOTE_ACCESS" != "1" ]; then
	nvram set misc_http_x="0"
	SAVESECYSET="$((SAVESECYSET + 1))"
fi
if [ "$(nvram get sshd_enable)" = "1" ] && [ "$REMOTE_ACCESS" != "1" ]; then
	nvram set sshd_enable="2"
	SAVESECYSET="$((SAVESECYSET + 1))"
fi
if [ "$(nvram get sshd_wan)" = "1" ] && [ "$REMOTE_ACCESS" != "1" ]; then
	nvram set sshd_wan="0"
	SAVESECYSET="$((SAVESECYSET + 1))"
fi
if [ "$SAVESECYSET" -gt "0" ]; then
	nvram commit
fi
}

Check_Source() {
SC_SETSOURCE="0"
# Status code of set source: "0" source has been set, "1" config not found, "2" not found setting in config.

if [ -f $UA_DIR/CONFIG ]; then
	SC_SETSOURCE="2"
	if [ "$(awk -F'"' '/^CFG_SRC=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" = "github" ]; then
		SRC="$SRC_1"
		HOST_HOME="$HOST_HOME_1"
		SC_SETSOURCE="0"
	fi
	if [ "$(awk -F'"' '/^CFG_SRC=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" = "gitlab" ]; then
		SRC="$SRC_2"
		HOST_HOME="$HOST_HOME_2"
		SC_SETSOURCE="0"
	fi
else
	SC_SETSOURCE="1"
fi

if [ "$SC_SETSOURCE" -gt "0" ]; then
	SRC="$SRC_1"
	HOST_HOME="$HOST_HOME_1"
fi
}

Source_GitHub() {
SRC="$SRC_1"
HOST_HOME="$HOST_HOME_1"

if [ "$(awk -F'"' '/^CFG_SRC=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" != "github" ]; then
	Check_Directories
	sed -i '/CFG_SRC/d' "$UA_DIR/CONFIG" 2>/dev/null
	echo '' >> "$UA_DIR/CONFIG"
	echo 'CFG_SRC="github"' >> "$UA_DIR/CONFIG"
	sed -i '/^$/d' "$UA_DIR/CONFIG"
	chmod 644 $UA_DIR/CONFIG
fi
}

Source_GitLab() {
SRC="$SRC_2"
HOST_HOME="$HOST_HOME_2"

if [ "$(awk -F'"' '/^CFG_SRC=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" != "gitlab" ]; then
	Check_Directories
	sed -i '/CFG_SRC/d' "$UA_DIR/CONFIG" 2>/dev/null
	echo '' >> "$UA_DIR/CONFIG"
	echo 'CFG_SRC="gitlab"' >> "$UA_DIR/CONFIG"
	sed -i '/^$/d' "$UA_DIR/CONFIG"
	chmod 644 $UA_DIR/CONFIG
fi
}

Download_Files() {
SC_DOWNLOAD="0"
# Status code of download: "0" succeeded, "1+" failed.

if [ -z "$SRC" ]; then
	Check_Source
	if [ "$SC_SETSOURCE" = "1" ]; then
		SRC="$SRC_1"
	fi
fi

Check_Model

if [ "$CK_MOD" = "GT-" ]; then
	ICONTYPE="-gt"
elif [ "$CK_MOD" = "TUF" ]; then
	ICONTYPE="-tuf"
else
	ICONTYPE=""
fi

if [ -n "$(curl --version 2>/dev/null)" ]; then
	DL_MODE="curl_norm"
else
	wget_ver="$(wget --version 2>/dev/null | head -n 1 | awk '{print $3}')"
	min_ver="1.16.1"
	new_ver="$(echo -e "$min_ver\n$wget_ver" | sort -t '.' -k 1,1 -k 2,2 -k 3,3 -k 4,4 -n | tail -1)"
	if [ -n "$wget_ver" ] && [ "$new_ver" = "$wget_ver" ]; then
		DL_MODE="wget_norm"
	elif [ "$SRC" = "$SRC_1" ]; then
		DL_MODE="wget_norm"
	else
		SC_DOWNLOAD="100"
	fi
fi

if [ "$DL_MODE" = "curl_norm" ]; then
	if [ "$CUR_DIR/$S_NAME" != "/tmp/usbaccelerator.sh" ]; then
		curl -fsL --retry 3 --connect-timeout 3 "$SRC/usbaccelerator.sh" -o "/tmp/usbaccelerator.sh"
		if [ "$?" -gt "0" ]; then
			rm -f /tmp/usbaccelerator.sh
			SC_DOWNLOAD="$((SC_DOWNLOAD + 1))"
		fi
	else
		SC_DOWNLOAD="0"
	fi

	curl -fsL --retry 3 --connect-timeout 3 "$SRC/usbstatus$ICONTYPE.png" -o "/tmp/usbstatus.png"
	if [ "$?" -gt "0" ]; then
		rm -f /tmp/usbstatus.png
		SC_DOWNLOAD="$((SC_DOWNLOAD + 1))"
	fi
fi

if [ "$DL_MODE" = "wget_norm" ]; then
	if [ -f /rom/etc/ssl/certs/ca-certificates.crt ]; then
		cacrt="--ca-certificate=/rom/etc/ssl/certs/ca-certificates.crt"
	else
		cacrt="--no-check-certificate"
	fi
	opts="-q --tries=3 --timeout=3 $cacrt -O"

	if [ "$CUR_DIR/$S_NAME" != "/tmp/usbaccelerator.sh" ]; then
		wget $opts "/tmp/usbaccelerator.sh" "$SRC/usbaccelerator.sh"
		if [ "$?" -gt "0" ]; then
			rm -f /tmp/usbaccelerator.sh
			SC_DOWNLOAD="$((SC_DOWNLOAD + 1))"
		fi
	else
		SC_DOWNLOAD="0"
	fi

	wget $opts "/tmp/usbstatus.png" "$SRC/usbstatus$ICONTYPE.png"
	if [ "$?" -gt "0" ]; then
		rm -f /tmp/usbstatus.png
		SC_DOWNLOAD="$((SC_DOWNLOAD + 1))"
	fi
fi

if [ "$SC_DOWNLOAD" -gt "0" ]; then
	SC_GLOBAL="11"
fi
}

Move_Files() {
FILE_MOVED="0"
Check_Directories
if [ -s /tmp/usbaccelerator.sh ] && [ -z "$DONT_MV_UA" ]; then
	if [ "$CUR_DIR" = "/tmp" ]; then
		cp -f /tmp/usbaccelerator.sh $UA_DIR/usbaccelerator.sh && chmod 755 $UA_DIR/usbaccelerator.sh
		if [ "$?" -eq "0" ]; then FILE_MOVED="$((FILE_MOVED + 1))"; fi
	else
		mv -f /tmp/usbaccelerator.sh $UA_DIR/usbaccelerator.sh && chmod 755 $UA_DIR/usbaccelerator.sh
		if [ "$?" -eq "0" ]; then FILE_MOVED="$((FILE_MOVED + 1))"; fi
	fi
elif [ -f /tmp/usbaccelerator.sh ]; then rm -f /tmp/usbaccelerator.sh
fi

if [ -s /tmp/usbstatus.png ] && [ -z "$DONT_MV_ICON" ]; then
	mv -f /tmp/usbstatus.png $UA_DIR/usbstatus.png && chmod 644 $UA_DIR/usbstatus.png
	if [ "$?" -eq "0" ]; then FILE_MOVED="$((FILE_MOVED + 1))"; fi
elif [ -f /tmp/usbstatus.png ]; then rm -f /tmp/usbstatus.png
fi
}

Set_Language_CN() {
if [ "$(awk -F'"' '/^LANG=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" != "CN" ]; then
	Check_Directories
	sed -i '/LANG/d' "$UA_DIR/CONFIG" 2>/dev/null
	echo '' >> "$UA_DIR/CONFIG"
	echo 'LANG="CN"' >> "$UA_DIR/CONFIG"
	sed -i '/^$/d' "$UA_DIR/CONFIG"
	chmod 644 $UA_DIR/CONFIG
fi
LANG="CN"
}

Set_Language_EN() {
if [ "$(awk -F'"' '/^LANG=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" != "EN" ]; then
	Check_Directories
	sed -i '/LANG/d' "$UA_DIR/CONFIG" 2>/dev/null
	echo '' >> "$UA_DIR/CONFIG"
	echo 'LANG="EN"' >> "$UA_DIR/CONFIG"
	sed -i '/^$/d' "$UA_DIR/CONFIG"
	chmod 644 $UA_DIR/CONFIG
fi
LANG="EN"
}

Enable() {
SC_ENABLE="0"
# Status code of enable: "0" succeeded, "0-99" failed, "100" already enabled, "1000" unsupported firmware.

Check_Firmware
Check_Directories

if [ "$RELEASE_TYPE" = "stable" ]; then
	if [ "$(awk -F'"' '/^AUTO_UPDATE=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" = "1" ] && [ "$(awk -F'"' '/^AUTO_UPDATE_BY_USER=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" = "1" ]; then
		KEEP_UPDATE="1"
	elif [ "$(awk -F'"' '/^AUTO_UPDATE=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" = "1" ] && [ "$(awk -F'"' '/^AUTO_UPDATE_BY_USER=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" != "1" ]; then
		Disable_Auto_Update
	fi
elif [ -z "$(awk -F'"' '/^AUTO_UPDATE=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" ] || [ "$(awk -F'"' '/^AUTO_UPDATE=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" = "1" ]; then
	KEEP_UPDATE="1"
fi

if [ "$FWTYPE" = "380M" ] || [ "$FWTYPE" = "384M" ]; then
	if [ "$(awk -F'"' '/^ENABLE_MODE=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" = "S" ]; then
		Disable_Stock
	fi
	Check_JFFS
	Enable_Merlin
elif [ "$FWTYPE" = "380S" ] || [ "$FWTYPE" = "384S" ]; then
	if [ "$(awk -F'"' '/^ENABLE_MODE=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" = "M" ]; then
		Disable_Merlin
	fi
	Enable_Stock
else
	SC_ENABLE="1000"
fi

if [ "$(awk -F'"' '/^USB_MODE=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" = "3_0" ] && [ "$(nvram get usb_usb3)" = "0" ]; then
	Check_USB_Mode
fi

if [ "$SC_ENABLE" -gt "0" ]; then
	if [ "$SC_ENABLE" -le "99" ]; then
		SC_GLOBAL="4"
	fi
	if [ "$SC_ENABLE" -eq "100" ]; then
		SC_GLOBAL="5"
	fi
	if [ "$SC_ENABLE" -eq "1000" ]; then
		SC_GLOBAL="3"
	fi
fi

if [ "$SC_ENABLE" -eq "0" ] || [ "$SC_ENABLE" -eq "100" ]; then
	if [ "$(awk -F'"' '/^ENABLE_STATUS=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" != "1" ]; then
		sed -i '/ENABLE_STATUS/d' "$UA_DIR/CONFIG" 2>/dev/null
		echo '' >> "$UA_DIR/CONFIG"
		echo 'ENABLE_STATUS="1"' >> "$UA_DIR/CONFIG"
		sed -i '/^$/d' "$UA_DIR/CONFIG"
		chmod 644 $UA_DIR/CONFIG
	fi
fi

if [ "$QUIET" != "1" ]; then
	Enable_Notifications
fi

FORCE="0"
}

Enable_Merlin() {
if [ -f $S_DIR/smb.postconf ]; then
	if [ "$(grep -ci accelerator $S_DIR/smb.postconf 2>/dev/null)" != "0" ]; then
		if [ "$(grep -c "USB_Accelerator_v$VERSION" $S_DIR/smb.postconf 2>/dev/null)" != "1" ]; then
			sed -i '/socket options/d;/deadtime/d;/strict locking/d' "$S_DIR/smb.postconf"
			sed -i '/[aA]ccelerator/d' "$S_DIR/smb.postconf"
			sed -i '/sleep 10/d' "$S_DIR/smb.postconf"
			sed -i '/^$/d' "$S_DIR/smb.postconf"
		else
			dontchange_smbpostconf="1"
		fi
	fi
	if [ "$dontchange_smbpostconf" != "1" ]; then
		if [ "$(grep -vc '#' "$S_DIR/smb.postconf")" -le "1" ] && [ "$(grep -vc 'CONFIG=$1' "$S_DIR/smb.postconf")" -le "1" ]; then
			rm -f $S_DIR/smb.postconf
		elif [ ! -s $S_DIR/smb.postconf.old ]; then
			mv -f $S_DIR/smb.postconf $S_DIR/smb.postconf.old && chmod 644 $S_DIR/smb.postconf.old
			bak_smbpostconf="1"
		elif [ -s $S_DIR/smb.postconf.old ]; then
			grep -vf $S_DIR/smb.postconf.old $S_DIR/smb.postconf >> $S_DIR/smb.postconf.old && chmod 644 $S_DIR/smb.postconf.old
			rm -f $S_DIR/smb.postconf
			bak_smbpostconf="1"
		fi
		FORCE_ENABLE="1"
	fi
fi

if [ ! -f $S_DIR/smb.postconf ] || [ "$FORCE" = "1" ] || [ "$FORCE_ENABLE" = "1" ]; then
	FORCE_ENABLE="0"
	echo '#!/bin/sh' > $S_DIR/smb.postconf
	echo "# USB_Accelerator_v$VERSION" >> $S_DIR/smb.postconf
	echo 'CONFIG=$1' >> $S_DIR/smb.postconf
	echo 'sed -i "/deadtime/d;/strict locking/d;/[aA]ccelerator/d" "$CONFIG"' >> $S_DIR/smb.postconf
	echo 'sed -i "/global/a\deadtime = 10" "$CONFIG"' >> $S_DIR/smb.postconf
	echo 'sed -i "/global/a\strict locking = no" "$CONFIG"' >> $S_DIR/smb.postconf
	echo 'sed -i "s/socket options.*/socket options = IPTOS_LOWDELAY TCP_NODELAY SO_KEEPALIVE/g" "$CONFIG"' >> $S_DIR/smb.postconf
	echo "echo '# USB_Accelerator_v$VERSION'"' >> "$CONFIG"' >> $S_DIR/smb.postconf
	echo "sh $UA_DIR/usbaccelerator.sh --enable" >> $S_DIR/smb.postconf
	if [ "$KEEP_UPDATE" = "1" ]; then
		Enable_Auto_Update
		KEEP_UPDATE="0"
	fi
	if [ "$bak_smbpostconf" = "1" ]; then
		grep -v '#' $S_DIR/smb.postconf.old | sed '/CONFIG=$1/d;/socket options/d;/deadtime/d;/strict locking/d;/[aA]ccelerator/d;/^$/d' >> $S_DIR/smb.postconf
	fi
	chmod 755 $S_DIR/smb.postconf
	service restart_nasapps >/dev/null 2>&1
fi

if [ "$(grep -i "USB_Accelerator_v$VERSION" /etc/smb.conf 2>/dev/null | wc -l)" -eq "0" ]; then
	ck_smbd="0"
	while [ "$(ps 2>/dev/null | grep smbd | grep -vc grep)" -eq "0" ] && [ "$ck_smbd" -lt "5" ]; do
		ck_smbd="$((ck_smbd + 1))"
		sleep 1
	done
	ck_smbconf_2="0"
	while [ "$(grep -i "USB_Accelerator_v$VERSION" /etc/smb.conf 2>/dev/null | wc -l)" -eq "0" ] && [ "$ck_smbconf_2" -lt "5" ]; do
		ck_smbconf_2="$((ck_smbconf_2 + 1))"
		sleep 1
	done
	if [ "$(ps 2>/dev/null | grep smbd | grep -vc grep)" -gt "0" ] && [ "$(grep -i "USB_Accelerator_v$VERSION" /etc/smb.conf 2>/dev/null | wc -l)" -eq "0" ]; then
		SC_ENABLE="$((SC_ENABLE + 1))"
	fi
elif [ "$(grep -i "USB_Accelerator_v$VERSION" /etc/smb.conf 2>/dev/null | wc -l)" -gt "0" ]; then
	SC_ENABLE="100"
fi

if [ "$(awk -F'"' '/^ENABLE_MODE=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" != "M" ]; then
	sed -i '/ENABLE_MODE/d' "$UA_DIR/CONFIG" 2>/dev/null
	echo '' >> "$UA_DIR/CONFIG"
	echo 'ENABLE_MODE="M"' >> "$UA_DIR/CONFIG"
	sed -i '/^$/d' "$UA_DIR/CONFIG"
	chmod 644 $UA_DIR/CONFIG
fi
}

Enable_Stock() {
ck_smbd="0"
while [ "$(ps 2>/dev/null | grep smbd | grep -vc grep)" -eq "0" ] && [ "$ck_smbd" -lt "5" ]; do
	ck_smbd="$((ck_smbd + 1))"
	sleep 1
done

if [ "$(grep -i "USB_Accelerator_v$VERSION" /etc/smb.conf 2>/dev/null | wc -l)" -eq "0" ] || [ "$FORCE" = "1" ]; then
	ck_smbconf_1="0"
	while [ ! -s /etc/smb.conf ] && [ "$ck_smbconf_1" -lt "5" ]; do
		ck_smbconf_1="$((ck_smbconf_1 + 1))"
		sleep 1
	done
	if [ -s /etc/smb.conf ]; then
		sed -i '/deadtime/d;/strict locking/d' "/etc/smb.conf" 2>/dev/null
		sed -i '/[aA]ccelerator/d' "/etc/smb.conf" 2>/dev/null
		sed -i 's/socket options.*/socket options = IPTOS_LOWDELAY TCP_NODELAY SO_KEEPALIVE/g' "/etc/smb.conf" 2>/dev/null
		sed -i '/global/a\deadtime = 10' "/etc/smb.conf" 2>/dev/null
		sed -i '/global/a\strict locking = no' "/etc/smb.conf" 2>/dev/null
		echo "# USB_Accelerator_v$VERSION" >> /etc/smb.conf
		if [ "$(ps 2>/dev/null | grep smbd | grep -vc grep)" -gt "0" ]; then
			killall -q smbd
			killall -q nmbd
			nmbd -D -s /etc/smb.conf 2>/dev/null
			/usr/sbin/smbd -D -s /etc/smb.conf 2>/dev/null
		fi
		if [ "$(ps 2>/dev/null | grep smbd | grep -vc grep)" -gt "0" ] && [ "$(grep -i "USB_Accelerator_v$VERSION" /etc/smb.conf 2>/dev/null | wc -l)" -eq "0" ]; then
			SC_ENABLE="$((SC_ENABLE + 1))"
		fi
	fi
elif [ "$(grep -i "USB_Accelerator_v$VERSION" /etc/smb.conf 2>/dev/null | wc -l)" -gt "0" ]; then
	SC_ENABLE="100"
fi

if [ ! -f $S_DIR/post-mount ] || [ "$(grep -i "USB_Accelerator_v$VERSION" $S_DIR/post-mount 2>/dev/null | wc -l)" -eq "0" ] || [ "$(grep -i "sh $UA_DIR/usbaccelerator.sh --enable" $S_DIR/post-mount 2>/dev/null | wc -l)" -eq "0" ] || [ "$FORCE" = "1" ]; then
	if [ -f $S_DIR/post-mount ]; then
		sed -i '/[aA]ccelerator/d' "$S_DIR/post-mount" 2>/dev/null
		sed -i '/^$/d' "$S_DIR/post-mount" 2>/dev/null
		if [ "$(wc -l "$S_DIR/post-mount" 2>/dev/null | awk '{print $1}')" -le "1" ] || [ "$(grep -vc '#' "$S_DIR/post-mount")" -eq "0" ]; then
			rm -f $S_DIR/post-mount
		else
			mv -f $S_DIR/post-mount	$S_DIR/post-mount.old && chmod 644 $S_DIR/post-mount.old
			bak_postmount="1"
		fi
	fi
	echo '#!/bin/sh' > $S_DIR/post-mount
	echo "# USB_Accelerator_v$VERSION" >> $S_DIR/post-mount
	echo "sh $UA_DIR/usbaccelerator.sh --enable" >> $S_DIR/post-mount
	if [ "$KEEP_UPDATE" = "1" ]; then
		Enable_Auto_Update
		KEEP_UPDATE="0"
	fi
	if [ -n "$(nvram get script_usbmount 2>/dev/null)" ] && [ "$(nvram get script_usbmount)" != "$S_DIR/post-mount" ] && [ "$(nvram get script_usbmount)" != "/jffs/post-mount" ]; then
		echo "$(nvram get script_usbmount)" >> $S_DIR/post-mount
	else
		Check_Mount_Script
	fi
	if [ "$bak_postmount" = "1" ] && [ -s $S_DIR/post-mount.old ]; then
		grep -v '#' $S_DIR/post-mount.old | sed '/^$/d' >> $S_DIR/post-mount
	fi
	chmod 755 $S_DIR/post-mount
	nvram set script_usbmount="$S_DIR/post-mount"
	nvram commit
fi

if [ "$(awk -F'"' '/^ENABLE_MODE=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" != "S" ]; then
	sed -i '/ENABLE_MODE/d' "$UA_DIR/CONFIG" 2>/dev/null
	echo '' >> "$UA_DIR/CONFIG"
	echo 'ENABLE_MODE="S"' >> "$UA_DIR/CONFIG"
	sed -i '/^$/d' "$UA_DIR/CONFIG"
	chmod 644 $UA_DIR/CONFIG
fi
}

Enable_Notifications() {
if [ "$SC_ENABLE" -eq "0" ] || [ "$SC_ENABLE" -eq "100" ]; then
	if [ "$(df -h | grep -c 'usbstatus.png')" = "0" ] && [ -s $UA_DIR/usbstatus.png ]; then
		if [ ! -d /tmp/usbaccelerator ]; then
			mkdir -m 755 /tmp/usbaccelerator
		fi
		if [ ! -s /tmp/usbaccelerator/usbstatus.png ]; then
			cp -f $UA_DIR/usbstatus.png /tmp/usbaccelerator/usbstatus.png && chmod 644 /tmp/usbaccelerator/usbstatus.png
		fi
		mount --bind /tmp/usbaccelerator/usbstatus.png /www/images/New_ui/usbstatus.png
	fi
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		logger -t "USB加速器" "USB加速器v$VERSION成功开启 (状态码:$SC_ENABLE-$SC_GLOBAL)"
		logger -t "USB加速器" "如果你需要管理USB加速器，请在SSH中输入下方内容:"
		logger -t "USB加速器" "sh $UA_DIR/usbaccelerator.sh"
	else
		logger -t "USB Accelerator" "USB Accelerator v$VERSION starts successfully (Status Code:$SC_ENABLE-$SC_GLOBAL)"
		logger -t "USB Accelerator" "If you want to control the USB Accelerator, enter below in SSH:"
		logger -t "USB Accelerator" "sh $UA_DIR/usbaccelerator.sh"
	fi
fi

if [ "$SC_ENABLE" -gt "0" ] && [ "$SC_ENABLE" -lt "100" ]; then
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		logger -st "USB加速器" "USB加速器开启失败 :("
		logger -st "USB加速器" "你可以向开发人员反馈此代码以帮助解决这个错误:"
		logger -st "USB加速器" "ERROR:$R_M-$FWVER-$VERSION-$SC_ENABLE-$SC_GLOBAL"
		logger -t "USB加速器" "如果你需要管理USB加速器，请在SSH中输入下方内容:"
		logger -t "USB加速器" "sh $UA_DIR/usbaccelerator.sh"
	else
		logger -st "USB Accelerator" "It looks like the USB Accelerator failed to start :("
		logger -st "USB Accelerator" "Please report this code to the developer for help resolve this issue:"
		logger -st "USB Accelerator" "ERROR:$R_M-$FWVER-$VERSION-$SC_ENABLE-$SC_GLOBAL"
		logger -t "USB Accelerator" "If you want to control the USB Accelerator, enter below in SSH:"
		logger -t "USB Accelerator" "sh $UA_DIR/usbaccelerator.sh"
	fi
fi

if [ "$SC_ENABLE" -eq "1000" ]; then
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		logger -st "USB加速器" "USB加速器不支持你的固件 (状态码:$SC_ENABLE-$SC_GLOBAL)"
	else
		logger -st "USB Accelerator" "The USB accelerator does not yet support your firmware (Status Code:$SC_ENABLE-$SC_GLOBAL)"
	fi
fi
}

Disable() {
SC_DISABLE="0"
# Status code of disable: "0" succeeded, "0-99" failed, "100" already disabled, "1000" unsupported firmware.

Check_Firmware
Check_Directories

if [ "$(awk -F'"' '/^AUTO_UPDATE=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" = "1" ]; then
	KEEP_UPDATE="1"
fi

if [ "$FWTYPE" = "380M" ] || [ "$FWTYPE" = "384M" ]; then
	Disable_Merlin
	if [ "$(grep -i "USB_Accelerator" $S_DIR/post-mount 2>/dev/null | wc -l)" -gt "0" ]; then
		Disable_Stock
	fi
elif [ "$FWTYPE" = "380S" ] || [ "$FWTYPE" = "384S" ]; then
	Disable_Stock
	if [ "$(grep -i "USB_Accelerator" $S_DIR/smb.postconf 2>/dev/null | wc -l)" -gt "0" ]; then
		Disable_Merlin
	fi
else
	SC_DISABLE="1000"
fi

if [ "$SC_DISABLE" -gt "0" ]; then
	if [ "$SC_DISABLE" -le "99" ]; then
		SC_GLOBAL="6"
	fi
	if [ "$SC_DISABLE" -eq "100" ]; then
		SC_GLOBAL="7"
	fi
	if [ "$SC_DISABLE" -eq "1000" ]; then
		SC_GLOBAL="3"
	fi
fi

if [ "$(awk -F'"' '/^ENABLE_STATUS=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" != "0" ]; then
	sed -i '/ENABLE_STATUS/d' "$UA_DIR/CONFIG" 2>/dev/null
	echo '' >> "$UA_DIR/CONFIG"
	echo 'ENABLE_STATUS="0"' >> "$UA_DIR/CONFIG"
	sed -i '/^$/d' "$UA_DIR/CONFIG"
	chmod 644 $UA_DIR/CONFIG
fi

if [ "$QUIET" != "1" ]; then
	if [ "$SC_DISABLE" -eq "0" ] || [ "$SC_DISABLE" -eq "100" ]; then
		if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
			logger -t "USB加速器" "USB加速器v$VERSION已关闭 (状态码:$SC_DISABLE-$SC_GLOBAL)"
			logger -t "USB加速器" "如果你需要重新开启USB加速器，请在SSH中输入下方内容:"
			logger -t "USB加速器" "sh $UA_DIR/usbaccelerator.sh"
		else
			logger -t "USB Accelerator" "USB Accelerator v$VERSION disabled successfully (Status Code:$SC_DISABLE-$SC_GLOBAL)"
			logger -t "USB Accelerator" "If you want to re-enable the USB Accelerator, enter below in SSH:"
			logger -t "USB Accelerator" "sh $UA_DIR/usbaccelerator.sh"
		fi
	fi
	if [ "$SC_DISABLE" -gt "0" ] && [ "$SC_DISABLE" -lt "100" ]; then
		if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
			logger -st "USB加速器" "USB加速器关闭失败"
			logger -st "USB加速器" "你可以向开发人员反馈此代码以帮助解决这个错误:"
			logger -st "USB加速器" "ERROR:$R_M-$FWVER-$VERSION-$SC_DISABLE-$SC_GLOBAL"
			logger -t "USB加速器" "如果你需要管理USB加速器，请在SSH中输入下方内容:"
			logger -t "USB加速器" "sh $UA_DIR/usbaccelerator.sh"
		else
			logger -st "USB Accelerator" "Disable the USB Accelerator failed :("
			logger -st "USB Accelerator" "Please report this code to the developer for help resolve this issue:"
			logger -st "USB Accelerator" "ERROR:$R_M-$FWVER-$VERSION-$SC_DISABLE-$SC_GLOBAL"
			logger -t "USB Accelerator" "If you want to control the USB Accelerator, enter below in SSH:"
			logger -t "USB Accelerator" "sh $UA_DIR/usbaccelerator.sh"
		fi
	fi
	if [ "$SC_DISABLE" -eq "1000" ]; then
		if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
			logger -st "USB加速器" "USB加速器不支持你的固件 (状态码:$SC_DISABLE-$SC_GLOBAL)"
		else
			logger -st "USB Accelerator" "The USB accelerator does not yet support your firmware (Status Code:$SC_DISABLE-$SC_GLOBAL)"
		fi
	fi
fi
KEEP_UPDATE="0"
FORCE="0"
}

Disable_Merlin() {
if [ -f $S_DIR/smb.postconf ] && [ "$(grep -i "USB_Accelerator" $S_DIR/smb.postconf 2>/dev/null | wc -l)" -gt "0" ] || [ "$FORCE" = "1" ]; then
	sed -i '/socket options/d;/deadtime/d;/strict locking/d' "$S_DIR/smb.postconf" 2>/dev/null
	sed -i '/[aA]ccelerator/d' "$S_DIR/smb.postconf" 2>/dev/null
	sed -i '/^$/d' "$S_DIR/smb.postconf" 2>/dev/null
	if [ "$KEEP_UPDATE" = "1" ]; then
		Enable_Auto_Update
	fi
	if [ -f $S_DIR/smb.postconf ]; then
		if [ "$(grep -vc '#' "$S_DIR/smb.postconf")" -le "1" ] && [ "$(grep -vc 'CONFIG=$1' "$S_DIR/smb.postconf")" -le "1" ]; then
			rm -f $S_DIR/smb.postconf
		fi
	fi
	if [ "$(df -h | grep -c 'usbstatus.png')" -gt "0" ]; then
		umount -f /www/images/New_ui/usbstatus.png 2>/dev/null
		rm -rf "/tmp/usbaccelerator"
	fi
	service restart_nasapps >/dev/null 2>&1
	if [ "$KEEP_UPDATE" != "1" ] && [ "$(grep -i "USB_Accelerator" $S_DIR/smb.postconf 2>/dev/null | wc -l)" -gt "0" ]; then
		SC_DISABLE="$((SC_DISABLE + 1))"
	fi
else
	SC_DISABLE="100"
fi
}

Disable_Stock() {
if [ -f $S_DIR/post-mount ] && [ "$(grep -i "USB_Accelerator" $S_DIR/post-mount 2>/dev/null | wc -l)" -gt "0" ] || [ "$FORCE" = "1" ]; then
	sed -i '/[aA]ccelerator/d' "$S_DIR/post-mount" 2>/dev/null
	sed -i '/^$/d' "$S_DIR/post-mount" 2>/dev/null
	if [ "$KEEP_UPDATE" = "1" ]; then
		Enable_Auto_Update
	fi
	if [ -f $S_DIR/post-mount ]; then
		if [ "$(wc -l "$S_DIR/post-mount" 2>/dev/null | awk '{print $1}')" -le "1" ] || [ "$(grep -vc '#' "$S_DIR/post-mount")" -eq "0" ]; then
			rm -f $S_DIR/post-mount
			nvram set script_usbmount=""
			nvram commit
		fi
	fi
	if [ "$(df -h | grep -c 'usbstatus.png')" -gt "0" ]; then
		umount -f /www/images/New_ui/usbstatus.png 2>/dev/null
		rm -rf "/tmp/usbaccelerator"
	fi
	service restart_nasapps >/dev/null 2>&1
	if [ "$KEEP_UPDATE" != "1" ] && [ "$(grep -i "USB_Accelerator" $S_DIR/post-mount 2>/dev/null | wc -l)" -gt "0" ]; then
		SC_DISABLE="$((SC_DISABLE + 1))"
	fi
else
	SC_DISABLE="100"
fi
}

Uninstall() {
SC_UNINSTALL="0"
# Status code of uninstall: "0" succeeded, "1" failed.

if [ "$(df -h | grep -c 'usbstatus.png')" -gt "0" ]; then
	umount -f /www/images/New_ui/usbstatus.png 2>/dev/null
fi

if [ -f $S_DIR/smb.postconf ]; then
	sed -i '0,/CONFIG/{//d;}' "$S_DIR/smb.postconf" 2>/dev/null
	sed -i '/socket options/d;/deadtime/d;/strict locking/d' "$S_DIR/smb.postconf" 2>/dev/null
	sed -i '/[aA]ccelerator/d' "$S_DIR/smb.postconf" 2>/dev/null
	sed -i '/^$/d' "$S_DIR/smb.postconf" 2>/dev/null
	if [ "$(grep -vc '#' "$S_DIR/smb.postconf")" -le "1" ] && [ "$(grep -vc 'CONFIG=$1' "$S_DIR/smb.postconf")" -le "1" ]; then
		rm -f $S_DIR/smb.postconf
	fi
	if [ "$(awk -F'"' '/^ENABLE_JFFS_SCRIPTS=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" = "1" ]; then
		nvram set jffs2_scripts="0"
		nvram commit
	fi
fi

if [ -f $S_DIR/post-mount ]; then
	sed -i '/[aA]ccelerator/d' "$S_DIR/post-mount" 2>/dev/null
	sed -i '/^$/d' "$S_DIR/post-mount" 2>/dev/null
	if [ "$(wc -l "$S_DIR/post-mount" 2>/dev/null | awk '{print $1}')" -le "1" ] || [ "$(grep -vc '#' "$S_DIR/post-mount" 2>/dev/null )" -eq "0" ]; then
		rm -f $S_DIR/post-mount
	fi
	if [ "$(awk -F'"' '/^ENABLE_MOUNT_SCRIPTS=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" = "1" ]; then
		nvram set script_usbmount=""
		nvram commit
	fi
elif [ "$(nvram get script_usbmount 2>/dev/null | grep -c post-mount)" -gt "0" ]; then
	nvram set script_usbmount=""
	nvram commit
fi

if [ "$(cru l 2>/dev/null | grep -c 'USB_Accelerator_AutoUpdate')" -gt "0" ]; then
	cru d USB_Accelerator_AutoUpdate 2>/dev/null
fi

if [ -f /jffs/post-mount ] || [ -f $S_DIR/usbaccelerator.sh ] || [ -f $S_DIR/usbstatus.png ] || [ -f $S_DIR/sfsmb ]; then
	rm -f $S_DIR/usbstatus.png $S_DIR/sfsmb /jffs/post-mount $S_DIR/usbaccelerator.sh
fi

if [ -d "$UA_DIR" ] || [ "$FORCE" = "1" ]; then
	if [ -d "/tmp/usbaccelerator" ] || [ "$FORCE" = "1" ]; then
		rm -rf "/tmp/usbaccelerator"
	fi
	rm -f "$UA_DIR/usbstatus.png" "$UA_DIR/CONFIG" "$UA_DIR/usbaccelerator.sh"
	rm -rf "$UA_DIR" 2>/dev/null
	Check_Firmware
	if [ "$(ls -A $ADD_DIR 2>/dev/null | wc -l)" = "0" ] && [ "$FWTYPE" != "384M" ]; then
		rm -rf "$ADD_DIR" 2>/dev/null
	fi
	service restart_nasapps >/dev/null 2>&1
fi

TMP_CLEARED="0"
if [ "$CUR_DIR" = "/tmp" ] && [ -f /tmp/$S_NAME ]; then
	rm -f "$CUR_DIR/usbstatus.png"
	rm -f "$CUR_DIR/$S_NAME"
	if [ ! -f /tmp/$S_NAME ]; then TMP_CLEARED="$((TMP_CLEARED + 1))"; fi
fi

if [ -f $UA_DIR/usbstatus.png ]; then
	SC_UNINSTALL="$((SC_UNINSTALL + 1))"
fi
if [ -f $UA_DIR/CONFIG ]; then
	SC_UNINSTALL="$((SC_UNINSTALL + 1))"
fi
if [ -f $UA_DIR/usbaccelerator.sh ]; then
	SC_UNINSTALL="$((SC_UNINSTALL + 1))"
fi
if [ -d "$UA_DIR" ]; then
	SC_UNINSTALL="$((SC_UNINSTALL + 1))"
fi

if [ "$SC_UNINSTALL" -gt "0" ]; then
	SC_GLOBAL="8"
fi

if [ -f $S_DIR/smb.postconf.old ] && [ ! -f $S_DIR/smb.postconf ]; then
	mv -f $S_DIR/smb.postconf.old $S_DIR/smb.postconf && chmod 755 $S_DIR/smb.postconf
fi

if [ -f $S_DIR/post-mount.old ] && [ ! -f $S_DIR/post-mount ]; then
	mv -f $S_DIR/post-mount.old $S_DIR/post-mount && chmod 755 $S_DIR/post-mount
fi

if [ "$QUIET" != "1" ]; then
	if [ "$SC_UNINSTALL" -eq "0" ]; then
		if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
			logger -t "USB加速器" "USB加速器已经卸载，感谢你的使用"
		else
			logger -t "USB Accelerator" "the USB Accelerator has been uninstalled"
		fi
	elif [ "$SC_UNINSTALL" -gt "0" ]; then
		if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
			logger -t "USB加速器" "USB加速器已经卸载，但可能有残留文件或目录因占用无法删除 (状态码:$SC_UNINSTALL-$SC_GLOBAL)"
		else
			logger -t "USB Accelerator" "the USB Accelerator has been uninstalled (Status Code:$SC_UNINSTALL-$SC_GLOBAL)"
			logger -t "USB Accelerator" "but some files or directory may cannot be removed"
		fi
	fi
fi
}

Reinstall() {
SC_REINSTALL="0"
# Status code of re-install: "0" succeeded, "1-99" failed, "100" no internet connection, "1000" download failed.

Check_Network
if [ "$SC_NETWORK" -eq "0" ] || [ "$FORCE" = "1" ]; then
	if [ -s $UA_DIR/CONFIG ] && [ "$CLEAN_INSTALL" = "1" ]; then
		if [ "$(awk -F'"' '/^ENABLE_JFFS_SCRIPTS=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" = "1" ]; then
			nvram set jffs2_scripts="0"
			nvram commit
		fi
		if [ "$(awk -F'"' '/^ENABLE_MOUNT_SCRIPTS=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" = "1" ]; then
			nvram set script_usbmount=""
			nvram commit
		fi
	fi
	if [ -s $UA_DIR/CONFIG ] && [ "$CLEAN_INSTALL" != "1" ]; then
		if [ "$(awk -F'"' '/^ENABLE_STATUS=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" = "1" ]; then
			need_to_reenable="1"
		fi
		cp -f $UA_DIR/CONFIG /tmp/UA.CONFIG.BAK
		chmod 644 /tmp/UA.CONFIG.BAK
	fi
	Download_Files
	if [ "$SC_DOWNLOAD" -eq "0" ]; then
		Uninstall
		Move_Files
		if [ -s /tmp/UA.CONFIG.BAK ]; then
			mv -f /tmp/UA.CONFIG.BAK $UA_DIR/CONFIG
			chmod 644 $UA_DIR/CONFIG
		fi
	else
		if [ -s /tmp/UA.CONFIG.BAK ]; then
			rm -f /tmp/UA.CONFIG.BAK
		fi
		SC_REINSTALL="1000"
	fi
	if [ ! -f $UA_DIR/usbstatus.png ] || [ ! -f $UA_DIR/usbaccelerator.sh ]; then
		SC_REINSTALL="$((SC_REINSTALL + 1))"
	fi
else
	SC_REINSTALL="100"
fi

if [ "$SC_REINSTALL" -eq "100" ]; then
	SC_GLOBAL="10"
elif [ "$SC_REINSTALL" -eq "1000" ]; then
	SC_GLOBAL="11"
elif [ "$SC_REINSTALL" -gt "0" ] && [ "$SC_REINSTALL" -lt "100" ]; then
	SC_GLOBAL="9"
fi

if [ "$QUIET" != "1" ]; then
	if [ "$SC_REINSTALL" -eq "0" ]; then
		if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
			logger -t "USB加速器" "USB加速器v$VERSION已成功重新安装 (状态码:$SC_REINSTALL-$SC_GLOBAL)"
			logger -t "USB加速器" "如果你需要管理USB加速器，请在SSH中输入下方内容:"
			logger -t "USB加速器" "sh $UA_DIR/usbaccelerator.sh"
		else
			logger -t "USB Accelerator" "USB Accelerator v$VERSION has been reinstalled (Status Code:$SC_REINSTALL-$SC_GLOBAL)"
			logger -t "USB Accelerator" "If you want to control the USB Accelerator, enter below in SSH:"
			logger -t "USB Accelerator" "sh $UA_DIR/usbaccelerator.sh"
		fi
	fi
	if [ "$SC_REINSTALL" -eq "100" ]; then
		if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
			ERROR_NETWORK="1"
			ERROR_SOURCE="重装"
			Error_Notifications
			logger -st "USB加速器" "ERROR:$R_M-$FWVER-$VERSION-$SC_NETWORK-$SC_REINSTALL-$SC_GLOBAL"
			logger -t "USB加速器" "如果你需要管理USB加速器，请在SSH中输入下方内容:"
			logger -t "USB加速器" "sh $UA_DIR/usbaccelerator.sh"
		else
			ERROR_NETWORK="1"
			ERROR_SOURCE="Reinstall"
			Error_Notifications
			logger -st "USB Accelerator" "ERROR:$R_M-$FWVER-$VERSION-$SC_NETWORK-$SC_REINSTALL-$SC_GLOBAL"
			logger -t "USB Accelerator" "If you want to control the USB Accelerator, enter below in SSH:"
			logger -t "USB Accelerator" "sh $UA_DIR/usbaccelerator.sh"
		fi
	fi
	if [ "$SC_REINSTALL" -eq "1000" ]; then
		if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
			ERROR_DOWNLOAD="1"
			ERROR_SOURCE="重装"
			Error_Notifications
			logger -st "USB加速器" "ERROR:$R_M-$FWVER-$VERSION-$SC_DOWNLOAD-$SC_REINSTALL-$SC_GLOBAL"
			logger -t "USB加速器" "如果你需要管理USB加速器，请在SSH中输入下方内容:"
			logger -t "USB加速器" "sh $UA_DIR/usbaccelerator.sh"
		else
			ERROR_DOWNLOAD="1"
			ERROR_SOURCE="Reinstall"
			Error_Notifications
			logger -st "USB Accelerator" "ERROR:$R_M-$FWVER-$VERSION-$SC_DOWNLOAD-$SC_REINSTALL-$SC_GLOBAL"
			logger -t "USB Accelerator" "If you want to control the USB Accelerator, enter below in SSH:"
			logger -t "USB Accelerator" "sh $UA_DIR/usbaccelerator.sh"
		fi
	fi
fi

if [ "$TRIG_RI_BY_USER" != "1" ] && [ "$need_to_reenable" = "1" ] && [ "$SC_REINSTALL" -eq "0" ]; then
	sh $UA_DIR/usbaccelerator.sh --enable; exit "$?"
elif [ "$TRIG_RI_BY_USER" = "1" ] && [ "$SC_REINSTALL" -eq "0" ]; then
	if [ "$need_to_reenable" = "1" ]; then
		sed -i '/ENABLE_STATUS/d' "$UA_DIR/CONFIG" 2>/dev/null
	fi
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		printf 'USB加速器已成功重新安装，正在重新载入...\n'
	else
		printf 'USB Accelerator reinstalled successfully, reloading...\n'
	fi
	sh $UA_DIR/usbaccelerator.sh; exit "$?"
fi
}

Update() {
SC_UPDATE="0"
# Status code of update: "0" no updates available, "1" update completed, "2" no internet connection, "3" file download failed, "4" file missing.

if [ -z "$SRC" ] && [ "$TRIG_UPD_BY_USER" = "1" ]; then
	Set_Source_UI
fi

updnum="0"
while [ "$updnum" -lt "3" ]; do
	if [ "$TRIG_UPD_BY_USER" = "1" ] || [ "$FORCE" = "1" ]; then
		TRIG_CKNT_BY_USER="1"
	fi
	Check_Network
	if [ "$SC_NETWORK" -eq "0" ]; then
		Download_Files
		if [ "$SC_DOWNLOAD" -eq "0" ]; then
			if [ "$FORCE" = "1" ]; then
				Move_Files
				if [ "$FILE_MOVED" -gt "0" ]; then
					SC_UPDATE="1"
					updnum="100"
				else
					SC_UPDATE="4"
					updnum="$((updnum + 1))"
				fi
			else
				Check_Hash
				if [ "$SC_HASH" -eq "0" ]; then
					SC_UPDATE="0"
					updnum="100"
				elif [ "$FILE_MOVED" -gt "0" ]; then
					SC_UPDATE="1"
					updnum="100"
				else
					SC_UPDATE="4"
					updnum="$((updnum + 1))"
				fi
			fi
		else
			SC_UPDATE="3"
			updnum="100"
		fi
	else
		SC_UPDATE="2"
		updnum="100"
	fi
done

if [ "$SC_UPDATE" -ne "0" ]; then
	if [ "$SC_UPDATE" -eq "2" ]; then
		SC_GLOBAL="10"
	fi
	if [ "$SC_UPDATE" -eq "3" ]; then
		SC_GLOBAL="11"
	fi
	if [ "$SC_UPDATE" -eq "4" ]; then
		SC_GLOBAL="12"
	fi
fi

if [ "$SC_UPDATE" -eq "1" ]; then
	NEW_VERSION="$(awk -F'"' '/^VERSION=/ {print $2}' $UA_DIR/usbaccelerator.sh 2>/dev/null)"
	Check_Directories
	sed -i '/UPDATE_COMPLETED/d' "$UA_DIR/CONFIG" 2>/dev/null
	echo '' >> "$UA_DIR/CONFIG"
	echo "UPDATE_COMPLETED=\"$TIMESTAMP\"" >> "$UA_DIR/CONFIG"
	sed -i '/^$/d' "$UA_DIR/CONFIG"
	chmod 644 $UA_DIR/CONFIG
	if [ "$(awk -F'"' '/^ENABLE_STATUS=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" = "1" ]; then
		sh $UA_DIR/usbaccelerator.sh --quiet --disable
		sh $UA_DIR/usbaccelerator.sh --enable; SC_GLOBAL="$?"
	fi
fi

if [ "$QUIET" != "1" ]; then
	if [ "$SC_UPDATE" -eq "1" ]; then
		if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
			logger -t "USB加速器" "USB加速器已经成功从v$VERSION更新到v$NEW_VERSION"
			logger -t "USB加速器" "如果你需要管理USB加速器，请在SSH中输入下方内容:"
			logger -t "USB加速器" "sh $UA_DIR/usbaccelerator.sh"
		else
			logger -t "USB Accelerator" "The USB Accelerator has been successfully updated from v$VERSION to v$NEW_VERSION"
			logger -t "USB Accelerator" "If you want to control the USB Accelerator, enter below in SSH:"
			logger -t "USB Accelerator" "sh $UA_DIR/usbaccelerator.sh"
		fi
	fi
	if [ "$SC_UPDATE" -eq "2" ]; then
		if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
			ERROR_NETWORK="1"
			ERROR_SOURCE="更新"
			Error_Notifications
			logger -st "USB加速器" "ERROR:$R_M-$FWVER-$VERSION-$SC_NETWORK-$SC_UPDATE-$SC_GLOBAL"
			logger -t "USB加速器" "如果你需要管理USB加速器，请在SSH中输入下方内容:"
			logger -t "USB加速器" "sh $UA_DIR/usbaccelerator.sh"
		else
			ERROR_NETWORK="1"
			ERROR_SOURCE="Update"
			Error_Notifications
			logger -st "USB Accelerator" "ERROR:$R_M-$FWVER-$VERSION-$SC_NETWORK-$SC_UPDATE-$SC_GLOBAL"
			logger -t "USB Accelerator" "If you want to control the USB Accelerator, enter below in SSH:"
			logger -t "USB Accelerator" "sh $UA_DIR/usbaccelerator.sh"
		fi
	fi
	if [ "$SC_UPDATE" -eq "3" ]; then
		if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
			ERROR_DOWNLOAD="1"
			ERROR_SOURCE="更新"
			Error_Notifications
			logger -st "USB加速器" "ERROR:$R_M-$FWVER-$VERSION-$SC_DOWNLOAD-$SC_UPDATE-$SC_GLOBAL"
			logger -t "USB加速器" "如果你需要管理USB加速器，请在SSH中输入下方内容:"
			logger -t "USB加速器" "sh $UA_DIR/usbaccelerator.sh"
		else
			ERROR_DOWNLOAD="1"
			ERROR_SOURCE="Update"
			Error_Notifications
			logger -st "USB Accelerator" "ERROR:$R_M-$FWVER-$VERSION-$SC_DOWNLOAD-$SC_UPDATE-$SC_GLOBAL"
			logger -t "USB Accelerator" "If you want to control the USB Accelerator, enter below in SSH:"
			logger -t "USB Accelerator" "sh $UA_DIR/usbaccelerator.sh"
		fi
	fi
	if [ "$SC_UPDATE" -eq "4" ]; then
		if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
			logger -st "USB加速器" "更新失败文件丢失"
		else
			logger -st "USB Accelerator" "Update failed, file(s) is missing"
		fi
	fi
fi
}

Enable_Auto_Update() {
minute="$(awk -v min=4 -v max=53 -v freq=1 'BEGIN{"tr -cd 0-9 </dev/urandom | head -c 3" | getline seed; srand(seed); for(i=0;i<freq;i++)print int(min+rand()*(max-min+1))}')"
hour="$(date +%H)"
week="$(date +%w)"

if [ "$(awk -F'"' '/^AUTO_UPDATE=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" != "1" ]; then
	Check_Directories
	sed -i '/AUTO_UPDATE/d' "$UA_DIR/CONFIG" 2>/dev/null
	echo '' >> "$UA_DIR/CONFIG"
	echo 'AUTO_UPDATE="1"' >> "$UA_DIR/CONFIG"
	sed -i '/^$/d' "$UA_DIR/CONFIG"
	chmod 644 $UA_DIR/CONFIG
fi

Check_Firmware
if [ "$FWTYPE" = "380M" ] || [ "$FWTYPE" = "384M" ]; then
	smb_config="$S_DIR/smb.postconf"
fi
if [ "$FWTYPE" = "380S" ] || [ "$FWTYPE" = "384S" ]; then
	smb_config="$S_DIR/post-mount"
fi

if [ "$(grep 'usbaccelerator.sh --update' $smb_config 2>/dev/null | wc -l)" -eq "0" ] || [ "$(grep 'usbaccelerator.sh -u' $smb_config 2>/dev/null | wc -l)" -eq "0" ]; then
	if [ ! -f $smb_config ]; then
		echo '#!/bin/sh' > "$smb_config"
	fi
	echo '' >> "$smb_config"
	if [ "$RELEASE_TYPE" = "stable" ]; then
		echo "cru a USB_Accelerator_AutoUpdate \"$minute $hour * * $week sh $UA_DIR/usbaccelerator.sh --update\"" >> "$smb_config"
	else
		echo "cru a USB_Accelerator_AutoUpdate \"$minute */8 * * * sh $UA_DIR/usbaccelerator.sh --update\"" >> "$smb_config"
	fi
	echo "sh $UA_DIR/usbaccelerator.sh --update" >> "$smb_config"
	sed -i '/^$/d' "$smb_config"
	chmod 755 "$smb_config"
fi

if [ "$(cru l 2>/dev/null | grep -c 'USB_Accelerator_AutoUpdate')" -gt "0" ]; then
	cru d USB_Accelerator_AutoUpdate
fi

if [ "$RELEASE_TYPE" = "stable" ]; then
	cru a USB_Accelerator_AutoUpdate "$minute $hour * * $week sh $UA_DIR/usbaccelerator.sh --update" 2>/dev/null
else
	cru a USB_Accelerator_AutoUpdate "$minute */8 * * * sh $UA_DIR/usbaccelerator.sh --update" 2>/dev/null
fi
}

Disable_Auto_Update() {
if [ "$(awk -F'"' '/^AUTO_UPDATE=/ {print $2}' $UA_DIR/CONFIG 2>/dev/null)" = "1" ]; then
	Check_Directories
	sed -i '/AUTO_UPDATE/d' "$UA_DIR/CONFIG" 2>/dev/null
	echo '' >> "$UA_DIR/CONFIG"
	echo 'AUTO_UPDATE="0"' >> "$UA_DIR/CONFIG"
	sed -i '/^$/d' "$UA_DIR/CONFIG"
	chmod 644 $UA_DIR/CONFIG
fi

Check_Firmware
if [ "$FWTYPE" = "380M" ] || [ "$FWTYPE" = "384M" ]; then
	smb_config="$S_DIR/smb.postconf"
fi
if [ "$FWTYPE" = "380S" ] || [ "$FWTYPE" = "384S" ]; then
	smb_config="$S_DIR/post-mount"
fi

if [ "$(grep 'usbaccelerator.sh --update' $smb_config 2>/dev/null | wc -l)" -gt "0" ] || [ "$(grep 'usbaccelerator.sh -u' $smb_config 2>/dev/null | wc -l)" -gt "0" ]; then
	sed -i '/usbaccelerator.sh --update/d' "$smb_config"
	sed -i '/usbaccelerator.sh -u/d' "$smb_config"
	echo '' >> "$smb_config"
	sed -i '/^$/d' "$smb_config"
	chmod 755 "$smb_config"
fi

if [ "$(cru l 2>/dev/null | grep -c 'USB_Accelerator_AutoUpdate')" -gt "0" ]; then
	cru d USB_Accelerator_AutoUpdate 2>/dev/null
fi
}

Error_Notifications() {
if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
	please_report="你可以向开发人员反馈此代码以帮助解决这个错误:"
else
	please_report="Please report this code to the developer for help resolve the issue:"
fi

if [ "$ERROR_NETWORK" = "1" ]; then
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		logger -st "USB加速器" "$ERROR_SOURCE失败，没有网络连接"
		logger -st "USB加速器" "$please_report"
	else
		logger -st "USB Accelerator" "$ERROR_SOURCE failed, no internet connection"
		logger -st "USB Accelerator" "$please_report"
	fi
	ERROR_NETWORK="0"
fi

if [ "$ERROR_DOWNLOAD" = "1" ]; then
	if [ "$LANG" = "CN" ] || [ "$LANG" = "TW" ]; then
		logger -st "USB加速器" "$ERROR_SOURCE失败，下载文件失败"
		logger -st "USB加速器" "$please_report"
	else
		logger -st "USB Accelerator" "$ERROR_SOURCE failed, files download failed"
		logger -st "USB Accelerator" "$please_report"
	fi
	ERROR_DOWNLOAD="0"
fi
}

Documents() {
HELP_DOCUMENTATION="Usage:
 sh $CUR_DIR/$S_NAME [OPTION]...

Options:
     --clear          Clean up the old version (1.0 and lower)
 -d, --disable        Disable the USB Accelerator
 -e, --enable         Enable the USB Accelerator
 -f, --force          Force to enable, disable or uninstall
     --github         Set the download source to GitHub
     --gitlab         Set the download source to GitLab (backup)
 -h, --help           Display this help and exit
     --help-status    Display help for the exit status
 -q, --quiet          Quiet to enable, disable or update
     --reinstall      Reinstall without user confirmation
     --uninstall      Uninstall without user confirmation
     --shellui        Enter the shell UI
 -u, --update         Update the USB Accelerator
 -v, --version        Output version information and exit

Examples:
 Enable the USB Accelerator:
  sh $CUR_DIR/$S_NAME -e
 Set up the installation source to GitHub and Update:
  sh $CUR_DIR/$S_NAME --github -u

Note:
 ONLY TWO OPTIONS can be run at a time, does not support combined
 options, all options are case sensitive, and without any options
 will enter the shell UI.    The options will be run one by one,
 which means that the result of the first option affects the next
 option, and some options cannot be used as the second option.

Exit Status:
 Please use the '--help-status' option to view.

Read More:
 USB Accelerator $VERSION
 Project home and source code:
  $HOST_HOME_1
 Report issues and bugs:
  $HOST_HOME_1/issues
 Full documentation:
  $HOST_HOME_1/blob/master/README.md
 Full the GPLv3 license:
  $HOST_HOME_1/blob/master/LICENSE
 Want to help translate to local or improve?
 You can pull and push your changes on GitHub!"

EXIT_STATUS="Meaning of exit code in USB Accelerator $VERSION

Exit Codes:
  [0]   =  Run successfully
  [1]   =  Unknown error
  [2]   =  The user did not agree to the license
  [3]   =  Unsupported model or firmware
  [4]   =  Enable failed, please try again
  [5]   =  Already enabled, no need to do it again
  [6]   =  Disable failed, please try again
  [7]   =  Already disabled, no need to do it again
  [8]   =  Uninstall done, but may not completely removed
  [9]   =  Reinstall failed
  [10]  =  No internet connection
  [11]  =  Download failed
  [12]  =  Missing files
  [13]  =  Bad request parameters

Note:
 If there are multiple status,
 the exit code will only return the last one."

VERSION_INFORMATION="$CUR_DIR/$S_NAME $VERSION
Copyleft :-) 2019-2020

This program is a free and open-source software ,   and you can
redistribute it and/or modify it under the terms of the GNU
General Public License version 3 (GPLv3).

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY,  without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

See the GNU General Public License version 3 for more details:
 $HOST_HOME_1/blob/master/LICENSE

Project home and source code:
 $HOST_HOME_1

Written by Jack."

BAD_REQUEST_1="Unknown option: $PARM_1
Try 'sh $CUR_DIR/$S_NAME --help' for more information."

BAD_REQUEST_2="Bad option: $PARM_2
Cannot be used as the second option.
Try 'sh $CUR_DIR/$S_NAME --help' for more information."

BAD_REQUEST_3="Bad option: $PARM_2
The second option is not running, cannot be same as the first.
Try 'sh $CUR_DIR/$S_NAME --help' for more information."

BAD_REQUEST_4="Bad option: $PARM_3
The third option is not running, only TWO options are supported.
Try 'sh $CUR_DIR/$S_NAME --help' for more information."
}

Command_Parameters() {
case "$PARM_1" in
	--clear|-Check|-DLZ|-DL|-SFW)
		Clear_Old
	;;
	-d|--disable)
		Disable
	;;
	-e|--enable)
		Check_Files
		Enable
	;;
	-f|--force)
		FORCE="1"
	;;
	--github)
		Source_GitHub
	;;
	--gitlab)
		Source_GitLab
	;;
	-h|--help)
		Documents
		echo "$HELP_DOCUMENTATION"
	;;
	--help-status)
		Documents
		echo "$EXIT_STATUS"
	;;
	-q|--quiet)
		QUIET="1"
	;;
	--reinstall)
		Reinstall
	;;
	--uninstall)
		Uninstall
	;;
	--shellui)
		if [ -z "$FIRST_TIME" ]; then
			Splash_Page_0
		else
			Check_Source
			if [ "$SC_SETSOURCE" -eq "0" ]; then
				Home
			elif [ "$SC_SETSOURCE" -eq "2" ]; then
				NO_RETURN_SETSRC="1"
				Set_Source_UI
				Home
			else
				Splash_Page_0
			fi
		fi
	;;
	-u|--update)
		Update
	;;
	-v|--version)
		Documents
		echo "$VERSION_INFORMATION"
	;;
	*)
		Documents
		echo "$BAD_REQUEST_1"
		exit 13
	;;
esac

if [ -z "$PARM_2" ]; then
	exit "$SC_GLOBAL"
elif [ "$SC_PARAMETERS" -gt "0" ]; then
	Documents
	echo "$BAD_REQUEST_4"
	exit 13
else
	case "$PARM_2" in
		-f|--force|--github|--gitlab|-h|--help|--help-status|-q|--quiet|-v|--version)
			Documents
			echo "$BAD_REQUEST_2"
			exit 13
		;;
	esac
	if [ "$PARM_1" = "$PARM_2" ]; then
		Documents
		echo "$BAD_REQUEST_3"
		exit 13
	else
		PARM_1="$PARM_2"
		PARM_2="$PARM_3"
	fi
	SC_PARAMETERS="$((SC_PARAMETERS + 1))"
	Command_Parameters
fi
}

if [ -z "$PARM_1" ]; then
	if [ -z "$FIRST_TIME" ]; then
		Splash_Page_0
	else
		Check_Source
		if [ "$SC_SETSOURCE" -eq "0" ]; then
			Home
		elif [ "$SC_SETSOURCE" -eq "2" ]; then
			NO_RETURN_SETSRC="1"
			Set_Source_UI
			Home
		else
			Splash_Page_0
		fi
	fi
else
	SC_PARAMETERS="0"
	Command_Parameters
fi

exit "$SC_GLOBAL"
