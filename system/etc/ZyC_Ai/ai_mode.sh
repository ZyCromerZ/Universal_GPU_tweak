# Created By : ZyCromerZ
# tweak gpu
# this is for auto mode :v 
# prepare function
fromBoot="no"
if [ "$1" == "fromBoot" ];then
    fromBoot="yes"
    sleep 5s
fi
MAGISKTMP=$ModulPath/ZyC_Turbo
if [ ! -e /data/mod_path.txt ]; then
    echo "/data/media/0" > /data/mod_path.txt
fi
ModPath=$(cat /data/mod_path.txt)
Path=$ModPath/modul_mantul/ZyC_mod
if [ ! -d $Path/ZyC_Ai ]; then
    mkdir -p $Path/ZyC_Ai
fi
PathModulConfig=$Path/ZyC_Turbo_config
if [ ! -d $Path/ZyC_Turbo_config ]; then
    mkdir -p $Path/ZyC_Turbo_config
fi
PathModulConfigAi=$Path/ZyC_Ai
# Log AI
# if [ -e $Path/Niqua.log ]; then
#     #rm $Path/Niqua.log
# fi
AiLog=$Path/ZyC_Ai.log
magisk=$(ls /data/adb/magisk/magisk || ls /sbin/magisk) 2>/dev/null;
GetVersion=$($magisk -c | grep -Eo '[1-9]{2}\.[0-9]+')
case "$GetVersion" in
'15.'[1-9]*) # Version 15.1 - 15.9
	ModulPath=/sbin/.core/img
;;
'16.'[1-9]*) # Version 16.1 - 16.9
	ModulPath=/sbin/.core/img
;;
'17.'[1-3]*) # Version 17.1 - 17.3
	ModulPath=/sbin/.core/img
;;
'17.'[4-9]*) # Version 17.4 - 17.9
	ModulPath=/sbin/.magisk/img
;;
'18.'[0-9]*) # Version 18.x
	ModulPath=/sbin/.magisk/img
;;
'19.'[0-9a-zA-Z]*) # Version 19.x
	ModulPath=/data/adb/modules
;;
*)
    echo "unsupported magisk version detected,fail" | tee -a $AiLog > /dev/null 2>&1 ;
    exit -1;
;;
esac
if [ -d "/sys/class/kgsl/kgsl-3d0" ]; then
  	NyariGPU="/sys/class/kgsl/kgsl-3d0"
elif [ -d "/sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0" ]; then
  	NyariGPU="/sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0"
elif [ -d "/sys/devices/soc/*.qcom,kgsl-3d0/kgsl/kgsl-3d0" ]; then
  	NyariGPU="/sys/devices/soc/*.qcom,kgsl-3d0/kgsl/kgsl-3d0"
elif [ -d "/sys/devices/soc.0/*.qcom,kgsl-3d0/kgsl/kgsl-3d0" ]; then
  	NyariGPU="/sys/devices/soc.0/*.qcom,kgsl-3d0/kgsl/kgsl-3d0"
elif [ -d "/sys/devices/platform/*.gpu/devfreq/*.gpu" ]; then
  	NyariGPU="/sys/devices/platform/*.gpu/devfreq/*.gpu"
else
    NyariGPU='';
fi
if [ NyariGPU == '' ];then
    echo "gpu path not found" | tee -a $AiLog > /dev/null 2>&1 ;
    exit -1;
fi
if [ -e "/system/etc/ZyC_Ai/ai_mode.sh" ];then
    BASEDIR=/system/etc/ZyC_Ai
else
    exit -1;
fi;
NotifPath="none"
if [ -e "/system/etc/ZyC_Ai/set_notification.sh" ];then
    NotifPath=/system/etc/ZyC_Ai/set_notification.sh
fi
# App trigger start
if [ ! -e $PathModulConfigAi/list_app_auto_turbo.txt ]; then
    GameList=$PathModulConfigAi/list_app_auto_turbo.txt
    changeSE="tidak"
    if [ "$(getenforce)" == "Enforcing" ];then
        changeSE="ya"
        setenforce 0
    fi
    # Moba Analog
    if [ ! -z $(pm list packages -f com.mobile.legends | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ];then
        echo "com.mobile.legends" | tee -a $GameList > /dev/null 2>&1;
    fi
    # Honkai Impact 3
    if [ ! -z $(pm list packages -f com.miHoYo.bh3oversea | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ];then
        echo "com.miHoYo.bh3oversea" | tee -a $GameList > /dev/null 2>&1;
    fi
    # Ashpalt 9
    if [ ! -z $(pm list packages -f com.gameloft.android.ANMP.GloftA9HM | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ];then
        echo "com.gameloft.android.ANMP.GloftA9HM" | tee -a $GameList > /dev/null 2>&1;
    fi
    # Pubg
    if [ ! -z $(pm list packages -f com.netmarble.revolutionthm | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ];then
        echo "com.netmarble.revolutionthm" | tee -a $GameList > /dev/null 2>&1;
    fi
    if [ ! -z $(pm list packages -f com.tencent.tmgp.pubgmhd | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ];then
        echo "com.tencent.tmgp.pubgmhd" | tee -a $GameList > /dev/null 2>&1;
    fi
    if [ ! -z $(pm list packages -f com.tencent.tmgp.pubgm | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ];then
        echo "com.tencent.tmgp.pubgm" | tee -a $GameList > /dev/null 2>&1;
    fi
    if [ ! -z $(pm list packages -f com.tencent.iglite | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ];then
        echo "com.tencent.iglite" | tee -a $GameList > /dev/null 2>&1;
    fi
    if [ ! -z $(pm list packages -f com.pubg.krmobile | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ];then
        echo "com.pubg.krmobile" | tee -a $GameList > /dev/null 2>&1;
    fi
    if [ ! -z $(pm list packages -f com.rekoo.pubgm | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ];then
        echo "com.rekoo.pubgm" | tee -a $GameList > /dev/null 2>&1;
    fi
    if [ ! -z $(pm list packages -f com.tencent.ig | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ];then
        echo "com.tencent.ig" | tee -a $GameList > /dev/null 2>&1;
    fi
    # another game
    if [ ! -z $(pm list packages -f com.theonegames.gunshipbattle | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ];then
        echo "com.theonegames.gunshipbattle" | tee -a $GameList > /dev/null 2>&1;
    fi
    if [ ! -z $(pm list packages -f com.netease.lztgglobal | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ];then
        echo "com.netease.lztgglobal" | tee -a $GameList > /dev/null 2>&1;
    fi
    if [ ! -z $(pm list packages -f com.ea.game.nfs14_row | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ];then
        echo "com.ea.game.nfs14_row" | tee -a $GameList > /dev/null 2>&1;
    fi
    if [ ! -z $(pm list packages -f com.squareenixmontreal.hitmansniperandroid | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ];then
        echo "com.squareenixmontreal.hitmansniperandroid" | tee -a $GameList > /dev/null 2>&1;
    fi
    if [ ! -z $(pm list packages -f com.dts.freefireth | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ];then
        echo "com.dts.freefireth" | tee -a $GameList > /dev/null 2>&1;
    fi
    if [ ! -z $(pm list packages -f com.nekki.shadowfight3 | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ];then
        echo "com.nekki.shadowfight3" | tee -a $GameList > /dev/null 2>&1;
    fi
    if [ ! -z $(pm list packages -f com.gamedreamer.sgth | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ];then
        echo "com.gamedreamer.sgth" | tee -a $GameList > /dev/null 2>&1;
    fi
    if [ ! -z $(pm list packages -f com.netease.eclipseisle | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ];then
        echo "com.netease.eclipseisle" | tee -a $GameList > /dev/null 2>&1;
    fi
    if [ ! -z $(pm list packages -f com.pwrd.pwm | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ];then
        echo "com.pwrd.pwm" | tee -a $GameList > /dev/null 2>&1;
    fi
    if [ ! -z $(pm list packages -f com.gameloft.android.ANMP.GloftHEHM | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ];then
        echo "com.gameloft.android.ANMP.GloftHEHM" | tee -a $GameList > /dev/null 2>&1;
    fi
    if [ ! -z $(pm list packages -f com.garena.game.kgid | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ];then
        echo "com.garena.game.kgid" | tee -a $GameList > /dev/null 2>&1;
    fi
    if [ ! -z $(pm list packages -f com.netease.g78na.gb | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ];then
        echo "com.netease.g78na.gb" | tee -a $GameList > /dev/null 2>&1;
    fi
    # if [ ! -z $(pm list packages -f com. | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g') ];then
    #     echo "com." | tee -a $GameList > /dev/null 2>&1;
    # fi
    if [ "$changeSE" == "ya" ];then
        setenforce 1
    fi
fi
pathAppAutoTubo=$PathModulConfigAi/list_app_auto_turbo.txt
# Get App list
if [ ! -e $PathModulConfigAi/list_app_package_detected.txt ]; then
    listAppPath=$PathModulConfigAi/list_app_package_detected.txt
    echo "---->> List app installed start <<----"  | tee -a $listAppPath > /dev/null 2>&1 ;
    changeSE="tidak"
    if [ "$(getenforce)" == "Enforcing" ];then
        changeSE="ya"
        setenforce 0
    fi
    for listApp in ` pm list packages -3 | awk -F= '{sub("package:","");print $1}'` 
        do 
            checkApp=$(pm list packages -f $listApp | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g')
            nameApp=$(aapt d badging $checkApp | awk -F: ' $1 == "application-label" {print $2}' | sed "s/'*//g")
            # adb shell /data/local/tmp/aapt-arm-pie d badging $pkg | awk -F: ' $1 == "application-label" {print $2}' 
            echo "$listApp ($nameApp)"  | tee -a $listAppPath > /dev/null 2>&1 ;
    done
    if [ "$changeSE" == "ya" ];then
        setenforce 1
    fi
    echo "<<---- List app installed end ---->>"  | tee -a $listAppPath > /dev/null 2>&1 ;
fi
GpuStart="$(cat "$PathModulConfigAi/status_start_gpu.txt")";
# Gpu trigger start
if [ ! -e $PathModulConfigAi/status_start_gpu.txt ]; then
    echo '80' > "$PathModulConfigAi/status_start_gpu.txt"
fi
GpuStart="$(cat "$PathModulConfigAi/status_start_gpu.txt")";
if [ ! -e $PathModulConfigAi/status_end_gpu.txt ]; then
    echo '5' > "$PathModulConfigAi/status_end_gpu.txt"
fi
GpuStop="$(cat "$PathModulConfigAi/status_end_gpu.txt")";
# Wait time when off
if [ ! -e $PathModulConfigAi/wait_time_off.txt ]; then
    echo '3s' > "$PathModulConfigAi/wait_time_off.txt"
fi
# Wait time when on
waitTimeOff=$(cat "$PathModulConfigAi/wait_time_off.txt");# Wait time
if [ ! -e $PathModulConfigAi/wait_time_on.txt ]; then
    echo '10s' > "$PathModulConfigAi/wait_time_on.txt"
fi
waitTimeOn=$(cat "$PathModulConfigAi/wait_time_on.txt");
# Status 0=tidak aktif,1=aktif,2=sedang berjalan
if [ ! -e $PathModulConfigAi/ai_status.txt ]; then
    echo '1' > "$PathModulConfigAi/ai_status.txt"
fi
aiStatus=$(cat "$PathModulConfigAi/ai_status.txt");
# Set Ai Notif Mode
if [ ! -e $PathModulConfigAi/ai_notif_mode.txt ]; then
    echo '3' > "$PathModulConfigAi/ai_notif_mode.txt"
fi
aiNotif=$(cat "$PathModulConfigAi/ai_notif_mode.txt");
StatusModul=$(cat "$PathModulConfig/status_modul.txt");
GetGpuStatus=$(cat "$NyariGPU/gpu_busy_percentage");
GpuStatus=$( echo $GetGpuStatus | awk -F'%' '{sub(/^te/,"",$1); print $1 }' ) ;
GetPackageApp=$(dumpsys activity recents | grep 'Recent #0' | cut -d= -f2 | sed 's| .*||' | cut -d '/' -f1);
getAppName()
{
    changeSE="tidak"
    if [ "$(getenforce)" == "Enforcing" ];then
        changeSE="ya"
        setenforce 0
    fi
    checkApp=$(pm list packages -f $GetPackageApp | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g')
    nameApp=$(aapt d badging $checkApp | awk -F: ' $1 == "application-label" {print $2}' | sed "s/'*//g")
    if [ "$changeSE" == "ya" ];then
        setenforce 1
    fi
    echo "while running '$nameApp' your gpu used at $(echo "$GpuStatus")%" | tee -a $AiLog > /dev/null 2>&1;
}
setTurbo(){
    if [ "$NotifPath" != "none" ];then
        if [ "$aiNotif" == "1" ];then
            sh $NotifPath "getar" "on" > /dev/null 2>&1 
        elif [ "$aiNotif" == "2" ];then
            sh $NotifPath "notif" "on" > /dev/null 2>&1 
        elif [ "$aiNotif" == "3" ];then
            sh $NotifPath "notif" "on2" > /dev/null 2>&1 
        fi
    else
        echo 800 > /sys/class/timed_output/vibrator/enable
        usleep 500000
    fi
    echo "Set to turbo at : $(date +" %r")" | tee -a $AiLog > /dev/null 2>&1;
    getAppName
    echo "turbo" > $PathModulConfig/status_modul.txt
    echo "  --- --- --- --- ---  " | tee -a $AiLog > /dev/null 2>&1;
    sh $ModulPath/ZyC_Turbo/service.sh "Terminal" "Ai" & disown > /dev/null 2>&1
}
setOff(){
    if [ "$NotifPath" != "none" ];then
        if [ "$aiNotif" == "1" ];then
            sh $NotifPath "getar" "off" > /dev/null 2>&1 
        elif [ "$aiNotif" == "2" ];then
            sh $NotifPath "notif" "off" > /dev/null 2>&1 
        elif [ "$aiNotif" == "3" ];then
            sh $NotifPath "notif" "off2" > /dev/null 2>&1 
        fi
    else
        echo 600 > /sys/class/timed_output/vibrator/enable
        sleep 1s
        echo 300 > /sys/class/timed_output/vibrator/enable
    fi
    echo "turn off at : $(date +" %r")" | tee -a $AiLog > /dev/null 2>&1;
    echo "off" > $PathModulConfig/status_modul.txt
    echo "  --- --- --- --- ---  " | tee -a $AiLog > /dev/null 2>&1;
    sh $ModulPath/ZyC_Turbo/service.sh "Terminal" "Ai" & disown > /dev/null 2>&1
}
if [ $aiStatus == "1" ]; then
    echo "<<--- --- --- --- --- " | tee -a $AiLog > /dev/null 2>&1 ;
    echo "starting ai mode at : $(date +" %r")" | tee -a $AiLog > /dev/null 2>&1 ;
    # echo 400 > /sys/class/timed_output/vibrator/enable
    # sleep 1s
    echo "2" > $PathModulConfigAi/ai_status.txt
    # sh $BASEDIR
elif [ $aiStatus == "2" ];then
    # GetApp=$( $listAppAutoTubo | awk -F: " $1 == '$GetPackageApp' {print $1}" )
    # echo $GetPackageApp
    # Check=$(echo $listAppAutoTubo | grep "$GetPackageApp")
    # echo $Check;
    if [ ! -z $(grep "$GetPackageApp" "$pathAppAutoTubo" ) ];then
        if [ $StatusModul != "turbo" ];then
            echo "found $GetPackageApp on your setting . . ." | tee -a $AiLog > /dev/null 2>&1 ;
            setTurbo
        fi
    else 
        if [ "$GpuStatus" -ge "$GpuStart" ];then
            if [ $StatusModul != "turbo" ];then
                setTurbo
            fi
        elif [ "$GpuStatus" -le "$GpuStop" ];then
            if [ $StatusModul != "off" ];then
                setOff
            fi
        fi
    fi
    # if [ "$1" == "ShowAppList" ];then
    #     # echo "running : $GetPackageApp" | tee -a $AiLog > /dev/null 2>&1 ;
    # fi
    # if [ "$listAppAutoTubo" == *"$GetPackageApp"* ];then
    #     echo 'yess'  | tee -a $AiLog > /dev/null 2>&1 ;
    # fi
elif [ $aiStatus == "3" ];then
    echo 'stoping ai mode . . .'  | tee -a $AiLog > /dev/null 2>&1 ;
    echo "end at : $(date +" %r")" | tee -a $AiLog > /dev/null 2>&1 ;
    echo "  --- --- --- --- --->> " | tee -a $AiLog > /dev/null 2>&1 ;
    echo '0' > $PathModulConfigAi/ai_status.txt
    exit -1;
elif [ $aiStatus == "0" ];then
    echo "cannot start . . ."  | tee -a $AiLog > /dev/null 2>&1 ;
    echo "please change ai status to 1 first" | tee -a $AiLog > /dev/null 2>&1 ;
    echo "end at : $(date +" %r")" | tee -a $AiLog > /dev/null 2>&1 ;
    echo "  --- --- --- --- --->> " | tee -a $AiLog > /dev/null 2>&1 ;
    exit -1; 
else
    echo "cannot start . . ."  | tee -a $AiLog > /dev/null 2>&1 ;
    echo "ai status error . . ."  | tee -a $AiLog > /dev/null 2>&1 ;
    echo "end at : $(date +" %r")" | tee -a $AiLog > /dev/null 2>&1 ;
    echo "  --- --- --- --- --->> " | tee -a $AiLog > /dev/null 2>&1 ;
    echo '0' > $PathModulConfigAi/ai_status.txt
    exit -1;
fi
if [ $aiStatus == "2"  ];then
    if [ $StatusModul == "turbo" ];then
        sleep "$waitTimeOn"
    else
        sleep "$waitTimeOff"
    fi
fi 
if [ $fromBoot == "yes" ];then
    sleep 40s
    echo 600 > /sys/class/timed_output/vibrator/enable
    sleep 1s
    echo 300 > /sys/class/timed_output/vibrator/enable
    sh $ModulPath/ZyC_Turbo/service.sh "Terminal" "Ai" & disown > /dev/null 2>&1
    sh $BASEDIR/ai_mode.sh & disown > /dev/null 2>&1
else
    sh $BASEDIR/ai_mode.sh & disown > /dev/null 2>&1
fi