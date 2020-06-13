#!/system/bin/sh
# Created By : ZyCromerZ
# tweak gpu
# this is for auto mode :v 
# prepare function
# kampet

GetBusyBox="none"
PathBusyBox="none"
for i in /system/bin /system/xbin /sbin /su/xbin; do
    if [ "$GetBusyBox" == "none" ]; then
        if [ -f $i/busybox ]; then
            GetBusyBox=$i/busybox
        fi
        PathBusyBox=$i
    fi
done
nohup=nohup
if [ -e "$PathBusyBox/busybox" ]; then
    nohup=$PathBusyBox"/busybox nohup"
fi
usleep=usleep
if [ -e "$PathBusyBox/busybox" ]; then
    usleep=$PathBusyBox"/busybox usleep"
fi
sleep=sleep
if [ -e "$PathBusyBox/busybox" ]; then
    sleep=$PathBusyBox"/busybox sleep"
fi
fromBoot="no"
if [ "$1" == "fromBoot" ]; then
    fromBoot="yes"
    $usleep 5000000
fi
ModulPath=$(cat /system/etc/ZyC_Ai/magisk_path.txt)
if [ ! -e $ModulPath/ZyC_Turbo/system/etc/ZyC_Ai/mod_path.txt ]; then
    . $ModulPath/ZyC_Turbo/initialize.sh & wait
fi
ModPath=$(cat $ModulPath/ZyC_Turbo/system/etc/ZyC_Ai/mod_path.txt)
Path=$ModPath/modul_mantul/ZyC_mod
PathModulConfigAi=$Path/ZyC_Ai
if [ ! -d $Path/ZyC_Ai ]; then
    mkdir -p $Path/ZyC_Ai
fi
PathModulConfig=$Path/ZyC_Turbo_config
if [ ! -d $Path/ZyC_Turbo_config ]; then
    mkdir -p $Path/ZyC_Turbo_config
fi
# Log AI
# if [ -e $Path/Niqua.log ]; then
#     #rm $Path/Niqua.log
# fi
AiLog=$Path/ZyC_Ai.log
ModulPath=$(cat /system/etc/ZyC_Ai/magisk_path.txt)
MALIGPU="NO"
if [ -d /sys/class/kgsl/kgsl-3d0 ]; then
    NyariGPU="/sys/class/kgsl/kgsl-3d0"
elif [ -d /sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0 ]; then
    NyariGPU="/sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0"
elif [ -d /sys/devices/soc/*.qcom,kgsl-3d0/kgsl/kgsl-3d0 ]; then
    NyariGPU="/sys/devices/soc/*.qcom,kgsl-3d0/kgsl/kgsl-3d0"
elif [ -d /sys/devices/soc.0/*.qcom,kgsl-3d0/kgsl/kgsl-3d0 ]; then
    NyariGPU="/sys/devices/soc.0/*.qcom,kgsl-3d0/kgsl/kgsl-3d0"
elif [ -d /sys/devices/platform/*.gpu/devfreq/*.gpu ]; then
    NyariGPU=/sys/devices/platform/*.gpu/devfreq/*.gpu
elif [ -d /sys/devices/platform/*.mali ]; then
    NyariGPU=/sys/devices/platform/*.mali
    MALIGPU="YES"
elif [ -d /sys/class/misc/mali0 ]; then
    NyariGPU=/sys/class/misc/mali0
    MALIGPU="YES"
else
    NyariGPU='';
fi
if [ -e "/system/etc/ZyC_Ai/ai_mode.sh" ]; then
    BASEDIR=/system/etc/ZyC_Ai
fi
NotifPath="none"
if [ -e "/system/etc/ZyC_Ai/set_notification.sh" ]; then
    NotifPath=/system/etc/ZyC_Ai/set_notification.sh
fi
getAppName()
{
    changeSE="tidak"
    if [ "$(getenforce)" == "Enforcing" ] && [ -z "$(getprop | grep begonia)" ]; then
        changeSE="ya"
        setenforce 0
    fi
    if [ -e $NyariGPU/gpu_busy_percentage ]; then
        GetGpuStatus=$(cat "$NyariGPU/gpu_busy_percentage");
    else
        GetGpuStatus="0"
    fi
    if [ -e $NyariGPU/mem_pool_max_size ] && [ -e $NyariGPU/mem_pool_size ] && [ "$MALIGPU" == "YES" ]; then
        MemPollSizeMax=$(cat $NyariGPU/mem_pool_max_size)
        MemPollSize=$(cat $NyariGPU/mem_pool_size)
        GetGpuStatus="$(awk "BEGIN {print (100/$MemPollSizeMax)*$MemPollSize}" | awk -F "\\." '{print $1}')"
    fi
    GpuStatus="$( echo $GetGpuStatus | awk -F'%' '{sub(/^te/,"",$1); print $1 }' )"
    GetPackageApp="$(dumpsys activity recents | grep 'Recent #0' | cut -d= -f2 | sed 's| .*||' | cut -d '/' -f1)"
    if [ "$changeSE" == "ya" ] && [ -z "$(getprop | grep begonia)" ]; then
        setenforce 1
    fi
    echo "while running '$GetPackageApp' your gpu used at $(echo "$GpuStatus")%" | tee -a $AiLog
}
setTurbo(){
    SetNotificationOn
    GetBattery
    echo "Set to turbo at : $(date +" %Y-%m-%d %r")" | tee -a $AiLog
    getAppName
    echo "turbo" > $PathModulConfig/status_modul.txt
    StatusModul="turbo"
    echo "  --- --- --- --- ---  " | tee -a $AiLog
    . $ModulPath/ZyC_Turbo/initialize.sh "Terminal" & wait
    $nohup .$ModulPath/ZyC_Turbo/main.sh "Terminal" "Ai" 2>/dev/null 1>/dev/null & 
    SpectrumOn
    # $usleep 5000000
}
setOff(){
    SetNotificationOff
    GetBattery
    echo "turn to off mode at : $(date +" %Y-%m-%d %r")" | tee -a $AiLog
    echo "off" > $PathModulConfig/status_modul.txt
    StatusModul="off"
    echo "  --- --- --- --- ---  " | tee -a $AiLog
    . $ModulPath/ZyC_Turbo/initialize.sh "Terminal" & wait
    $nohup .$ModulPath/ZyC_Turbo/main.sh "Terminal" "Ai" 2>/dev/null 1>/dev/null & 
    SpectrumOff
}
setLag(){
    DozeNotif=$(cat "$PathModulConfigAi/ai_doze_notif.txt")
    if [ "$DozeNotif" == "on" ]; then
        SetNotificationDozeOn
    fi
    GetBattery
    echo "set to lag mode at : $(date +" %Y-%m-%d %r")" | tee -a $AiLog
    echo "lag" > $PathModulConfig/status_modul.txt
    StatusModul="lag"
    echo "  --- --- --- --- ---  " | tee -a $AiLog
    . $ModulPath/ZyC_Turbo/initialize.sh "Terminal" & wait
    $nohup .$ModulPath/ZyC_Turbo/main.sh "Terminal" "Ai" "doze" 2>/dev/null 1>/dev/null &
    SpectrumBattery
}
setLagoff(){
    DozeNotif=$(cat "$PathModulConfigAi/ai_doze_notif.txt")
    if [ "$DozeNotif" == "on" ]; then
        SetNotificationDozeOff
    fi
    GetBattery
    echo "revert back to off mode at : $(date +" %Y-%m-%d %r")" | tee -a $AiLog
    echo "off" > $PathModulConfig/status_modul.txt
    StatusModul="off"
    echo "  --- --- --- --- ---  " | tee -a $AiLog
    . $ModulPath/ZyC_Turbo/initialize.sh "Terminal" & wait
    $nohup .$ModulPath/ZyC_Turbo/main.sh "Terminal" "Ai" "doze" 2>/dev/null 1>/dev/null &
    SpectrumOff
}
SetNotificationOn(){
    if [ "$NotifPath" != "none" ]; then
        if [ "$aiNotif" == "1" ]; then
            . $NotifPath "getar" "on" & wait
        elif [ "$aiNotif" == "2" ]; then
            . $NotifPath "notif" "on" & wait
        elif [ "$aiNotif" == "3" ]; then
            . $NotifPath "notif" "on2" & wait
        elif [ "$aiNotif" == "4" ]; then
            . $NotifPath "notif" "onvibrate" & wait
        fi
    else
        if [ -e /sys/class/leds/vibrator/duration ] &&  [ -e /sys/class/leds/vibrator/activate ]; then
            echo 800 > /sys/class/leds/vibrator/duration && echo 1 > /sys/class/leds/vibrator/activate
        fi
        if [ -e /sys/class/timed_output/vibrator/enable ]; then
            echo 800 > /sys/class/timed_output/vibrator/enable
        fi
        $usleep 500000
    fi
}
SetNotificationOff(){
    if [ "$NotifPath" != "none" ]; then
        if [ "$aiNotif" == "1" ]; then
            . $NotifPath "getar" "off" & wait
        elif [ "$aiNotif" == "2" ]; then
            . $NotifPath "notif" "off" & wait
        elif [ "$aiNotif" == "3" ]; then
            . $NotifPath "notif" "off2" & wait
        fi
    else
        if [ -e /sys/class/leds/vibrator/duration ] &&  [ -e /sys/class/leds/vibrator/activate ]; then
            echo 600 > /sys/class/leds/vibrator/duration && echo 1 > /sys/class/leds/vibrator/activate
            $sleep 1000000
            echo 300 > /sys/class/leds/vibrator/duration && echo 1 > /sys/class/leds/vibrator/activate
        fi
        if [ -e /sys/class/timed_output/vibrator/enable ]; then
            echo 600 > /sys/class/timed_output/vibrator/enable
            $sleep 1000000
            echo 300 > /sys/class/timed_output/vibrator/enable
        fi
    fi
}
SetNotificationRunning(){
    if [ "$NotifPath" != "none" ] && [ "$(cat "$PathModulConfig/status_modul.txt")" == "turbo" ] && [ "$StatusModul" == "turbo" ]; then
        if [ "$aiNotifRunning" == "1" ]; then
            . $NotifPath "notif" "running" & wait
        elif [ "$aiNotifRunning" == "2" ]; then
            . $NotifPath "notif" "running1" & wait
        elif [ "$aiNotifRunning" == "3" ]; then
            . $NotifPath "notif" "running2" & wait
        elif [ "$aiNotifRunning" == "4" ]; then
            . $NotifPath "notif" "running3" & wait
        fi
    fi
}
SetNotificationDozeOff(){
    if [ "$NotifPath" != "none" ]; then
        . $NotifPath "notif" "dozeoff" & wait
    else
        if [ -e /sys/class/leds/vibrator/duration ] &&  [ -e /sys/class/leds/vibrator/activate ]; then
            echo 600 > /sys/class/leds/vibrator/duration && echo 1 > /sys/class/leds/vibrator/activate
            $sleep 1000000
            echo 300 > /sys/class/leds/vibrator/duration && echo 1 > /sys/class/leds/vibrator/activate
        fi
        if [ -e /sys/class/timed_output/vibrator/enable ]; then
            echo 600 > /sys/class/timed_output/vibrator/enable
            $sleep 1000000
            echo 300 > /sys/class/timed_output/vibrator/enable
        fi
    fi
}
SetNotificationDozeOn(){
    if [ "$NotifPath" != "none" ]; then
        . $NotifPath "notif" "dozeon" & wait
    else
        if [ -e /sys/class/leds/vibrator/duration ] &&  [ -e /sys/class/leds/vibrator/activate ]; then
            echo 600 > /sys/class/leds/vibrator/duration && echo 1 > /sys/class/leds/vibrator/activate
            $sleep 1000000
            echo 300 > /sys/class/leds/vibrator/duration && echo 1 > /sys/class/leds/vibrator/activate
        fi
        if [ -e /sys/class/timed_output/vibrator/enable ]; then
            echo 600 > /sys/class/timed_output/vibrator/enable
            $sleep 1000000
            echo 300 > /sys/class/timed_output/vibrator/enable
        fi
    fi
}
GetBattery(){
    echo "current battery : $(acpi -b | grep '0:' | sed 's/Battery 0:*//g' | sed 's/ *//g' )" | tee -a $AiLog
}
SpectrumOn(){
    if [ "$(getprop spectrum.support)" == "1" ]; then
        SpectrumAutoStatus=$(cat "$PathModulConfigAi/spectrum_status.txt")
        if [ "$SpectrumAutoStatus" == "1" ]; then
            setprop persist.spectrum.profile "$(cat "$PathModulConfigAi/mode_on.txt")"
        fi
    fi   
}
SpectrumOff(){
    if [ "$(getprop spectrum.support)" == "1" ]; then
        SpectrumAutoStatus=$(cat "$PathModulConfigAi/spectrum_status.txt")
        if [ "$SpectrumAutoStatus" == "1" ]; then
            setprop persist.spectrum.profile "$(cat "$PathModulConfigAi/mode_off.txt")"
        fi
    fi
}
SpectrumBattery(){
    if [ "$(getprop spectrum.support)" == "1" ]; then
        SpectrumAutoStatus=$(cat "$PathModulConfigAi/spectrum_status.txt")
        if [ "$SpectrumAutoStatus" == "1" ]; then
            setprop persist.spectrum.profile "$(cat "$PathModulConfigAi/doze_spectrum.txt")"
        fi
    fi
}
runInitialize(){
    if [ ! -z "$1" ]; then
        . $ModulPath/ZyC_Turbo/initialize.sh "$1" & wait
    else
        . $ModulPath/ZyC_Turbo/initialize.sh & wait
    fi
}
runScript(){
    MissingFile="kaga"
    # check service ./config start
        if [ ! -e "$PathModulConfig/status_modul.txt" ]; then
            MissingFile="iya"
        fi

        # mode render
        if [ ! -e "$PathModulConfig/mode_render.txt" ]; then
            MissingFile="iya"
        fi

        # max fps nya
        if [ ! -e "$PathModulConfig/total_fps.txt" ]; then
            MissingFile="iya"
        fi

        # Status Log nya
        if [ ! -e "$PathModulConfig/disable_log_system.txt" ]; then
            MissingFile="iya"
        fi

        # fast charging
        if [ ! -e "$PathModulConfig/fastcharge.txt" ]; then
            MissingFile="iya"
        fi

        # setting adrenoboost
        if [ -e $NyariGPU/devfreq/adrenoboost ]; then
            if [ ! -e "$PathModulConfig/GpuBooster.txt" ]; then
                MissingFile="iya"
            fi
        fi

        # setting fsync
        if [ ! -e "$PathModulConfig/fsync_mode.txt" ]; then
            MissingFile="iya"
        fi

        # setting custom Ram Management
        if [ ! -e "$PathModulConfig/custom_ram_management.txt" ]; then
            MissingFile="iya"
        fi

        
        if [ ! -e "$PathModulConfig/custom_ram_management_adj.txt" ]; then
            MissingFile="iya"
        fi

        # GMS DOZE
        if [ ! -e "$PathModulConfig/gms_doze.txt" ]; then
            MissingFile="iya"
        fi

        # Zram
        if [ ! -e "$PathModulConfig/zram.txt" ]; then
            MissingFile="iya"
        fi
        # swappiness
        if [ ! -e "$PathModulConfig/swapinnes.txt" ]; then
            MissingFile="iya"
        fi

        # optimize zram
        if [ ! -e "$PathModulConfig/zram_optimizer.txt" ]; then
            MissingFile="iya"
        fi

        # dns
        if [ ! -e "$PathModulConfig/dns.txt" ]; then
            MissingFile="iya"
        fi

        if [ ! -e "$PathModulConfig/notes_en.txt" ]; then
            # echo "please read this xD \nyou can set mode.txt to:\n- off \n- on \n- turbo \nvalue must same as above without'-'\n\nchange mode_render.txt to:\n-  opengl \n-  skiagl \n-  skiavk \n\n note:\n-skiavk = Vulkan \n-skiagl = OpenGL (SKIA)\ndont edit total_fps.txt still not tested" > $PathModulConfig/notes.txt
            MissingFile="iya"
        fi
        if [ ! -e "$PathModulConfig/notes_id.txt" ]; then
            MissingFile="iya"
        fi
    # check service.sh config done
    # App trigger start
    if [ ! -e "$PathModulConfigAi/list_app_auto_turbo.txt" ]; then
        MissingFile="iya"
    fi
    # Get App list
    if [ ! -e "$PathModulConfigAi/list_app_package_detected.txt" ]; then
        MissingFile="iya"
    fi
    # Gpu trigger start
    if [ ! -e "$PathModulConfigAi/status_start_gpu.txt" ]; then
        MissingFile="iya"
    fi
    if [ ! -e "$PathModulConfigAi/status_end_gpu.txt" ]; then
        MissingFile="iya"
    fi
    # Wait time when off
    if [ ! -e "$PathModulConfigAi/wait_time_off.txt" ]; then
        MissingFile="iya"
    fi
    # Wait time when on
    if [ ! -e "$PathModulConfigAi/wait_time_on.txt" ]; then
        MissingFile="iya"
    fi
    # Status 0=tidak aktif,1=aktif,2=sedang berjalan
    if [ ! -e "$PathModulConfigAi/ai_status.txt" ]; then
        MissingFile="iya"
    fi
    # run when gaming only or based gpu sage or both
    if [ ! -e "$PathModulConfigAi/ai_change.txt" ]; then
        MissingFile="iya"
    fi
    # Set Ai Notif Mode Start
    if [ ! -e "$PathModulConfigAi/ai_notif_mode.txt" ]; then
        MissingFile="iya"
    fi
    if [ ! -e "$PathModulConfigAi/ai_notif_mode_running.txt" ]; then
        MissingFile="iya"
    fi
    if [ ! -e "$PathModulConfigAi/ai_notif_mode_running_status.txt" ]; then
        MissingFile="iya"
    fi
    if [ ! -e "$PathModulConfigAi/doze_state.txt" ]; then
        echo 'off' > "$PathModulConfigAi/doze_state.txt"
    fi
    if [ ! -e "$PathModulConfigAi/ai_doze.txt" ]; then
        echo 'off' > "$PathModulConfigAi/ai_doze.txt"
    fi
    if [ ! -e "$PathModulConfigAi/ai_doze_notif.txt" ]; then
        echo 'off' > "$PathModulConfigAi/ai_doze_notif.txt"
    fi
    # Set Ai Notif Mode End
    if [ "$MissingFile" == "iya" ]; then
        runInitialize 2>&1 >/dev/null
        if [ "$fromBoot" == "yes" ]; then
            runInitialize "boot" 2>&1 >/dev/null
        fi
    fi
    pathAppAutoTubo=$PathModulConfigAi/list_app_auto_turbo.txt
    GpuStart="$(cat "$PathModulConfigAi/status_start_gpu.txt")";
    GpuStart="$(cat "$PathModulConfigAi/status_start_gpu.txt")";
    GpuStop="$(cat "$PathModulConfigAi/status_end_gpu.txt")";
    waitTimeOff=$(cat "$PathModulConfigAi/wait_time_off.txt");
    waitTimeOn=$(cat "$PathModulConfigAi/wait_time_on.txt");
    aiStatus=$(cat "$PathModulConfigAi/ai_status.txt");
    aiChange=$(cat "$PathModulConfigAi/ai_change.txt")
    aiNotif=$(cat "$PathModulConfigAi/ai_notif_mode.txt");
    aiNotifRunning=$(cat "$PathModulConfigAi/ai_notif_mode_running.txt");
    aiNotifRunningStatus=$(cat "$PathModulConfigAi/ai_notif_mode_running_status.txt");
    StatusModul=$(cat "$PathModulConfig/status_modul.txt");
    if [ "$aiStatus" == "1" ]; then
        echo "<<--- --- --- --- --- " | tee -a $AiLog
        echo "starting ai mode at : $(date +" %Y-%m-%d %r")" | tee -a $AiLog
        echo "module version : $(cat "$PathModulConfig/notes_en.txt" | grep 'Version:' | sed 's/Version:*//g' )" | tee -a $AiLog
        echo "  --- --- --- --- --- " | tee -a $AiLog
        echo "2" > $PathModulConfigAi/ai_status.txt
    elif [ "$aiStatus" == "2" ]; then
        # output
        # ON_UNLOCKED
        # OFF_UNLOCKED
        # OFF_LOCKED
        # ON_LOCKED
        DozeStatePath=$PathModulConfigAi/doze_state.txt
        DozeConfig="$(cat "$PathModulConfigAi/ai_doze.txt")"
        DozeState="$(cat "$DozeStatePath")"
        if [ "$DozeConfig" == "on" ]; then
            GetScreenStateNFC="$( dumpsys nfc 2>&1 2>/dev/null | grep 'mScreenState=' | sed 's/mScreenState=*//g' 2>&1 2>/dev/null )" >/dev/null
            GetScreenStateOF="$( dumpsys display 2>&1 2>/dev/null | grep "mScreenState" | sed 's/mScreenState=*//g' 2>&1 2>/dev/null )" >/dev/null
            GetScreenStateTF="$( dumpsys power 2>&1 2>/dev/null | grep "mHoldingDisplaySuspendBlocker" | sed 's/mHoldingDisplaySuspendBlocker=*//g' 2>&1 2>/dev/null )" >/dev/null
            StatusLayar="gak tau"
            if [[ "$GetScreenStateNFC" == *"ON_LOCKED"* ]] || [[ "$GetScreenStateNFC" == *"ON_UNLOCKED"* ]] || [[ *"$GetScreenStateNFC" == "OFF_LOCKED"* ]] || [[ "$GetScreenStateNFC" == *"OFF_UNLOCKED"* ]]; then
                if [ "$StatusLayar" == "gak tau" ]; then
                    if [[ "$GetScreenStateNFC" == *"OFF_LOCKED"* ]]; then
                        StatusLayar="mati"
                    elif [[ "$GetScreenStateNFC" == *"ON_UNLOCKED"* ]]; then
                        StatusLayar="idup"
                    fi
                fi
            fi
            if [[ "$GetScreenStateOF" == *"ON"* ]] || [[ "$GetScreenStateOF" == *"OFF"* ]]; then
                if [ "$StatusLayar" == "gak tau" ]; then
                    if [[ "$GetScreenStateOF" == *"OFF"* ]]; then
                        StatusLayar="mati"
                    elif [[ "$GetScreenStateOF" == *"ON"* ]]; then
                        StatusLayar="idup"
                    fi
                fi
            fi
            if [[ "$GetScreenStateTF" == *"ON"* ]] || [[ "$GetScreenStateTF" == *"OFF"* ]]; then
                if [ "$StatusLayar" == "gak tau" ]; then
                    if [[ "$GetScreenStateTF" == *"false"* ]]; then
                        StatusLayar="mati"
                    elif [[ "$GetScreenStateTF" == *"true"* ]]; then
                        StatusLayar="idup"
                    fi
                fi
            fi
            if [ "$StatusLayar" == "mati" ]; then
                if [ "$DozeState" != "on" ]; then
                    echo "turn on force doze at : $(date +" %Y-%m-%d %r")" | tee -a $AiLog
                    echo "  --- --- --- --- ---  " | tee -a $AiLog
                    echo $(dumpsys deviceidle force-idle)
                    echo "on" > "$DozeStatePath" 
                    setLag
                fi
            elif [ "$StatusLayar" == "idup" ]; then
                if [ "$DozeState" != "off" ]; then
                    echo "turn off force doze at : $(date +" %Y-%m-%d %r")" | tee -a $AiLog
                    echo "  --- --- --- --- ---  " | tee -a $AiLog
                    echo $(dumpsys deviceidle unforce)
                    echo $(dumpsys deviceidle battery reset)
                    echo "off" > "$DozeStatePath" 
                    setLagoff
                fi
            fi
        else
            DozeState="off"
        fi
        if [ "$DozeState" == "off" ]; then
            if [ "$aiChange" == "1" ]; then
                if [ -e $NyariGPU/gpu_busy_percentage ]; then
                    GetGpuStatus=$(cat $NyariGPU/gpu_busy_percentage);
                else
                    GetGpuStatus="0"
                fi
                if [ -e $NyariGPU/mem_pool_max_size ] && [ -e $NyariGPU/mem_pool_size ] && [ "$MALIGPU" == "YES" ]; then
                    MemPollSizeMax=$(cat $NyariGPU/mem_pool_max_size)
                    MemPollSize=$(cat $NyariGPU/mem_pool_size)
                    GetGpuStatus="$(awk "BEGIN {print (100/$MemPollSizeMax)*$MemPollSize}" | awk -F "\\." '{print $1}')"
                fi
                GpuStatus=$( echo $GetGpuStatus | awk -F'%' '{sub(/^te/,"",$1); print $1 }' ) ;
                if [ "$GpuStatus" -ge "$GpuStart" ] && [ "$StatusModul" != "turbo" ]; then
                    setTurbo & wait
                elif [ "$GpuStatus" -le "$GpuStop" ] && [ "$StatusModul" != "off" ]; then
                    setOff & wait
                fi
            elif [ "$aiChange" == "2" ]; then
                GetPackageApp=$(dumpsys activity recents | grep 'Recent #0' | cut -d= -f2 | sed 's| .*||' | cut -d '/' -f1)
                if [ ! -z "$(grep "$GetPackageApp" "$pathAppAutoTubo" )" ] && [ "$StatusModul" == "off" ]; then
                    echo "found $GetPackageApp on your setting . . ." | tee -a $AiLog
                    setTurbo & wait
                elif  [ "$StatusModul" == "turbo" ] && [ -z "$(grep "$GetPackageApp" "$pathAppAutoTubo" )" ]; then
                    setOff & wait
                fi
            elif [ "$aiChange" == "3" ]; then
                if [ "$StatusModul" == "off" ]; then
                    GetPackageApp=$(dumpsys activity recents | grep 'Recent #0' | cut -d= -f2 | sed 's| .*||' | cut -d '/' -f1)
                    if [ ! -z "$(grep "$GetPackageApp" "$pathAppAutoTubo" )" ]; then
                        if [ "$StatusModul" != "turbo" ]; then
                            echo "found $GetPackageApp on your setting . . ." | tee -a $AiLog
                            setTurbo & wait
                        fi
                    else 
                        if [ -e $NyariGPU/gpu_busy_percentage ]; then
                            GetGpuStatus=$(cat $NyariGPU/gpu_busy_percentage);
                        else
                            GetGpuStatus="0"
                        fi
                        if [ -e $NyariGPU/mem_pool_max_size ] && [ -e $NyariGPU/mem_pool_size ] && [ "$MALIGPU" == "YES" ]; then
                            MemPollSizeMax=$(cat $NyariGPU/mem_pool_max_size)
                            MemPollSize=$(cat $NyariGPU/mem_pool_size)
                            GetGpuStatus="$(awk "BEGIN {print (100/$MemPollSizeMax)*$MemPollSize}" | awk -F "\\." '{print $1}')"
                        fi
                        GpuStatus=$( echo $GetGpuStatus | awk -F'%' '{sub(/^te/,"",$1); print $1 }' ) ;
                        if [ "$GpuStatus" -ge "$GpuStart" ]; then
                            if [ "$StatusModul" != "turbo" ]; then
                                setTurbo & wait
                            fi
                        fi
                    fi
                else
                    if [ -e $NyariGPU/gpu_busy_percentage ]; then
                        GetGpuStatus=$(cat $NyariGPU/gpu_busy_percentage);
                    else
                        GetGpuStatus="0"
                    fi
                    if [ -e $NyariGPU/mem_pool_max_size ] && [ -e $NyariGPU/mem_pool_size ] && [ "$MALIGPU" == "YES" ]; then
                        MemPollSizeMax=$(cat $NyariGPU/mem_pool_max_size)
                        MemPollSize=$(cat $NyariGPU/mem_pool_size)
                        GetGpuStatus="$(awk "BEGIN {print (100/$MemPollSizeMax)*$MemPollSize}" | awk -F "\\." '{print $1}')"
                    fi
                    GpuStatus=$( echo $GetGpuStatus | awk -F'%' '{sub(/^te/,"",$1); print $1 }' ) ;
                    if [ "$GpuStatus" -le "$GpuStop" ]; then
                        if [ "$StatusModul" != "off" ]; then
                            GetPackageApp=$(dumpsys activity recents | grep 'Recent #0' | cut -d= -f2 | sed 's| .*||' | cut -d '/' -f1)
                            if [ -z "$(grep "$GetPackageApp" "$pathAppAutoTubo" )" ]; then
                                setOff & wait
                            fi
                        fi
                    fi
                fi
            elif [ "$aiChange" == "4" ]; then
                if [ "$StatusLayar" == "idup" ] && [ "$StatusModul" != "turbo" ]; then
                    setTurbo & wait
                elif [ "$StatusLayar" == "mati" ] && [ "$StatusModul" != "off" ]; then
                    setLagoff & wait
                else
                    echo $(date +"%Y-%m-%d %r")' -> WARNING!!!,ur phone not support this feature,force switch ai change mode to '
                fi
            fi
        fi
        if [ "$aiStatus" == "2"  ]; then
            if [ "$StatusModul" == "turbo" ]; then
                $sleep "$waitTimeOn"
                AosOnTurbo="$(cat "$PathModulConfigAi/ai_aos_on_turbo.txt")"
                if [ $AosOnTurbo == "1" ]; then
                    input=input
                    if [ -e /system/bin/input ]; then
                        input=/system/bin/input
                    elif [ -e /system/xbin/input ]; then
                        input=/system/xbin/input
                    fi
                    $input keyevent -999999 2>/dev/null 1>/dev/null
                fi
            else
                $sleep "$waitTimeOff"
            fi
        fi 
        #notification when turbo mode start
        if [ "$aiNotifRunningStatus" == "1" ] && [ "$StatusModul" == "turbo" ]; then
            SetNotificationRunning
        elif [ "$aiNotifRunningStatus" == "2" ] && [ "$StatusModul" == "turbo" ]; then
            GetPackageApp=$(dumpsys activity recents | grep 'Recent #0' | cut -d= -f2 | sed 's| .*||' | cut -d '/' -f1)
            if [ ! -z $(grep "$GetPackageApp" "$pathAppAutoTubo" ) ]; then
                if [ "$StatusModul" == "turbo" ]; then
                    SetNotificationRunning
                fi
            fi   
        fi
        #notification when turbo mode end
        if [ "$fromBoot" == "yes" ]; then
            $usleep 5000000
            . $NotifPath "getar" "off" 2>/dev/null 1>/dev/null & wait
            runInitialize "Terminal"
            if [ "$aiStatus" == "2" ]; then
                echo "Continue running at : $(date +" %Y-%m-%d %r")" | tee -a $AiLog
                echo "module version : $(cat "$PathModulConfig/notes_en.txt" | grep 'Version:' | sed 's/Version:*//g' )" | tee -a $AiLog
                echo "  --- --- --- --- --- " | tee -a $AiLog
            fi
        fi
    elif [ "$aiStatus" == "3" ]; then
        echo 'stoping ai mode . . .'  | tee -a $AiLog
        echo "end at : $(date +" %Y-%m-%d %r")" | tee -a $AiLog
        echo "  --- --- --- --- --->> " | tee -a $AiLog
        echo '0' > $PathModulConfigAi/ai_status.txt
    elif [ "$aiStatus" == "0" ]; then
        echo "cannot start . . ."  | tee -a $AiLog
        echo "please change ai status to 1 first" | tee -a $AiLog
        echo "end at : $(date +" %Y-%m-%d %r")" | tee -a $AiLog
        echo "  --- --- --- --- --->> " | tee -a $AiLog
    else
        echo "cannot start . . ."  | tee -a $AiLog
        echo "ai status error . . ."  | tee -a $AiLog
        echo "end at : $(date +" %Y-%m-%d %r")" | tee -a $AiLog
        echo "  --- --- --- --- --->> " | tee -a $AiLog
        echo '0' > $PathModulConfigAi/ai_status.txt
    fi
}
runScript 2>&1 1>/dev/null | tee -a $Path/ZyC_Ai.running.log
if [ "$(cat "$PathModulConfigAi/ai_status.txt")" == "2" ] || [ "$(cat "$PathModulConfigAi/ai_status.txt")" == "3" ] || [ "$(cat "$PathModulConfigAi/ai_status.txt")" == "1" ]; then
    $nohup .$BASEDIR/ai_mode.sh 2>/dev/null 1>/dev/null &
fi
if [ "$fromBoot" == "yes" ]; then
    $nohup .$ModulPath/ZyC_Turbo/main.sh "Terminal" "Ai" 2>/dev/null 1>/dev/null & 
fi
exit 1
