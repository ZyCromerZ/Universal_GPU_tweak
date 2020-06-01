#!/system/bin/sh
# for call main.sh :v
for i in /system/bin /system/xbin /sbin /su/xbin; do
    if [ "$GetBusyBox" == "none" ]; then
        if [ -f $i/busybox ]; then
            GetBusyBox=$i/busybox;
        fi;
        PathBusyBox=$i
    fi;
done;
sh=sh
nohup=nohup
if [ -e "$PathBusyBox/sh" ];then
    sh=$PathBusyBox/sh
fi
if [ -e "$PathBusyBox/nohup" ];then
    nohup=$PathBusyBox/nohup
fi
if [ ! -z "$1" ];then
    if [ ! -z "$2" ];then
        if [ ! -z "$3" ];then
            if [ ! -z "$4" ];then
                $nohup $sh ./service.sh "$1" "$2" "$3" "$4" 1>/dev/null 2>dev>null
            else
                $nohup $sh ./service.sh "$1" "$2" "$3" 1>/dev/null 2>dev>null
            fi
        else
            $nohup $sh ./service.sh "$1" "$2" 1>/dev/null 2>dev>null
        fi
    else
        $nohup $sh "$1" ./service.sh 1>/dev/null 2>dev>null
    fi
else
    $nohup $sh ./service.sh 1>/dev/null 2>dev>null
fi