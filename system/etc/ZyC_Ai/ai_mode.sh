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
    sh $ModulPath/ZyC_Turbo/initialize.sh & wait > /dev/null 2>&1
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
MissingFile="kaga"
# App trigger start
if [ ! -e $PathModulConfigAi/list_app_auto_turbo.txt ]; then
    MissingFile="iya"
fi
pathAppAutoTubo=$PathModulConfigAi/list_app_auto_turbo.txt
# Get App list
if [ ! -e $PathModulConfigAi/list_app_package_detected.txt ]; then
    MissingFile="iya"
fi
GpuStart="$(cat "$PathModulConfigAi/status_start_gpu.txt")";
# Gpu trigger start
if [ ! -e $PathModulConfigAi/status_start_gpu.txt ]; then
    MissingFile="iya"
fi
GpuStart="$(cat "$PathModulConfigAi/status_start_gpu.txt")";
if [ ! -e $PathModulConfigAi/status_end_gpu.txt ]; then
    MissingFile="iya"
fi
GpuStop="$(cat "$PathModulConfigAi/status_end_gpu.txt")";
# Wait time when off
if [ ! -e $PathModulConfigAi/wait_time_off.txt ]; then
    MissingFile="iya"
fi
# Wait time when on
waitTimeOff=$(cat "$PathModulConfigAi/wait_time_off.txt");
if [ ! -e $PathModulConfigAi/wait_time_on.txt ]; then
    MissingFile="iya"
fi
waitTimeOn=$(cat "$PathModulConfigAi/wait_time_on.txt");
# Status 0=tidak aktif,1=aktif,2=sedang berjalan
if [ ! -e $PathModulConfigAi/ai_status.txt ]; then
    MissingFile="iya"
fi
aiStatus=$(cat "$PathModulConfigAi/ai_status.txt");
# Set Ai Notif Mode Start
if [ ! -e $PathModulConfigAi/ai_notif_mode.txt ]; then
    MissingFile="iya"
fi
aiNotif=$(cat "$PathModulConfigAi/ai_notif_mode.txt");
if [ ! -e $PathModulConfigAi/ai_notif_mode_running.txt ]; then
    MissingFile="iya"
fi
aiNotifRunning=$(cat "$PathModulConfigAi/ai_notif_mode_running.txt");
if [ ! -e $PathModulConfigAi/ai_notif_mode_running_status.txt ]; then
    MissingFile="iya"
fi
aiNotifRunningStatus=$(cat "$PathModulConfigAi/ai_notif_mode_running_status.txt");
# Set Ai Notif Mode End
if [ $MissingFile == "iya" ]; then
    sh $ModulPath/ZyC_Turbo/initialize.sh > /dev/null 2>&1
    if [ $fromBoot == "yes" ];then
        sh /system/etc/ZyC_Ai/ai_mode.sh "fromBoot" & disown > /dev/null 2>&1;
    else
        sh /system/etc/ZyC_Ai/ai_mode.sh & disown > /dev/null 2>&1;
    fi
    exit 0;
fi
StatusModul=$(cat "$PathModulConfig/status_modul.txt");
GetGpuStatus=$(cat "$NyariGPU/gpu_busy_percentage");
GpuStatus=$( echo $GetGpuStatus | awk -F'%' '{sub(/^te/,"",$1); print $1 }' ) ;
getAppName()
{
    changeSE="tidak"
    if [ "$(getenforce)" == "Enforcing" ];then
        changeSE="ya"
        setenforce 0
    fi
    GetPackageApp=$(dumpsys activity recents | grep 'Recent #0' | cut -d= -f2 | sed 's| .*||' | cut -d '/' -f1);
    checkApp=$(pm list packages -f $GetPackageApp | awk -F '\\.apk' '{print $1".apk"}' | sed 's/package:*//g')
    nameApp=$(aapt d badging $checkApp | awk -F: ' $1 == "application-label" {print $2}' | sed "s/'*//g")
    if [ "$changeSE" == "ya" ];then
        setenforce 1
    fi
    echo "while running '$nameApp' your gpu used at $(echo "$GpuStatus")%" | tee -a $AiLog > /dev/null 2>&1;
}
setTurbo(){
    SetNotificationOn
    echo "Set to turbo at : $(date +" %r")" | tee -a $AiLog > /dev/null 2>&1;
    getAppName
    echo "turbo" > $PathModulConfig/status_modul.txt
    echo "  --- --- --- --- ---  " | tee -a $AiLog > /dev/null 2>&1;
    sh $ModulPath/ZyC_Turbo/initialize.sh "Terminal" & wait > /dev/null 2>&1
    sh $ModulPath/ZyC_Turbo/service.sh "Terminal" "Ai" & disown > /dev/null 2>&1
    sleep 5s
}
setOff(){
    SetNotificationOff
    echo "turn off at : $(date +" %r")" | tee -a $AiLog > /dev/null 2>&1;
    echo "off" > $PathModulConfig/status_modul.txt
    echo "  --- --- --- --- ---  " | tee -a $AiLog > /dev/null 2>&1;
    sh $ModulPath/ZyC_Turbo/initialize.sh "Terminal" & wait > /dev/null 2>&1
    sh $ModulPath/ZyC_Turbo/service.sh "Terminal" "Ai" & disown > /dev/null 2>&1
}
SetNotificationOn(){
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
}
SetNotificationOff(){
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
}
SetNotificationRunning(){
    if [ "$NotifPath" != "none" ] && [ "$(cat "$PathModulConfig/status_modul.txt")" == "turbo" ] && [ $StatusModul == "turbo" ];then
        if [ "$aiNotifRunning" == "1" ];then
            sh $NotifPath "notif" "running" & disown > /dev/null 2>&1 
        elif [ "$aiNotifRunning" == "2" ];then
            sh $NotifPath "notif" "running1" & disown > /dev/null 2>&1 
        elif [ "$aiNotifRunning" == "3" ];then
            sh $NotifPath "notif" "running2" & disown > /dev/null 2>&1 
        elif [ "$aiNotifRunning" == "4" ];then
            sh $NotifPath "notif" "running3" & disown > /dev/null 2>&1 
        fi
    fi
}
if [ $aiStatus == "1" ]; then
    echo "<<--- --- --- --- --- " | tee -a $AiLog > /dev/null 2>&1 ;
    echo "starting ai mode at : $(date +" %r")" | tee -a $AiLog > /dev/null 2>&1 ;
    echo "module version : $(cat "$PathModulConfig/notes_en.txt" | grep 'Version:' | sed "s/Version:*//g" )" | tee -a $AiLog > /dev/null 2>&1 ;
    echo "  --- --- --- --- --- " | tee -a $AiLog > /dev/null 2>&1 ;
    echo "2" > $PathModulConfigAi/ai_status.txt
elif [ $aiStatus == "2" ];then
    if [ "$StatusModul" == "off" ];then
        GetPackageApp=$(dumpsys activity recents | grep 'Recent #0' | cut -d= -f2 | sed 's| .*||' | cut -d '/' -f1)
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
            fi
        fi
    else
        if [ "$GpuStatus" -le "$GpuStop" ];then
            if [ $StatusModul != "off" ];then
                GetPackageApp=$(dumpsys activity recents | grep 'Recent #0' | cut -d= -f2 | sed 's| .*||' | cut -d '/' -f1)
                if [ -z $(grep "$GetPackageApp" "$pathAppAutoTubo" ) ];then
                    setOff
                fi
            fi
        fi
    fi
    
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
#notification when turbo mode start
if [ $aiNotifRunningStatus == "1" ];then
    SetNotificationRunning
elif [ $aiNotifRunningStatus == "2" ];then
    GetPackageApp=$(dumpsys activity recents | grep 'Recent #0' | cut -d= -f2 | sed 's| .*||' | cut -d '/' -f1)
    if [ ! -z $(grep "$GetPackageApp" "$pathAppAutoTubo" ) ];then
        if [ $StatusModul == "turbo" ];then
            SetNotificationRunning
        fi
    fi 
            
fi
#notification when turbo mode end
if [ $fromBoot == "yes" ];then
    sleep 40s
    sh $NotifPath "getar" "off" > /dev/null 2>&1 
    echo "Continue running at : $(date +" %r")" | tee -a $AiLog > /dev/null 2>&1 ;
    echo "module version : $(cat "$PathModulConfig/notes_en.txt" | grep 'Version:' | sed "s/Version:*//g" )" | tee -a $AiLog > /dev/null 2>&1 ;
    echo "  --- --- --- --- --- " | tee -a $AiLog > /dev/null 2>&1 ;
    sh $ModulPath/ZyC_Turbo/service.sh "Terminal" "Ai" & disown > /dev/null 2>&1
    sh $BASEDIR/ai_mode.sh & disown > /dev/null 2>&1
else
    sh $BASEDIR/ai_mode.sh & disown > /dev/null 2>&1
fi