#!/system/bin/sh
# Created By : ZyCromerZ
# tweak gpu
# this is for auto mode :v 
# prepare function
fromBoot="no"
if [ "$1" == "fromBoot" ];then
    fromBoot="yes"
    usleep 5000000
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
GetVersion=$($magisk -c | grep -Eo '[0-9]{2}\.[0-9]+')
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
'20.'[0-9a-zA-Z]*) # Version 20.x
	ModulPath=/data/adb/modules
;;
*)
    echo "unsupported magisk version detected,fail" | tee -a $AiLog > /dev/null 2>&1 ;
    exit 
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
    echo "but u cant use gpu tweak,but u can still use another feature :D" | tee -a $AiLog > /dev/null 2>&1 ;
fi
if [ -e "/system/etc/ZyC_Ai/ai_mode.sh" ];then
    BASEDIR=/system/etc/ZyC_Ai
else
    exit 
fi;
runScript(){
    # check service sh config start
    # status modul
    if [ ! -e $PathModulConfig/status_modul.txt ]; then
        MissingFile="iya"
    fi
    # mode render
    if [ ! -e $PathModulConfig/mode_render.txt ]; then
        MissingFile="iya"
    fi

    # max fps nya
    if [ ! -e $PathModulConfig/total_fps.txt ]; then
        MissingFile="iya"
    fi

    # Status Log nya
    if [ ! -e $PathModulConfig/disable_log_system.txt ]; then
        MissingFile="iya"
    fi

    # fast charging
    if [ ! -e $PathModulConfig/fastcharge.txt ]; then
        MissingFile="iya"
    fi

    # setting adrenoboost
    GpuBooster="not found"
    if [ -e $NyariGPU/devfreq/adrenoboost ];then
        if [ ! -e $PathModulConfig/GpuBooster.txt ]; then
            MissingFile="iya"
        fi
    fi

    # setting fsync
    if [ ! -e $PathModulConfig/fsync_mode.txt ]; then
        MissingFile="iya"
    fi

    # setting custom Ram Management
    if [ ! -e $PathModulConfig/custom_ram_management.txt ]; then
        MissingFile="iya"
    fi

    # GMS DOZE
    if [ ! -e $PathModulConfig/gms_doze.txt ]; then
        MissingFile="iya"
    fi

    # Zram
    if [ ! -e $PathModulConfig/zram.txt ]; then
        MissingFile="iya"
    fi
    # swappiness
    if [ ! -e $PathModulConfig/swapinnes.txt ]; then
        MissingFile="iya"
    fi

    # optimize zram
    if [ ! -e $PathModulConfig/zram_optimizer.txt ]; then
        MissingFile="iya"
    fi

    # dns
    if [ ! -e $PathModulConfig/dns.txt ]; then
        MissingFile="iya"
    fi
    
    if [ ! -e $PathModulConfig/notes_en.txt ]; then
        # echo "please read this xD \nyou can set mode.txt to:\n- off \n- on \n- turbo \nvalue must same as above without'-'\n\nchange mode_render.txt to:\n-  opengl \n-  skiagl \n-  skiavk \n\n note:\n-skiavk = Vulkan \n-skiagl = OpenGL (SKIA)\ndont edit total_fps.txt still not tested" > $PathModulConfig/notes.txt
        MissingFile="iya"
    fi
    if [ ! -e $PathModulConfig/notes_id.txt ]; then
        MissingFile="iya"
    fi
    # check service.sh config done
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
    # run when gaming only or based gpu sage or both
    if [ ! -e $PathModulConfigAi/ai_change.txt ]; then
        MissingFile="iya"
    fi
    aiChange=$(cat "$PathModulConfigAi/ai_change.txt")
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
        sh $ModulPath/ZyC_Turbo/initialize.sh & wait > /dev/null 2>&1
        if [ $fromBoot == "yes" ];then
            nohup sh /system/etc/ZyC_Ai/ai_mode.sh "fromBoot" & 
        else
            nohup sh /system/etc/ZyC_Ai/ai_mode.sh & 
        fi
        exit 
    fi
    StatusModul=$(cat "$PathModulConfig/status_modul.txt");
    getAppName()
    {
        changeSE="tidak"
        if [ "$(getenforce)" == "Enforcing" ];then
            changeSE="ya"
            setenforce 0
        fi
        GetGpuStatus=$(cat "$NyariGPU/gpu_busy_percentage");
        GpuStatus=$( echo $GetGpuStatus | awk -F'%' '{sub(/^te/,"",$1); print $1 }' ) ;
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
        StatusModul="turbo"
        echo "  --- --- --- --- ---  " | tee -a $AiLog > /dev/null 2>&1;
        sh $ModulPath/ZyC_Turbo/initialize.sh "Terminal" & wait
        nohup sh $ModulPath/ZyC_Turbo/service.sh "Terminal" "Ai" & 
        # usleep 5000000
    }
    setOff(){
        SetNotificationOff
        echo "turn to off mode at : $(date +" %r")" | tee -a $AiLog > /dev/null 2>&1;
        echo "off" > $PathModulConfig/status_modul.txt
        StatusModul="off"
        echo "  --- --- --- --- ---  " | tee -a $AiLog > /dev/null 2>&1;
        sh $ModulPath/ZyC_Turbo/initialize.sh "Terminal" & wait
        nohup sh $ModulPath/ZyC_Turbo/service.sh "Terminal" "Ai" & 
    }
    setLag(){
        SetNotificationDozeOn
        echo "set to lag mode at : $(date +" %r")" | tee -a $AiLog > /dev/null 2>&1;
        echo "lag" > $PathModulConfig/status_modul.txt
        StatusModul="lag"
        echo "  --- --- --- --- ---  " | tee -a $AiLog > /dev/null 2>&1;
        sh $ModulPath/ZyC_Turbo/initialize.sh "Terminal" & wait
        nohup sh $ModulPath/ZyC_Turbo/service.sh "Terminal" "Ai" "doze" &
    }
    setLagoff(){
        SetNotificationDozeOff
        echo "revert back to off mode at : $(date +" %r")" | tee -a $AiLog > /dev/null 2>&1;
        echo "off" > $PathModulConfig/status_modul.txt
        StatusModul="off"
        echo "  --- --- --- --- ---  " | tee -a $AiLog > /dev/null 2>&1;
        sh $ModulPath/ZyC_Turbo/initialize.sh "Terminal" & wait
        nohup sh $ModulPath/ZyC_Turbo/service.sh "Terminal" "Ai" "doze" &
    }
    SetNotificationOn(){
        if [ "$NotifPath" != "none" ];then
            if [ "$aiNotif" == "1" ];then
                sh $NotifPath "getar" "on" > /dev/null 2>&1 
            elif [ "$aiNotif" == "2" ];then
                sh $NotifPath "notif" "on" > /dev/null 2>&1 
            elif [ "$aiNotif" == "3" ];then
                sh $NotifPath "notif" "on2" > /dev/null 2>&1 
            elif [ "$aiNotif" == "4" ];then
                sh $NotifPath "notif" "onvibrate" > /dev/null 2>&1 
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
            sleep 1000000
            echo 300 > /sys/class/timed_output/vibrator/enable
        fi
    }
    SetNotificationRunning(){
        if [ "$NotifPath" != "none" ] && [ "$(cat "$PathModulConfig/status_modul.txt")" == "turbo" ] && [ $StatusModul == "turbo" ];then
            if [ "$aiNotifRunning" == "1" ];then
                nohup sh $NotifPath "notif" "running" & > /dev/null 2>&1 
            elif [ "$aiNotifRunning" == "2" ];then
                nohup sh $NotifPath "notif" "running1" & > /dev/null 2>&1 
            elif [ "$aiNotifRunning" == "3" ];then
                nohup sh $NotifPath "notif" "running2" & > /dev/null 2>&1 
            elif [ "$aiNotifRunning" == "4" ];then
                nohup sh $NotifPath "notif" "running3" & > /dev/null 2>&1 
            fi
        fi
    }
    SetNotificationDozeOff(){
        if [ "$NotifPath" != "none" ];then
            sh $NotifPath "notif" "dozeoff" > /dev/null 2>&1 
        else
            echo 600 > /sys/class/timed_output/vibrator/enable
            sleep 1000000
            echo 300 > /sys/class/timed_output/vibrator/enable
        fi
    }
    SetNotificationDozeOn(){
        if [ "$NotifPath" != "none" ];then
            sh $NotifPath "notif" "dozeon" > /dev/null 2>&1 
        else
            echo 600 > /sys/class/timed_output/vibrator/enable
            sleep 1000000
            echo 300 > /sys/class/timed_output/vibrator/enable
        fi
    }
    if [ "$aiStatus" == "1" ]; then
        echo "<<--- --- --- --- --- " | tee -a $AiLog > /dev/null 2>&1 ;
        echo "starting ai mode at : $(date +" %r")" | tee -a $AiLog > /dev/null 2>&1 ;
        echo "module version : $(cat "$PathModulConfig/notes_en.txt" | grep 'Version:' | sed 's/Version:*//g' )" | tee -a $AiLog > /dev/null 2>&1 ;
        echo "  --- --- --- --- --- " | tee -a $AiLog > /dev/null 2>&1 ;
        echo "2" > $PathModulConfigAi/ai_status.txt
    elif [ "$aiStatus" == "2" ];then
        # output
        # ON_UNLOCKED
        # OFF_UNLOCKED
        # OFF_LOCKED
        # ON_LOCKED
        # echo "$GetScreenState at : $(date +" %r")" | tee -a $AiLog > /dev/null 2>&1 ;
        DozeStatePath=$PathModulConfigAi/doze_state.txt
        DozeConfig="$(cat $PathModulConfigAi/ai_doze.txt)"
        DozeState="$(cat "$DozeStatePath")"
        if [ "$DozeConfig" == "on" ];then
            GetScreenStateNFC="$( dumpsys nfc | grep 'mScreenState=' | sed 's/mScreenState=*//g' )"  > /dev/null 2>&1 ;
            GetScreenStateOF="$( dumpsys display | grep "mScreenState" | sed 's/mScreenState=*//g'  )"  > /dev/null 2>&1 ;
            GetScreenStateTF="$( dumpsys power | grep "mHoldingDisplaySuspendBlocker" | sed 's/mHoldingDisplaySuspendBlocker=*//g' )"  > /dev/null 2>&1 ;
            StatusLayar="gak tau"
            if [ "$GetScreenStateNFC" == "ON_LOCKED" ] || [ "$GetScreenStateNFC" == "ON_UNLOCKED" ] || [ "$GetScreenStateNFC" == "OFF_LOCKED" ] || [ "$GetScreenStateNFC" == "OFF_UNLOCKED" ];then
                if [ "$StatusLayar" == "gak tau" ];then
                    if [ "$GetScreenStateNFC" == "OFF_LOCKED" ];then
                        StatusLayar="mati"
                    elif [ "$GetScreenStateNFC" == "ON_UNLOCKED" ];then
                        StatusLayar="idup"
                    fi
                fi
            fi
            if [ "$GetScreenStateOF" == "ON" ] || [ "$GetScreenStateOF" == "OFF" ];then
                if [ "$StatusLayar" == "gak tau" ];then
                    if [ "$GetScreenStateOF" == "OFF" ];then
                        StatusLayar="mati"
                    elif [ "$GetScreenStateOF" == "ON" ];then
                        StatusLayar="idup"
                    fi
                fi
            fi
            if [ "$GetScreenStateTF" == "ON" ] || [ "$GetScreenStateTF" == "OFF" ];then
                if [ "$StatusLayar" == "gak tau" ];then
                    if [ "$GetScreenStateTF" == "false" ];then
                        StatusLayar="mati"
                    elif [ "$GetScreenStateTF" == "true" ];then
                        StatusLayar="idup"
                    fi
                fi
            fi
            if [ "$StatusLayar" == "mati" ];then
                if [ "$DozeState" != "on" ];then
                    echo "turn on force doze at : $(date +" %r")"  | tee -a $AiLog > /dev/null 2>&1 ;
                    echo "  --- --- --- --- ---  " | tee -a $AiLog > /dev/null 2>&1;
                    echo $(dumpsys deviceidle force-idle) > /dev/null 2>&1 ;
                    echo "on" > "$DozeStatePath" 
                    setLag
                fi
            elif [ "$StatusLayar" == "idup" ];then
                if [ "$DozeState" != "off" ];then
                    echo "turn off force doze at : $(date +" %r")"  | tee -a $AiLog > /dev/null 2>&1 ;
                    echo "  --- --- --- --- ---  " | tee -a $AiLog > /dev/null 2>&1;
                    echo $(dumpsys deviceidle unforce) > /dev/null 2>&1 ;
                    echo $(dumpsys deviceidle battery reset) > /dev/null 2>&1 ;
                    echo "off" > "$DozeStatePath" 
                    setLagoff
                fi
            fi
        else
            DozeState="off"
        fi
        if [ "$DozeState" == "off" ];then
            if [ "$aiChange" == "1" ];then
                GetGpuStatus=$(cat "$NyariGPU/gpu_busy_percentage");
                GpuStatus=$( echo $GetGpuStatus | awk -F'%' '{sub(/^te/,"",$1); print $1 }' ) ;
                if [ "$GpuStatus" -ge "$GpuStart" ] && [ $StatusModul != "turbo" ];then
                    setTurbo & wait
                elif [ "$GpuStatus" -le "$GpuStop" ] && [ $StatusModul != "off" ];then
                    setOff & wait
                fi
            elif [ "$aiChange" == "2" ];then
                GetPackageApp=$(dumpsys activity recents | grep 'Recent #0' | cut -d= -f2 | sed 's| .*||' | cut -d '/' -f1)
                if [ ! -z $(grep "$GetPackageApp" "$pathAppAutoTubo" ) ] && [ $StatusModul == "off" ];then
                    echo "found $GetPackageApp on your setting . . ." | tee -a $AiLog > /dev/null 2>&1 ;
                    setTurbo & wait
                elif  [ $StatusModul == "turbo" ] && [ -z $(grep "$GetPackageApp" "$pathAppAutoTubo" ) ];then
                    setOff & wait
                fi
            elif [ "$aiChange" == "3" ];then
                if [ "$StatusModul" == "off" ];then
                    GetPackageApp=$(dumpsys activity recents | grep 'Recent #0' | cut -d= -f2 | sed 's| .*||' | cut -d '/' -f1)
                    if [ ! -z $(grep "$GetPackageApp" "$pathAppAutoTubo" ) ];then
                        if [ $StatusModul != "turbo" ];then
                            echo "found $GetPackageApp on your setting . . ." | tee -a $AiLog > /dev/null 2>&1 ;
                            setTurbo & wait
                        fi
                    else 
                        GetGpuStatus=$(cat "$NyariGPU/gpu_busy_percentage");
                        GpuStatus=$( echo $GetGpuStatus | awk -F'%' '{sub(/^te/,"",$1); print $1 }' ) ;
                        if [ "$GpuStatus" -ge "$GpuStart" ];then
                            if [ $StatusModul != "turbo" ];then
                                setTurbo & wait
                            fi
                        fi
                    fi
                else
                    
                        GetGpuStatus=$(cat "$NyariGPU/gpu_busy_percentage");
                        GpuStatus=$( echo $GetGpuStatus | awk -F'%' '{sub(/^te/,"",$1); print $1 }' ) ;
                    if [ "$GpuStatus" -le "$GpuStop" ];then
                        if [ $StatusModul != "off" ];then
                            GetPackageApp=$(dumpsys activity recents | grep 'Recent #0' | cut -d= -f2 | sed 's| .*||' | cut -d '/' -f1)
                            if [ -z $(grep "$GetPackageApp" "$pathAppAutoTubo" ) ];then
                                setOff & wait
                            fi
                        fi
                    fi
                fi
            fi
        fi
    elif [ "$aiStatus" == "3" ];then
        echo 'stoping ai mode . . .'  | tee -a $AiLog > /dev/null 2>&1 ;
        echo "end at : $(date +" %r")" | tee -a $AiLog > /dev/null 2>&1 ;
        echo "  --- --- --- --- --->> " | tee -a $AiLog > /dev/null 2>&1 ;
        echo '0' > $PathModulConfigAi/ai_status.txt
        exit 
    elif [ "$aiStatus" == "0" ];then
        echo "cannot start . . ."  | tee -a $AiLog > /dev/null 2>&1 ;
        echo "please change ai status to 1 first" | tee -a $AiLog > /dev/null 2>&1 ;
        echo "end at : $(date +" %r")" | tee -a $AiLog > /dev/null 2>&1 ;
        echo "  --- --- --- --- --->> " | tee -a $AiLog > /dev/null 2>&1 ;
        exit 
    else
        echo "cannot start . . ."  | tee -a $AiLog > /dev/null 2>&1 ;
        echo "ai status error . . ."  | tee -a $AiLog > /dev/null 2>&1 ;
        echo "end at : $(date +" %r")" | tee -a $AiLog > /dev/null 2>&1 ;
        echo "  --- --- --- --- --->> " | tee -a $AiLog > /dev/null 2>&1 ;
        echo '0' > $PathModulConfigAi/ai_status.txt
        exit 
    fi
    if [ "$aiStatus" == "2"  ];then
        if [ $StatusModul == "turbo" ];then
            sleep "$waitTimeOn"
        else
            sleep "$waitTimeOff"
        fi
    fi 
    #notification when turbo mode start
    if [ "$aiNotifRunningStatus" == "1" ] && [ "$StatusModul" == "turbo" ];then
        SetNotificationRunning
    elif [ "$aiNotifRunningStatus" == "2" ] && [ "$StatusModul" == "turbo" ];then
        GetPackageApp=$(dumpsys activity recents | grep 'Recent #0' | cut -d= -f2 | sed 's| .*||' | cut -d '/' -f1)
        if [ ! -z $(grep "$GetPackageApp" "$pathAppAutoTubo" ) ];then
            if [ $StatusModul == "turbo" ];then
                SetNotificationRunning
            fi
        fi   
    fi
    #notification when turbo mode end
    if [ $fromBoot == "yes" ];then
        # usleep 5000000
        nohup sh $NotifPath "getar" "off" &
        sh $ModulPath/ZyC_Turbo/initialize.sh "Terminal" & wait 
        nohup sh $ModulPath/ZyC_Turbo/service.sh "Terminal" "Ai" & 
        if [ "$aiStatus" == "2" ];then
            echo "Continue running at : $(date +" %r")" | tee -a $AiLog > /dev/null 2>&1 ;
            echo "module version : $(cat "$PathModulConfig/notes_en.txt" | grep 'Version:' | sed 's/Version:*//g' )" | tee -a $AiLog > /dev/null 2>&1 ;
            echo "  --- --- --- --- --- " | tee -a $AiLog > /dev/null 2>&1 ;
        fi
    fi
    nohup sh $BASEDIR/ai_mode.sh &
    exit
}
runScript 2>&1 | tee -a $Path/ZyC_Ai.running.log > /dev/null 2>&1 ;