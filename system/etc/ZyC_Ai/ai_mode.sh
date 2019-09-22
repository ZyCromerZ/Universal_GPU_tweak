# Created By : ZyCromerZ
# tweak gpu
# this is for auto mode :v 
# prepare function
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
    echo "unsupported magisk version detected,fail" | tee -a $AiLog /dev/null 2>&1 ;
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
    echo "gpu path not found" | tee -a $AiLog /dev/null 2>&1 ;
    exit -1;
fi
if [ -e "/data/media/0/ai_mode.sh" ];then
    BASEDIR=/data/media/0/
elif [ -e "/system/etc/ZyC_Ai/ai_mode.sh" ];then
    BASEDIR=/system/etc/ZyC_Ai
else
    exit -1;
fi;
# App trigger start
if [ ! -e $PathModulConfigAi/list_app_auto_turbo.txt ]; then
    echo "com.mobile.legends\ncom.miHoYo.bh3oversea\ncom.gameloft.android.ANMP.GloftA9HM" > "$PathModulConfigAi/list_app_auto_turbo.txt"
fi
# listAppAutoTubo=$PathModulConfigAi/list_app_auto_turbo.txt
listAppAutoTubo=$( cat "$PathModulConfigAi/list_app_auto_turbo.txt" )
# Get App list
if [ ! -e $PathModulConfigAi/list_app_package_detected.txt ]; then
    # echo $(pm list package -3) > "$PathModulConfigAi/status_start_gpu.txt"
    listAppPath=$PathModulConfigAi/list_app_package_detected.txt
    if [ "$(getenforce)" == "Enforcing" ];then
        changeSE="ya"
        setenforce 0
    fi
    for listApp in ` pm list packages -3 | awk -F= '{sub("package:","");print $1}'` 
        do 
            checkApp=$(pm list packages -f $listApp | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g')
            nameApp=$(aapt d badging $checkApp | awk -F: ' $1 == "application-label" {print $2}' | sed "s/'*//g")
            # adb shell /data/local/tmp/aapt-arm-pie d badging $pkg | awk -F: ' $1 == "application-label" {print $2}' 
            echo "$listApp ($nameApp)"  | tee -a $listAppPath /dev/null 2>&1 ;
    done
    if [ "$changeSE" == "ya" ];then
        setenforce 1
    fi
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
    echo '1m' > "$PathModulConfigAi/wait_time_on.txt"
fi
waitTimeOn=$(cat "$PathModulConfigAi/wait_time_on.txt");
# Status 0=tidak aktif,1=aktif,2=sedang berjalan
if [ ! -e $PathModulConfigAi/ai_status.txt ]; then
    echo '1' > "$PathModulConfigAi/ai_status.txt"
fi
aiStatus=$(cat "$PathModulConfigAi/ai_status.txt");
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
    echo "while running '$nameApp' your gpu used at $(echo "$GpuStatus")%" | tee -a $AiLog /dev/null 2>&1;
}
setTurbo(){
    echo 800 > /sys/class/timed_output/vibrator/enable
    sleep 0.4s
    echo "Set to turbo at : $(date +" %r")" | tee -a $AiLog /dev/null 2>&1;
    getAppName
    echo "turbo" > $PathModulConfig/status_modul.txt
    sh $ModulPath/ZyC_Turbo/service.sh > /dev/null 2>&1
}
SetOff(){
    echo 600 > /sys/class/timed_output/vibrator/enable
    sleep 0.6s
    echo 300 > /sys/class/timed_output/vibrator/enable
    echo "off" > $PathModulConfig/status_modul.txt
    sh $ModulPath/ZyC_Turbo/service.sh > /dev/null 2>&1
    echo "turn off at : $(date +" %r")" | tee -a $AiLog /dev/null 2>&1;
}
if [ $aiStatus == "1" ]; then
    echo "starting modul at : $(date +" %r")" | tee -a $AiLog /dev/null 2>&1 ;
    # echo 400 > /sys/class/timed_output/vibrator/enable
    # sleep 1s
    echo "2" > $PathModulConfigAi/ai_status.txt
    # sh $BASEDIR
elif [ $aiStatus == "2" ];then
    # GetApp=$( $listAppAutoTubo | awk -F: " $1 == '$GetPackageApp' {print $1}" )
    # echo $GetPackageApp
    # Check=$(echo $listAppAutoTubo | grep "$GetPackageApp")
    # echo $Check;
    if [[ "$listAppAutoTubo" == *"$GetPackageApp"* ]];then
         if [ $StatusModul != "turbo" ];then
            echo "found $GetPackageApp on your setting . . ." | tee -a $AiLog /dev/null 2>&1 ;
            setTurbo
            echo "--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- " | tee -a $AiLog /dev/null 2>&1 ;
        fi
    else 
        if [ "$GpuStatus" -ge "$GpuStart" ];then
            if [ $StatusModul != "turbo" ];then
                setTurbo
                echo "--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- " | tee -a $AiLog /dev/null 2>&1 ;
            fi
        elif [ "$GpuStatus" -le "$GpuStop" ];then
            if [ $StatusModul != "off" ];then
                SetOff
                echo "--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- " | tee -a $AiLog /dev/null 2>&1 ;
            fi
        fi
    fi
    # if [ "$listAppAutoTubo" == *"$GetPackageApp"* ];then
    #     echo 'yess'  | tee -a $AiLog /dev/null 2>&1 ;
    # fi
elif [ $aiStatus == "3" ];then
    echo 'deactive . . .'  | tee -a $AiLog /dev/null 2>&1 ;
    echo "end at : $(date +" %r")" | tee -a $AiLog /dev/null 2>&1 ;
    echo '0' > $PathModulConfigAi/ai_status.txt
    exit -1;
elif [ $aiStatus == "0" ];then
    echo "cannot start . . ."  | tee -a $AiLog /dev/null 2>&1 ;
    echo "please change ai status to 1 first" | tee -a $AiLog /dev/null 2>&1 ;
    echo "end at : $(date +" %r")" | tee -a $AiLog /dev/null 2>&1 ;
    exit -1; 
else
    echo "cannot start . . ."  | tee -a $AiLog /dev/null 2>&1 ;
    echo "ai status error . . ."  | tee -a $AiLog /dev/null 2>&1 ;
    echo "end at : $(date +" %r")" | tee -a $AiLog /dev/null 2>&1 ;
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
# clear;
sh $BASEDIR/ai_mode.sh & disown > /dev/null 2>&1 