# Created By : ZyCromerZ
# tweak gpu
# you can try on off my feature
# prepare function
# sleep 2s
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
    echo "unsupported magisk version detected,fail"
    exit -1;
;;
esac
FromTerminal="tidak";
FromAi="tidak"
if [ ! -z "$1" ];then
    if [ "$1" == "Terminal" ];then
        FromTerminal="ya";
    fi
fi
if [ $FromTerminal == "tidak" ];then
    sh $ModulPath/ZyC_Turbo/initialize.sh & wait > /dev/null 2>&1
    sleep 5s
    sh $ModulPath/ZyC_Turbo/initialize.sh "FromTerminal" & wait > /dev/null 2>&1
fi;
if [ ! -z "$2" ];then
    if [ "$2" == "Ai" ];then
        FromAi="ya";
    fi
fi;
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
MissingFile="kaga"
# Path=/sdcard/modul_mantul/ZyC_mod
if [ ! -e /data/mod_path.txt ]; then
    echo "/data/media/0" > /data/mod_path.txt
fi
ModPath=$(cat /data/mod_path.txt)

Path=$ModPath/modul_mantul/ZyC_mod
if [ ! -d $Path/ZyC_Ai ]; then
    MissingFile="iya"
fi
PathModulConfigAi=$Path/ZyC_Ai
if [ ! -d $Path/ZyC_Turbo_config ]; then
    MissingFile="iya"
fi
PathModulConfig=$Path/ZyC_Turbo_config

if [ -e $Path/ZyC_Turbo.log ]; then
    rm $Path/ZyC_Turbo.log
fi
saveLog=$Path/ZyC_Turbo.log

echo "<<--- --- --- --- --- " | tee -a $saveLog 
echo "starting modules . . ." | tee -a $saveLog 
echo "Version : $(cat "$PathModulConfig/notes_en.txt" | grep 'Version:' | sed "s/Version:*//g" )"
if [ $FromTerminal == "tidak" ];then
    echo "running with boot detected" | tee -a $saveLog 
elif [ $FromAi == "ya" ];then
    echo "running with ai detected" | tee -a $saveLog 
else
    echo "running without boot detected" | tee -a $saveLog 
fi
echo "  --- --- --- --- --- " | tee -a $saveLog 
# status modul
if [ ! -e $PathModulConfig/status_modul.txt ]; then
    MissingFile="iya"
fi
GetMode=$(cat $PathModulConfig/status_modul.txt)

# mode render
if [ ! -e $PathModulConfig/mode_render.txt ]; then
    MissingFile="iya"
fi
RenderMode=$(cat $PathModulConfig/mode_render.txt)

# max fps nya
if [ ! -e $PathModulConfig/total_fps.txt ]; then
    MissingFile="iya"
fi
SetRefreshRate=$(cat $PathModulConfig/total_fps.txt)

# Status Log nya
if [ ! -e $PathModulConfig/disable_log_system.txt ]; then
    MissingFile="iya"
fi
LogStatus=$(cat $PathModulConfig/disable_log_system.txt)

# fast charging
if [ ! -e $PathModulConfig/fastcharge.txt ]; then
    MissingFile="iya"
fi
FastCharge=$(cat $PathModulConfig/fastcharge.txt)

# setting adrenoboost
if [ ! -e $PathModulConfig/GpuBooster.txt ]; then
    MissingFile="iya"
fi
GpuBooster=$(cat $PathModulConfig/GpuBooster.txt)

# setting fsync
if [ ! -e $PathModulConfig/fsync_mode.txt ]; then
    MissingFile="iya"
fi
fsyncMode=$(cat $PathModulConfig/fsync_mode.txt)

# setting custom Ram Management
if [ ! -e $PathModulConfig/custom_ram_management.txt ]; then
    MissingFile="iya"
fi
CustomRam=$(cat $PathModulConfig/custom_ram_management.txt)

# GMS DOZE
if [ ! -e $PathModulConfig/gms_doze.txt ]; then
    MissingFile="iya"
fi
GMSDoze=$(cat $PathModulConfig/gms_doze.txt)

# Zram
if [ ! -e $PathModulConfig/zram.txt ]; then
    MissingFile="iya"
fi
CustomZram=$(cat $PathModulConfig/zram.txt)
# swappiness
if [ ! -e $PathModulConfig/swapinnes.txt ]; then
    MissingFile="iya"
fi
Swapinnes=$(cat $PathModulConfig/swapinnes.txt)

# optimize zram
if [ ! -e $PathModulConfig/zram_optimizer.txt ]; then
    MissingFile="iya"
fi
ZramOptimizer=$(cat $PathModulConfig/zram_optimizer.txt)

if [ ! -e $PathModulConfig/notes_en.txt ]; then
    # echo "please read this xD \nyou can set mode.txt to:\n- off \n- on \n- turbo \nvalue must same as above without'-'\n\nchange mode_render.txt to:\n-  opengl \n-  skiagl \n-  skiavk \n\n note:\n-skiavk = Vulkan \n-skiagl = OpenGL (SKIA)\ndont edit total_fps.txt still not tested" > $PathModulConfig/notes.txt
    MissingFile="iya"
fi
if [ ! -e $PathModulConfig/notes_id.txt ]; then
    MissingFile="iya"
fi
# log backup nya
    if [ "$MissingFile" == "iya" ]; then
        sh $ModulPath/ZyC_Turbo/initialize.sh & wait > /dev/null 2>&1
        if [ "$FromAi" == "ya" ];then
            exit 0;
        else
            sh $ModulPath/ZyC_Turbo/service.sh & disown 
        fi
        exit 0;
    fi
# end log backup
SetOff(){
    echo 'revert setting . . .' | tee -a $saveLog;
    #mengembalikan settingan ke asal :D
    setprop persist.sys.NV_FPSLIMIT 35 > /dev/null 2>&1
    resetprop --delete persist.sys.NV_FPSLIMIT > /dev/null 2>&1
    resetprop --delete persist.sys.NV_POWERMODE > /dev/null 2>&1
    resetprop --delete persist.sys.NV_PROFVER > /dev/null 2>&1
    resetprop --delete persist.sys.NV_STEREOCTRL > /dev/null 2>&1
    resetprop --delete persist.sys.NV_STEREOSEPCHG > /dev/null 2>&1
    resetprop --delete persist.sys.NV_STEREOSEP > /dev/null 2>&1
    if [ -e $NyariGPU/throttling ]; then
        echo $(cat "$PathModulConfig/backup/gpu_throttling.txt") > "$NyariGPU/throttling"
    fi
    if [ -e $NyariGPU/force_no_nap ]; then
        echo $(cat "$PathModulConfig/backup/gpu_force_no_nap.txt") > "$NyariGPU/force_no_nap"
    fi
    if [ -e $NyariGPU/force_bus_on ]; then
        echo $(cat "$PathModulConfig/backup/gpu_force_bus_on.txt") > "$NyariGPU/force_bus_on"
    fi
    if [ -e $NyariGPU/force_clk_on ]; then
        echo $(cat "$PathModulConfig/backup/gpu_force_clk_on.txt") > "$NyariGPU/force_clk_on"
    fi
    if [ -e $NyariGPU/force_rail_on ]; then
        echo $(cat "$PathModulConfig/backup/gpu_force_rail_on.txt") > "$NyariGPU/force_rail_on"
    fi
    if [ -e $NyariGPU/bus_split ]; then
        echo $(cat "$PathModulConfig/backup/gpu_bus_split.txt") > "$NyariGPU/bus_split"
    fi
    if [ -e $NyariGPU/max_pwrlevel ]; then
        echo $(cat "$PathModulConfig/backup/gpu_max_pwrlevel.txt") > "$NyariGPU/max_pwrlevel"
    fi
    if [ -e $NyariGPU/devfreq/adrenoboost ]; then
        echo $(cat "$PathModulConfig/backup/gpu_adrenoboost.txt") > "$NyariGPU/devfreq/adrenoboost"
    fi
    if [ -e $NyariGPU/devfreq/thermal_pwrlevel ]; then
        echo $(cat "$PathModulConfig/backup/gpu_thermal_pwrlevel.txt") > "$NyariGPU/devfreq/thermal_pwrlevel"
    fi
    if [ -e /sys/kernel/dyn_fsync/Dyn_fsync_active ]; then
        echo $(cat  "$PathModulConfig/backup/misc_Dyn_fsync_active.txt") > "/sys/kernel/dyn_fsync/Dyn_fsync_active"
    fi
    if [ -e /sys/class/misc/fsynccontrol/fsync_enabled ]; then
        echo $(cat  "$PathModulConfig/backup/misc_class_fsync_enabled.txt") > "/sys/class/misc/fsynccontrol/fsync_enabled"
    fi 
    if [ -e /sys/module/sync/parameters/fsync ]; then
        echo $(cat  "$PathModulConfig/backup/misc_fsync.txt") > "/sys/module/sync/parameters/fsync"
    fi
    if [ -e /sys/module/sync/parameters/fsync_enabled ]; then
        echo $(cat  "$PathModulConfig/backup/misc_module_fsync_enabled.txt") > "/sys/module/sync/parameters/fsync_enabled"
    fi
    echo 'revert done . . .' | tee -a $saveLog;
    echo "  --- --- --- --- --- " | tee -a $saveLog 
}
SetOn(){
    echo 'use "on" setting. . .' | tee -a $saveLog;
    #fps limit ke 90
    setprop persist.sys.NV_FPSLIMIT 90
    setprop persist.sys.NV_POWERMODE 1
    setprop persist.sys.NV_PROFVER 15
    setprop persist.sys.NV_STEREOCTRL 0
    setprop persist.sys.NV_STEREOSEPCHG 0
    setprop persist.sys.NV_STEREOSEP 20
    # GPU TWEAK wajib lah biar kaga drop fps xD
    if [ "$NyariGPU" != '' ];then
        if [ -e $NyariGPU/max_pwrlevel ]; then
            echo "0" > "$NyariGPU/max_pwrlevel"
            echo "0" > "$NyariGPU/max_pwrlevel"
        fi
        if [ -e $NyariGPU/devfreq/adrenoboost ]; then
            echo "3" > "$NyariGPU/devfreq/adrenoboost"
        fi
    fi
    echo 'use "on" done. . .' | tee -a $saveLog;
    echo "  --- --- --- --- --- " | tee -a $saveLog 

}
SetTurbo(){
    #fps limit ke 120
    echo 'use "turbo" setting. . .' | tee -a $saveLog;
    setprop persist.sys.NV_FPSLIMIT 120
    if  [ $NyariGPU != '' ];then
        if [ -e "$NyariGPU/throttling" ]; then
            echo "0" > $NyariGPU/throttling
        fi
        if [ -e "$NyariGPU/force_no_nap" ]; then
            echo "0" > $NyariGPU/force_no_nap
        fi
        if [ -e "$NyariGPU/force_bus_on" ]; then
            echo "0" > $NyariGPU/force_bus_on
        fi
        if [ -e "$NyariGPU/force_clk_on" ]; then
            echo "0" > $NyariGPU/force_clk_on
        fi
        if [ -e "$NyariGPU/force_rail_on" ]; then
            echo "0" > $NyariGPU/force_rail_on
        fi
        if [ -e "$NyariGPU/bus_split" ]; then
            echo "1" > $NyariGPU/bus_split
        fi
    fi
    echo 'use "turbo" done .' | tee -a $saveLog;
    echo "  --- --- --- --- --- " | tee -a $saveLog 
}
fstrimDulu(){
    echo "fstrim data cache & system, please wait" | tee -a $saveLog;
    fstrim -v /cache | tee -a $saveLog;
    fstrim -v /data | tee -a $saveLog;
    fstrim -v /system | tee -a $saveLog;
    echo "done ." | tee -a $saveLog;
    echo "  --- --- --- --- --- " | tee -a $saveLog 
}
disableFsync(){
    # disable fsync biar ui smooth :D
    echo 'disable fsync . . .' | tee -a $saveLog;
    if [ -e /sys/kernel/dyn_fsync/Dyn_fsync_active ]; then
        echo "0" > /sys/kernel/dyn_fsync/Dyn_fsync_active
    fi
    if [ -e /sys/class/misc/fsynccontrol/fsync_enabled ]; then
        echo "0" > /sys/class/misc/fsynccontrol/fsync_enabled
    fi 
    if [ -e /sys/module/sync/parameters/fsync ]; then
        echo "0" > /sys/module/sync/parameters/fsync
    fi
    if [ -e /sys/module/sync/parameters/fsync_enabled ]; then
        echo "N" > /sys/module/sync/parameters/fsync_enabled
    fi
    echo 'disable done .' | tee -a $saveLog;
    echo "  --- --- --- --- --- " | tee -a $saveLog 
}
enableFsync(){
    # enable fsync
    echo 'enable fsync . . .' | tee -a $saveLog;
    if [ -e /sys/kernel/dyn_fsync/Dyn_fsync_active ]; then
        echo "1" > /sys/kernel/dyn_fsync/Dyn_fsync_active
    fi
    if [ -e /sys/class/misc/fsynccontrol/fsync_enabled ]; then
        echo "1" > /sys/class/misc/fsynccontrol/fsync_enabled
    fi 
    if [ -e /sys/module/sync/parameters/fsync ]; then
        echo "1" > /sys/module/sync/parameters/fsync
    fi
    if [ -e /sys/module/sync/parameters/fsync_enabled ]; then
        echo "Y" > /sys/module/sync/parameters/fsync_enabled
    fi
    echo 'enable done .' | tee -a $saveLog;
    echo "  --- --- --- --- --- " | tee -a $saveLog 
}
systemFsync(){
    echo 'use fsync system setting . . .' | tee -a $saveLog;
    if [ ! -e $PathModulConfig/backup/misc_Dyn_fsync_active.txt ]; then
        if [ -e /sys/kernel/dyn_fsync/Dyn_fsync_active ]; then
            echo $(cat  "$PathModulConfig/backup/misc_Dyn_fsync_active.txt") > /sys/kernel/dyn_fsync/Dyn_fsync_active
        fi
    fi

    if [ ! -e $PathModulConfig/backup/misc_class_fsync_enabled.txt ]; then
        if [ -e /sys/class/misc/fsynccontrol/fsync_enabled ]; then
            echo $(cat  "$PathModulConfig/backup/misc_class_fsync_enabled.txt") > /sys/class/misc/fsynccontrol/fsync_enabled
        fi 
    fi

    if [ ! -e $PathModulConfig/backup/misc_fsync.txt ]; then
        if [ -e /sys/module/sync/parameters/fsync ]; then
            echo $(cat  "$PathModulConfig/backup/misc_fsync.txt") > /sys/module/sync/parameters/fsync
        fi
    fi

    if [ ! -e $PathModulConfig/backup/misc_module_fsync_enabled.txt ]; then
        if [ -e /sys/module/sync/parameters/fsync_enabled ]; then
            echo $(cat  "$PathModulConfig/backup/misc_module_fsync_enabled.txt") > /sys/module/sync/parameters/fsync_enabled
        fi
    fi
    echo 'use fsync system setting done .' | tee -a $saveLog;
    echo "  --- --- --- --- --- " | tee -a $saveLog 
}
disableLogSystem(){
# Disable stats logging & monitoring
    echo 'disable log and monitoring . . .' | tee -a $saveLog;
    setprop debug.atrace.tags.enableflags 0 > /dev/null 2>&1
    setprop profiler.force_disable_ulog true > /dev/null 2>&1
    setprop profiler.force_disable_err_rpt true > /dev/null 2>&1
    setprop profiler.force_disable_ulog 1 > /dev/null 2>&1
    setprop profiler.force_disable_err_rpt 1 > /dev/null 2>&1
    setprop ro.config.nocheckin 1 > /dev/null 2>&1
    setprop debugtool.anrhistory 0 > /dev/null 2>&1
    setprop ro.com.google.locationfeatures 0 > /dev/null 2>&1
    setprop ro.com.google.networklocation 0 > /dev/null 2>&1
    setprop profiler.debugmonitor false > /dev/null 2>&1
    setprop profiler.launch false > /dev/null 2>&1
    setprop profiler.hung.dumpdobugreport false > /dev/null 2>&1
    setprop persist.service.pcsync.enable 0 > /dev/null 2>&1
    setprop persist.service.lgospd.enable 0 > /dev/null 2>&1
    setprop persist.sys.purgeable_assets 1 > /dev/null 2>&1
    echo 'disable log and monitoring done .' | tee -a $saveLog;
    echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1
}
enableLogSystem(){
# Enable stats logging & monitoring
    echo 'enable log and monitoring . . .' | tee -a $saveLog;
    setprop debug.atrace.tags.enableflags 1 > /dev/null 2>&1
    setprop profiler.force_disable_ulog false > /dev/null 2>&1
    setprop profiler.force_disable_err_rpt false > /dev/null 2>&1
    setprop profiler.force_disable_ulog 0 > /dev/null 2>&1
    setprop profiler.force_disable_err_rpt 0 > /dev/null 2>&1
    setprop ro.config.nocheckin 0 > /dev/null 2>&1
    setprop debugtool.anrhistory 1 > /dev/null 2>&1
    setprop ro.com.google.locationfeatures 1 > /dev/null 2>&1
    setprop ro.com.google.networklocation 1 > /dev/null 2>&1
    setprop profiler.debugmonitor true > /dev/null 2>&1
    setprop profiler.launch true > /dev/null 2>&1
    setprop profiler.hung.dumpdobugreport true > /dev/null 2>&1
    setprop persist.service.pcsync.enable 1 > /dev/null 2>&1
    setprop persist.service.lgospd.enable 1 > /dev/null 2>&1
    setprop persist.sys.purgeable_assets 0 > /dev/null 2>&1
    echo 'enable log and monitoring done .' | tee -a $saveLog;
    echo "  --- --- --- --- --- " | tee -a $saveLog 
}

# ngator mode start
    if [ "$GetMode" == 'off' ];then
        SetOff
        echo "turn off tweak" | tee -a $saveLog;
        echo "  --- --- --- --- --- " | tee -a $saveLog 
    elif [ "$GetMode" == 'on' ];then
        SetOff
        SetOn
        # disableFsync
        echo "setting to mode on" | tee -a $saveLog;
        echo "  --- --- --- --- --- " | tee -a $saveLog 
    elif [ "$GetMode" == 'turbo' ];then
        SetOn
        SetTurbo
        # disableFsync
        # disableThermal
        echo "swith to turbo mode" | tee -a $saveLog;
        echo "  --- --- --- --- --- " | tee -a $saveLog 
    else
        SetOff
        # SetOn
        # disableFsync
        echo "please read guide, mode $GetMode,not found autmatic set to mode off " | tee -a $saveLog;
        echo 'off' > $PathModulConfig/status_modul.txt
        echo "  --- --- --- --- --- " | tee -a $saveLog 
    fi
# ngator mode end

# enable fastcharge start
    if [ "$FastCharge" == "1" ]; then
        if [ -e /sys/kernel/fast_charge/force_fast_charge ]; then
            fcMethod="one";
            echo "tying to enable fastcharging using first method" | tee -a $saveLog;
            echo "2" > /sys/kernel/fast_charge/force_fast_charge
            if [ "$(cat /sys/kernel/fast_charge/force_fast_charge)" == "0" ]; then
                fcMethod="two";
                echo "tying to enable fastcharging using second method" | tee -a $saveLog;
                echo "1" > /sys/kernel/fast_charge/force_fast_charge
            fi
            if [ "$(cat /sys/kernel/fast_charge/force_fast_charge)" == "0" ]; then
                echo "fastcharge off,maybe your kernel/phone not support it" | tee -a $saveLog;
            else
                echo "fastcharge on after use method $fcMethod" | tee -a $saveLog;
            fi
            echo "  --- --- --- --- --- " | tee -a $saveLog 
        fi
    fi  
# enable fastcharge end

# set fps ? start
    if [ "$SetRefreshRate" != "0" ];then
        setprop persist.sys.NV_FPSLIMIT $SetRefreshRate
        echo "custom fps detected, set to $SetRefreshRate" | tee -a $saveLog;
        echo "  --- --- --- --- --- " | tee -a $saveLog 
    fi
# set fps ? end

# fstrim start
    if [ -e system/bin/fstrim ]; then
        fstrimDulu
    elif [ -e system/xbin/fstrim ]; then
        fstrimDulu
    fi;
# fstrim end

# gpu turbo start
    if [ "$GpuBooster" == "0" ];then
        echo "$GpuBooster" > $NyariGPU/devfreq/adrenoboost
        echo "custom GpuBoost detected, set to $GpuBooster" | tee -a $saveLog;
    elif [ "$GpuBooster" == "1" ];then
        echo "$GpuBooster" > $NyariGPU/devfreq/adrenoboost
        echo "custom GpuBoost detected, set to $GpuBooster" | tee -a $saveLog;
    elif [ "$GpuBooster" == "2" ];then
        echo "$GpuBooster" > $NyariGPU/devfreq/adrenoboost
        echo "custom GpuBoost detected, set to $GpuBooster" | tee -a $saveLog;
    elif [ "$GpuBooster" == "3" ];then
        echo "$GpuBooster" > $NyariGPU/devfreq/adrenoboost
        echo "custom GpuBoost detected, set to $GpuBooster" | tee -a $saveLog;
    else
        echo "nice,use default this tweak GpuBoost" | tee -a $saveLog;
        echo 'tweak' > $PathModulConfig/GpuBooster.txt
    fi
    echo "  --- --- --- --- --- " | tee -a $saveLog 
# gpu turbo end

# echo "ok beres dah . . .\n" | tee -a $saveLog;
# gpu render start
    if [ "$FromTerminal" == "ya" ];then
        if [ "$RenderMode" == 'skiagl' ];then
            setprop debug.hwui.renderer skiagl
            echo "set render gpu to OpenGL (SKIA) done" | tee -a $saveLog;
        elif [ "$RenderMode" == 'skiavk' ];then
            setprop debug.hwui.renderer skiavk
            echo "set render gpu to Vulkan (SKIA) done" | tee -a $saveLog;
        elif [ "$RenderMode" == 'opengl' ];then
            setprop debug.hwui.renderer opengl
            echo "set render gpu to OpenGL default done" | tee -a $saveLog;
        else
            GetBackupGPU=$(cat "$PathModulConfig/backup/gpu_render.txt")
            if [ -z "$GetBackupGPU" ];then
                echo "system" > $PathModulConfig/mode_render.txt
                setprop debug.hwui.renderer $GetBackupGPU
                echo "set render gpu to system setting" | tee -a $saveLog;
            fi
        fi
        echo "  --- --- --- --- --- " | tee -a $saveLog  
    fi
# gpu render end

# disable fsync start
    if [ "$FromTerminal" == "ya" ];then
        if [ "$fsyncMode" == "0" ];then
            disableFsync
            echo "custom fsync detected, set to disable" | tee -a $saveLog;
        elif [ "$fsyncMode" == "1" ];then
            enableFsync
            echo "custom fsync detected, set to enable" | tee -a $saveLog;
        elif [ "$fsyncMode" == "system" ];then
            systemFsync
            echo "use system fsync setting" | tee -a $saveLog;
        else
            # disableFsync
            systemFsync
            echo "fsync value error,set to by system" | tee -a $saveLog;
            echo 'system' > $PathModulConfig/fsync_mode.txt
        fi
        echo "  --- --- --- --- --- " | tee -a $saveLog 
    fi
# disable fsync end

# custom ram managent start
    if [ "$FromTerminal" == "ya" ];then
        if [ "$CustomRam" == '0' ];then
                # echo "coming_soon :D"| tee -a $saveLog;
                echo "not use custom ram management,using stock ram management" | tee -a $saveLog;
                if [ -e $PathModulConfig/backup/ram_enable_adaptive_lmk.txt ];then
                    chmod 0666 /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk;
                    echo $(cat "$PathModulConfig/backup/ram_enable_adaptive_lmk.txt") > "/sys/module/lowmemorykiller/parameters/enable_adaptive_lmk"
                    chmod 0644 /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk;
                    setprop lmk.autocalc false
                    if [ "$(cat "$PathModulConfig/backup/ram_enable_adaptive_lmk.txt")" == "1" ];then
                        setprop lmk.autocalc true
                    else
                        setprop lmk.autocalc false
                    fi
                    rm $PathModulConfig/backup/ram_enable_adaptive_lmk.txt
                fi
                if [ -e $PathModulConfig/backup/ram_debug_level.txt ];then
                    echo $(cat "$PathModulConfig/backup/ram_debug_level.txt") > "/sys/module/lowmemorykiller/parameters/debug_level"
                    chmod 0666 /sys/module/lowmemorykiller/parameters/debug_level;
                    chmod 0644 /sys/module/lowmemorykiller/parameters/debug_level;
                    rm $PathModulConfig/backup/ram_debug_level.txt
                fi
                if [ -e $PathModulConfig/backup/ram_adj.txt ];then
                    chmod 0666 /sys/module/lowmemorykiller/parameters/adj;
                    echo $(cat "$PathModulConfig/backup/ram_adj.txt") > "/sys/module/lowmemorykiller/parameters/adj"
                    chmod 0644 /sys/module/lowmemorykiller/parameters/adj;
                    rm $PathModulConfig/backup/ram_adj.txt
                fi
                if [ -e $PathModulConfig/backup/ram_minfree.txt ];then
                    chmod 0666 /sys/module/lowmemorykiller/parameters/minfree;
                    echo $(cat "$PathModulConfig/backup/ram_minfree.txt") > "/sys/module/lowmemorykiller/parameters/minfree"
                    chmod 0644 /sys/module/lowmemorykiller/parameters/minfree;
                    rm $PathModulConfig/backup/ram_minfree.txt
                fi
                # echo "udah mati broo,selamat battery lu aman :V" | tee -a $saveLog;
        else
            sh $ModulPath/ZyC_Turbo/initialize.sh & wait > /dev/null 2>&1
            echo "using custom ram management method $CustomRam" | tee -a $saveLog;
            StopModify="no"
            GetTotalRam=$(free -m | awk '/Mem:/{print $2}');
            if [ "$CustomRam" == "1" ]; then # Method 1
                ForegroundApp=$((((GetTotalRam*2/100)*1024)/4))
                VisibleApp=$((((GetTotalRam*3/100)*1024)/4))
                SecondaryServer=$((((GetTotalRam*5/100)*1024)/4))
                HiddenApp=$((((GetTotalRam*6/100)*1024)/4))
                ContentProvider=$((((GetTotalRam*10/100)*1024)/4))
                EmptyApp=$((((GetTotalRam*12/100)*1024)/4))
            elif [ "$CustomRam" == "2" ]; then # Method 2
                ForegroundApp=$((((GetTotalRam*3/100)*1024)/4))
                VisibleApp=$((((GetTotalRam*4/100)*1024)/4))
                SecondaryServer=$((((GetTotalRam*5/100)*1024)/4))
                HiddenApp=$((((GetTotalRam*7/100)*1024)/4))
                ContentProvider=$((((GetTotalRam*11/100)*1024)/4))
                EmptyApp=$((((GetTotalRam*15/100)*1024)/4))
            elif [ "$CustomRam" == "3" ]; then # Method 3
                ForegroundApp=$((((GetTotalRam*4/100)*1024)/4))
                VisibleApp=$((((GetTotalRam*5/100)*1024)/4))
                SecondaryServer=$((((GetTotalRam*6/100)*1024)/4))
                HiddenApp=$((((GetTotalRam*7/100)*1024)/4))
                ContentProvider=$((((GetTotalRam*12/100)*1024)/4))
                EmptyApp=$((((GetTotalRam*15/100)*1024)/4))
            elif [ "$CustomRam" == "4" ]; then # Method 4 (for 3gb ram variant)
                ForegroundApp=$((((GetTotalRam*6/100)*1024)/4))
                VisibleApp=$((((GetTotalRam*7/100)*1024)/4))
                SecondaryServer=$((((GetTotalRam*8/100)*1024)/4))
                HiddenApp=$((((GetTotalRam*10/100)*1024)/4))
                ContentProvider=$((((GetTotalRam*15/100)*1024)/4))
                EmptyApp=$((((GetTotalRam*19/100)*1024)/4))         
            else   
                echo "method not found" | tee -a $saveLog;
                StopModify="yes"
            fi;
            if [ $StopModify == "no" ];then
                if [ -e /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk ]; then
                    chmod 0666 /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk;
                    echo "0" > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
                    chmod 0644 /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk;
                    setprop lmk.autocalc false
                    #  echo "* Adaptive LMK = Disabled *" |  tee -a $LOG;
                fi;
                if [ -e /sys/module/lowmemorykiller/parameters/debug_level ]; then
                    chmod 0666 /sys/module/lowmemorykiller/parameters/debug_level;
                    echo "0" > /sys/module/lowmemorykiller/parameters/debug_level
                    chmod 0644 /sys/module/lowmemorykiller/parameters/debug_level;
                    #  echo "* LMK Debug Level = Disabled *" |  tee -a $LOG;
                fi;

                chmod 0666 /sys/module/lowmemorykiller/parameters/adj;
                chmod 0666 /sys/module/lowmemorykiller/parameters/minfree;
                echo "0,120,230,415,910,1000" > /sys/module/lowmemorykiller/parameters/adj
                echo "$ForegroundApp,$VisibleApp,$SecondaryServer,$HiddenApp,$ContentProvider,$EmptyApp" > /sys/module/lowmemorykiller/parameters/minfree
                chmod 0644 /sys/module/lowmemorykiller/parameters/minfree;
                chmod 0644 /sys/module/lowmemorykiller/parameters/adj;

                minFreeSet=$(($GetTotalRam*4))

                sysctl -e -w vm.min_free_kbytes=$minFreeSet 2>/dev/null
                if [ -e /proc/sys/vm/extra_free_kbytes ]; then
                    setprop sys.sysctl.extra_free_kbytes $minFreeSet
                fi;
            fi;
            # echo "done,selamat menikmati.. eh merasakan modul ini\ncuma makanan yg bisa di nikmati" | tee -a $saveLog;
        fi;
        echo "  --- --- --- --- --- " | tee -a $saveLog 
    fi
# custom ram managent end
# custom zram start
    StopZramSet="iya"
    if [ "$FromTerminal" == "ya" ];then
        StopZramSet="kaga"
    fi
    GetBusyBox="none"
    PathBusyBox="none"
    for i in /system/bin /system/xbin /sbin /su/xbin; do
        if [ "$GetBusyBox" == "none" ]; then
            if [ -f $i/busybox ]; then
                GetBusyBox=$i/busybox;
            fi;
            PathBusyBox=$i
        fi;
    done;
    if [ "$GetBusyBox" == "none" ];then
        StopZramSet="iya"
        echo "need busybox to set Zram " | tee -a $saveLog 
        echo "  --- --- --- --- --- " | tee -a $saveLog 
    else
        GetTotalRam=$(free -m | awk '/Mem:/{print $2}');
        if [ "$CustomZram" == "1" ];then
            SetZramTo="1073741824"
        elif [ "$CustomZram" == "2" ];then
            SetZramTo="2147483648"
        elif [ "$CustomZram" == "3" ];then
            SetZramTo="3221225472"
        elif [ "$CustomZram" == "4" ];then
            SetZramTo="4294967296"
        elif [ "$CustomZram" == "5" ];then
            SetZramTo="5368709120‬"
        elif [ "$CustomZram" == "6" ];then
            SetZramTo="6442450944‬"
        elif [ "$CustomZram" == "7" ];then
            SetZramTo="7516192768"
        elif [ "$CustomZram" == "8" ];then
            SetZramTo="8589934592‬"
        elif [ "$CustomZram" == "0" ];then
        #  disable zram
            if [ -e /dev/block/zram0 ]; then
                StopZramSet="iya"
                echo 'disable Zram done .' | tee -a $saveLog;
                $GetBusyBox swapoff /dev/block/zram0
                $GetBusyBox setprop ro.config.zram false
                $GetBusyBox setprop ro.config.zram.support false
                $GetBusyBox setprop zram.disksize 0
                echo 'disable Zram done .' | tee -a $saveLog;
                echo "  --- --- --- --- --- " | tee -a $saveLog 
            fi;
            StopZramSet="iya"
        elif [ "$CustomZram" == "system" ];then
            SetZramTo=$(cat "$PathModulConfig/backup/zram_disksize.txt")
            echo "use Zram default system setting" | tee -a $saveLog 
            echo "  --- --- --- --- --- " | tee -a $saveLog 
        fi
        if [ "$StopZramSet" == "kaga" ];then
            if [ -e /dev/block/zram0 ]; then
                FixSize=$(echo $SetZramTo |  sed "s/-*//g" )
                GetSwapNow=$(getprop zram.disksize |  sed "s/-*//g" )
                if [ "$FixSize" != "$GetSwapNow" ];then
                    stop perfd
                    # echo "use Zram default system setting" | tee -a $saveLog 
                    echo "enable Zram & use $CustomZram Gb done ." | tee -a $saveLog;
                    echo "Set Zram to $SetZramTo Bytes . . ." | tee -a $saveLog;
                    echo "and Swapinnes to $Swapinnes . . ." | tee -a $saveLog;
                    $PathBusyBox/swapoff "/dev/block/zram0"
                    usleep 100000
                    echo "1" > /sys/block/zram0/reset
                    echo "$FixSize" > /sys/block/zram0/disksize | tee -a $saveLog;
                    $PathBusyBox/mkswap "/dev/block/zram0"
                    usleep 100000
                    # setprop ro.config.zram true
                    # setprop ro.config.zram.support true
                    setprop zram.disksize $SetZramTo
                    if [ "$ZramOptimizer" == "1" ];then
                        echo "echo optimize zram setting . . ." | tee -a $saveLog;
                        sysctl -e -w vm.swappiness=$Swapinnes
                        sysctl -e -w vm.dirty_ratio=5
                        sysctl -e -w vm.dirty_background_ratio=1
                        sysctl -e -w vm.drop_caches=3
                        sysctl -e -w vm.vfs_cache_pressure=100
                    else
                        echo "use stock zram setting . . ." | tee -a $saveLog;
                        sysctl -e -w vm.dirty_ratio=$(cat "$PathModulConfig/backup/zram_vm.dirty_ratio.txt")
                        sysctl -e -w vm.dirty_background_ratio=$(cat "$PathModulConfig/backup/zram_vm.dirty_background_ratio.txt")
                        sysctl -e -w vm.drop_caches=$(cat "$PathModulConfig/backup/zram_vm.drop_caches.txt")
                        sysctl -e -w vm.vfs_cache_pressure=$(cat "$PathModulConfig/backup/zram_vm.vfs_cache_pressure.txt")
                    fi
                    $PathBusyBox/swapon "/dev/block/zram0"
                    usleep 100000
                    echo "enable Zram & use $CustomZram Gb done ." | tee -a $saveLog;
                    echo "  --- --- --- --- --- " | tee -a $saveLog 
                    start perfd
                fi
                
            fi;
        fi
    fi
    
# custom zram end

if [ "$LogStatus" == '1' ];then
    # enableLogSystem
    disableLogSystem
elif [ "$LogStatus" == '2' ];then
    # disableLogSystem
    enableLogSystem
fi
if [ "$GetMode" == 'off' ];then
    echo "turn off tweak succeess :D"| tee -a $saveLog;
else
    echo "done,tweak has been turned on" | tee -a $saveLog;
fi;
if [ "$GetMode" == 'turbo' ];then
    echo "NOTE: just tell you if you use this mode your battery will litle drain" | tee -a $saveLog;
fi;
if [ "$FromTerminal" == "tidak" ];then
    #fix gms :p
    if [ "$GMSDoze" == "1" ];then
        GetBusyBox="none"
        if [ -e $Path/ZyC_GmsDoze.log ];then
            rm $Path/ZyC_GmsDoze.log
        fi
        for i in /system/bin /system/xbin /sbin /su/xbin; do
            if [ "$GetBusyBox" == "none" ]; then
                if [ -f $i/busybox ]; then
                    GetBusyBox=$i/busybox;
                fi;
            fi;
        done;
        if [ "$GetBusyBox" == "none " ];then
            echo "GMS Doze fail . . ." | tee -a $Path/ZyC_GmsDoze.log 
        else
            # Stop unnecessary GMS and restart it on boot (dorimanx)
            if [ "$($GetBusyBox pidof com.google.android.gms | wc -l)" -eq "1" ]; then
                $GetBusyBox kill $($GetBusyBox pidof com.google.android.gms) | tee -a $Path/ZyC_GmsDoze.log;
            fi;
            if [ "$($GetBusyBox pidof com.google.android.gms.wearable | wc -l)" -eq "1" ]; then
                $GetBusyBox kill $($GetBusyBox pidof com.google.android.gms.wearable) | tee -a $Path/ZyC_GmsDoze.log;
            fi;
            if [ "$($GetBusyBox pidof com.google.android.gms.persistent | wc -l)" -eq "1" ]; then
                $GetBusyBox kill $($GetBusyBox pidof com.google.android.gms.persistent) | tee -a $Path/ZyC_GmsDoze.log;
            fi;
            if [ "$($GetBusyBox pidof com.google.android.gms.unstable | wc -l)" -eq "1" ]; then
                $GetBusyBox kill $($GetBusyBox pidof com.google.android.gms.unstable) | tee -a $Path/ZyC_GmsDoze.log;
            fi;
            su -c "pm enable com.google.android.gms/.update.SystemUpdateActivity" | tee -a $Path/ZyC_GmsDoze.log;
            su -c "pm enable com.google.android.gms/.update.SystemUpdateService" | tee -a $Path/ZyC_GmsDoze.log;
            su -c "pm enable com.google.android.gms/.update.SystemUpdateService\$ActiveReceiver" | tee -a $Path/ZyC_GmsDoze.log;
            su -c "pm enable com.google.android.gms/.update.SystemUpdateService\$Receiver" | tee -a $Path/ZyC_GmsDoze.log;
            su -c "pm enable com.google.android.gms/.update.SystemUpdateService\$SecretCodeReceiver" | tee -a $Path/ZyC_GmsDoze.log;
            su -c "pm enable com.google.android.gsf/.update.SystemUpdateActivity" | tee -a $Path/ZyC_GmsDoze.log;
            # su -c "pm enable com.google.android.gsf/.update.SystemUpdatePanoActivity" | tee -a $Path/ZyC_GmsDoze.log;
            # su -c "pm enable com.google.android.gsf/.update.SystemUpdateService" | tee -a $Path/ZyC_GmsDoze.log;
            # su -c "pm enable com.google.android.gsf/.update.SystemUpdateService\$Receiver" | tee -a $Path/ZyC_GmsDoze.log;
            # su -c "pm enable com.google.android.gsf/.update.SystemUpdateService\$SecretCodeReceiver" | tee -a $Path/ZyC_GmsDoze.log;
            su -c "pm enable com.google.android.gms/com.google.android.gms.analytics.AnalyticsReceiver" | tee -a $Path/ZyC_GmsDoze.log;
            su -c "pm enable com.google.android.gms/com.google.android.gms.analytics.AnalyticsService" | tee -a $Path/ZyC_GmsDoze.log;
            su -c "pm enable com.google.android.gms/com.google.android.gms.analytics.AnalyticsTaskService" | tee -a $Path/ZyC_GmsDoze.log;
            su -c "pm enable com.google.android.gms/com.google.android.gms.analytics.service.AnalyticsService" | tee -a $Path/ZyC_GmsDoze.log;
            su -c "pm enable com.google.android.gms/com.google.android.gms.chimera.PersistentIntentOperationService" | tee -a $Path/ZyC_GmsDoze.log;
            su -c "pm enable com.google.android.gms/com.google.android.gms.clearcut.debug.ClearcutDebugDumpService" | tee -a $Path/ZyC_GmsDoze.log;
            su -c "pm enable com.google.android.gms/com.google.android.gms.common.stats.GmsCoreStatsService" | tee -a $Path/ZyC_GmsDoze.log;
            su -c "pm enable com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceiver" | tee -a $Path/ZyC_GmsDoze.log;
            su -c "pm enable com.google.android.gms/com.google.android.gms.measurement.AppMeasurementJobService" | tee -a $Path/ZyC_GmsDoze.log;
            su -c "pm enable com.google.android.gms/com.google.android.gms.measurement.AppMeasurementInstallReferrerReceiver" | tee -a $Path/ZyC_GmsDoze.log;
            su -c "pm enable com.google.android.gms/com.google.android.gms.measurement.PackageMeasurementReceiver" | tee -a $Path/ZyC_GmsDoze.log;
            su -c "pm enable com.google.android.gms/com.google.android.gms.measurement.PackageMeasurementService" | tee -a $Path/ZyC_GmsDoze.log;
            su -c "pm enable com.google.android.gms/com.google.android.gms.measurement.service.MeasurementBrokerService" | tee -a $Path/ZyC_GmsDoze.log;
            # su -c "pm enable com.google.android.gms/com.google.android.location.internal.AnalyticsSamplerReceiver" | tee -a $Path/ZyC_GmsDoze.log;
            echo "GMS Doze done . . ." | tee -a $Path/ZyC_GmsDoze.log 
        fi
    fi
    if [ -e "/system/etc/ZyC_Ai/ai_mode.sh" ];then
        BASEDIR=/system/etc/ZyC_Ai
        if [ -e $PathModulConfigAi/ai_status.txt ]; then
            AiStatus=$(cat "$PathModulConfigAi/ai_status.txt")
            if [ "$AiStatus" == "1" ];then
                echo "starting ai mode . . . " | tee -a $saveLog 
                echo "  --- --- --- --- --- " | tee -a $saveLog 
                sh $BASEDIR/ai_mode.sh "fromBoot" & disown & exit 
            elif [ "$AiStatus" == "2" ];then
                echo "re - run ai mode . . . " | tee -a $saveLog 
                echo "  --- --- --- --- --- " | tee -a $saveLog 
                sh $BASEDIR/ai_mode.sh "fromBoot" & disown & exit 
            elif [ "$AiStatus" == "3" ];then
                echo "deactive ai mode . . . " | tee -a $saveLog 
                echo "  --- --- --- --- --- " | tee -a $saveLog 
                sh $BASEDIR/ai_mode.sh "fromBoot" & disown & exit 
            elif [ "$AiStatus" == "0" ];then
                echo "ai status off"| tee -a $saveLog;
                echo "  --- --- --- --- --- " | tee -a $saveLog 
            else
                echo "ai status error,set to 0"| tee -a $saveLog;
                echo '0' > "$PathModulConfigAi/ai_status.txt"
                echo "  --- --- --- --- --- " | tee -a $saveLog 
            fi
        fi
    fi
fi
echo "finished at $(date +"%d-%m-%Y %r")"| tee -a $saveLog;
echo "  --- --- --- --- --->> " | tee -a $saveLog 