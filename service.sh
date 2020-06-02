#!/system/bin/sh
# for call main.sh :v
GetBusyBox="none"
for i in /system/bin /system/xbin /sbin /su/xbin; do
    if [ "$GetBusyBox" == "none" ]; then
        if [ -f $i/busybox ]; then
            GetBusyBox=$i/busybox;
        fi;
        PathBusyBox=$i
    fi;
done;
nohup=nohup
if [ -e "$PathBusyBox/busybox" ];then
    nohup=$PathBusyBox" nohup"
fi
ModulPath=$(cat /system/etc/ZyC_Ai/magisk_path.txt)
if [ ! -z "$1" ];then
    if [ ! -z "$2" ];then
        if [ ! -z "$3" ];then
            if [ ! -z "$4" ];then
                $nohup ./$ModulPath/ZyC_Turbo/main.sh "$1" "$2" "$3" "$4" 2>/dev/null 1>/dev/nul
            else
                $nohup ./$ModulPath/ZyC_Turbo/main.sh "$1" "$2" "$3" 2>/dev/null 1>/dev/nul
            fi
        else
            $nohup ./$ModulPath/ZyC_Turbo/main.sh "$1" "$2" 2>/dev/null 1>/dev/nul
        fi
    else
        $nohup ./$ModulPath/ZyC_Turbo/main.sh "$1" 2>/dev/null 1>/dev/nul
    fi
else
    $nohup ./$ModulPath/ZyC_Turbo/main.sh 2>/dev/null 1>/dev/nul
fi
