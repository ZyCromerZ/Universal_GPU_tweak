#!/system/bin/sh
# Created By : ZyCromerZ
# tweak gpu
# you can try on off my feature
# prepare function
# sleep 2s
# sialan
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

nohup=nohup
if [ -e "$PathBusyBox/busybox" ];then
    nohup=$PathBusyBox"/busybox nohup"
fi
usleep=usleep
if [ -e "$PathBusyBox/busybox" ];then
    usleep=$PathBusyBox"/busybox usleep"
fi
ModulPath=$(cat /system/etc/ZyC_Ai/magisk_path.txt)
if [ ! -e $ModulPath/system/etc/ZyC_Ai/mod_path.txt ]; then
    .$ModulPath/ZyC_Turbo/initialize.sh & wait
fi
ModPath=$(cat $ModulPath/ZyC_Turbo/system/etc/ZyC_Ai/mod_path.txt)
Path=$ModPath/modul_mantul/ZyC_mod
FromTerminal="tidak";
FromAi="tidak"
if [ ! -z "$1" ];then
    if [ "$1" == "Terminal" ];then
        FromTerminal="ya";
    fi
fi
if [ "$FromTerminal" == "tidak" ];then
    .$ModulPath/ZyC_Turbo/initialize.sh "boot" & wait
    $usleep 5000000
    .$ModulPath/ZyC_Turbo/initialize.sh & wait
fi;
if [ ! -z "$2" ];then
    if [ "$2" == "Ai" ];then
        FromAi="ya";
    fi
fi;
if [ -d /sys/class/kgsl/kgsl-3d0 ]; then
    NyariGPU="/sys/class/kgsl/kgsl-3d0"
elif [ -d /sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0 ]; then
    NyariGPU="/sys/devices/platform/kgsl-3d0.0/kgsl/kgsl-3d0"
elif [ -d /sys/devices/soc/*.qcom,kgsl-3d0/kgsl/kgsl-3d0 ]; then
    NyariGPU="/sys/devices/soc/*.qcom,kgsl-3d0/kgsl/kgsl-3d0"
elif [ -d /sys/devices/soc.0/*.qcom,kgsl-3d0/kgsl/kgsl-3d0 ]; then
    NyariGPU="/sys/devices/soc.0/*.qcom,kgsl-3d0/kgsl/kgsl-3d0"
elif [ -d /sys/devices/platform/*.gpu/devfreq/*.gpu ]; then
    NyariGPU="/sys/devices/platform/*.gpu/devfreq/*.gpu"
elif [ -d /sys/devices/platform/*.mali ]; then
    NyariGPU="/sys/devices/platform/*.mali"
elif [ -d /sys/class/misc/mali0 ]; then
    NyariGPU="/sys/class/misc/mali0"
else
    NyariGPU='';
fi
MissingFile="kaga"
# Path=/sdcard/modul_mantul/ZyC_mod
if [ ! -d "$Path/ZyC_Ai" ]; then
    MissingFile="iya"
fi
PathModulConfigAi=$Path/ZyC_Ai
if [ ! -d "$Path/ZyC_Turbo_config" ]; then
    MissingFile="iya"
fi
PathModulConfig=$Path/ZyC_Turbo_config

if [ -e "$Path/ZyC_Turbo.log" ]; then
    rm $Path/ZyC_Turbo.log
fi
saveLog=$Path/ZyC_Turbo.log
SetOff(){
    echo 'revert setting . . .' | tee -a $saveLog;
    #mengembalikan settingan ke asal :D
    setprop persist.sys.NV_FPSLIMIT 35 
    resetprop --delete persist.sys.NV_FPSLIMIT 
    resetprop --delete persist.sys.NV_POWERMODE 
    resetprop --delete persist.sys.NV_PROFVER 
    resetprop --delete persist.sys.NV_STEREOCTRL 
    resetprop --delete persist.sys.NV_STEREOSEPCHG 
    resetprop --delete persist.sys.NV_STEREOSEP 
    if [ "$NyariGPU" != "" ];then
        if [ -e $NyariGPU/throttling ]; then
            echo $(cat "$PathModulConfig/backup/gpu_throttling.txt") > $NyariGPU/throttling
        fi
        if [ -e $NyariGPU/force_no_nap ]; then
            echo $(cat "$PathModulConfig/backup/gpu_force_no_nap.txt") > $NyariGPU/force_no_nap
        fi
        if [ -e $NyariGPU/force_bus_on ]; then
            echo $(cat "$PathModulConfig/backup/gpu_force_bus_on.txt") > $NyariGPU/force_bus_on
        fi
        if [ -e $NyariGPU/force_clk_on ]; then
            echo $(cat "$PathModulConfig/backup/gpu_force_clk_on.txt") > $NyariGPU/force_clk_on
        fi
        if [ -e $NyariGPU/force_rail_on ]; then
            echo $(cat "$PathModulConfig/backup/gpu_force_rail_on.txt") > $NyariGPU/force_rail_on
        fi
        if [ -e $NyariGPU/bus_split ]; then
            echo $(cat "$PathModulConfig/backup/gpu_bus_split.txt") > $NyariGPU/bus_split
        fi
        if [ -e $NyariGPU/max_pwrlevel ]; then
            echo $(cat "$PathModulConfig/backup/gpu_max_pwrlevel.txt") > $NyariGPU/max_pwrlevel
        fi
        if [ -e $NyariGPU/devfreq/adrenoboost ]; then
            echo $(cat "$PathModulConfig/backup/gpu_adrenoboost.txt") > $NyariGPU/devfreq/adrenoboost
        fi
        if [ -e $NyariGPU/devfreq/thermal_pwrlevel ]; then
            echo $(cat "$PathModulConfig/backup/gpu_thermal_pwrlevel.txt") > $NyariGPU/devfreq/thermal_pwrlevel
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
    fi
    if [ "$FromAi" == "ya" ];then
        if [ "$CustomRamAdj" == "tweak" ];then
            if [ "$(cat "/sys/module/lowmemorykiller/parameters/adj")" != "0,110,220,355,850,1000" ];then
                echo "0,110,220,355,850,1000" > /sys/module/lowmemorykiller/parameters/adj
            fi
        fi
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
            echo "0" > $NyariGPU/max_pwrlevel
        fi
        if [ -e $NyariGPU/devfreq/adrenoboost ]; then
            echo "2" > $NyariGPU/devfreq/adrenoboost
        fi
    fi
    echo 'use "on" done. . .' | tee -a $saveLog;
    echo "  --- --- --- --- --- " | tee -a $saveLog

}
SetTurbo(){
    #fps limit ke 120
    echo 'use "turbo" setting. . .' | tee -a $saveLog;
    setprop persist.sys.NV_FPSLIMIT 120
    if  [ "$NyariGPU" != '' ];then
        if [ -e $NyariGPU/devfreq/adrenoboost ]; then
            echo "4" > $NyariGPU/devfreq/adrenoboost
            if [ $NyariGPU/devfreq/adrenoboost != "4" ];then
                echo "3" > $NyariGPU/devfreq/adrenoboost
            fi
        fi
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
        if [ -e "/sys/class/thermal/thermal_message/sconfig" ];then
            chmod 0664 "/sys/class/thermal/thermal_message/sconfig"
            echo "-1" > "/sys/class/thermal/thermal_message/sconfig"
            chmod 0444 "/sys/class/thermal/thermal_message/sconfig"
        fi
        if [ -e $NyariGPU/dvfs_period ];then
            echo "1000" > $NyariGPU/dvfs_period
        fi
        if [ -e $NyariGPU/dvfs/dvfs_period ];then
            echo "1000" > $NyariGPU/dvfs/dvfs_period
        fi
        if [ -e $NyariGPU/dvfs/period ];then
            echo "1000" > $NyariGPU/dvfs/period
        fi
        if [ -e "$NyariGPU/power_policy" ];then
            echo "always_on" > $NyariGPU/power_policy
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
    # disable fsync 
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
LagMode(){
    if [ "$FromAi" == "ya" ];then
        if [ "$CustomRamAdj" == "tweak" ];then
            if [ "$(cat "/sys/module/lowmemorykiller/parameters/adj")" != "0,100,200,300,900,906" ];then
                echo "0,100,200,300,900,906" > /sys/module/lowmemorykiller/parameters/adj
            fi
        fi
    fi
    if [ "$NyariGPU" != '' ];then
        if [ -e $NyariGPU/max_pwrlevel ]; then
            if [ -e $NyariGPU/num_pwrlevels ];then
                numPwrlevels=$(cat $NyariGPU/num_pwrlevels)
                echo $((($numPwrlevels/2)-1)) > $NyariGPU/max_pwrlevel
            fi
        fi
        if [ -e $NyariGPU/devfreq/adrenoboost ]; then
            echo "0" > $NyariGPU/devfreq/adrenoboost
        fi
        if [ -e $NyariGPU/throttling ]; then
            echo "1" > $NyariGPU/throttling
        fi
        if [ -e "$NyariGPU/force_no_nap" ]; then
            echo "1" > $NyariGPU/force_no_nap
        fi
        if [ -e "$NyariGPU/force_bus_on" ]; then
            echo "1" > $NyariGPU/force_bus_on
        fi
        if [ -e "$NyariGPU/force_clk_on" ]; then
            echo "1" > $NyariGPU/force_clk_on
        fi
        if [ -e "$NyariGPU/force_rail_on" ]; then
            echo "1" > $NyariGPU/force_rail_on
        fi
        if [ -e "$NyariGPU/bus_split" ]; then
            echo "0" > $NyariGPU/bus_split
        fi
    fi
}
systemFsync(){
    echo 'use fsync system setting . . .' | tee -a $saveLog;
    if [ ! -e "$PathModulConfig/backup/misc_Dyn_fsync_active".txt ]; then
        if [ -e /sys/kernel/dyn_fsync/Dyn_fsync_active ]; then
            echo $(cat  "$PathModulConfig/backup/misc_Dyn_fsync_active.txt") > /sys/kernel/dyn_fsync/Dyn_fsync_active
        fi
    fi

    if [ ! -e "$PathModulConfig/backup/misc_class_fsync_enabled".txt ]; then
        if [ -e /sys/class/misc/fsynccontrol/fsync_enabled ]; then
            echo $(cat  "$PathModulConfig/backup/misc_class_fsync_enabled.txt") > /sys/class/misc/fsynccontrol/fsync_enabled
        fi 
    fi

    if [ ! -e "$PathModulConfig/backup/misc_fsync".txt ]; then
        if [ -e /sys/module/sync/parameters/fsync ]; then
            echo $(cat  "$PathModulConfig/backup/misc_fsync.txt") > /sys/module/sync/parameters/fsync
        fi
    fi

    if [ ! -e "$PathModulConfig/backup/misc_module_fsync_enabled".txt ]; then
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
    setprop debug.atrace.tags.enableflags 0 
    setprop profiler.force_disable_ulog true 
    setprop profiler.force_disable_err_rpt true 
    setprop profiler.force_disable_ulog 1 
    setprop profiler.force_disable_err_rpt 1 
    setprop ro.config.nocheckin 1 
    setprop debugtool.anrhistory 0 
    setprop ro.com.google.locationfeatures 0 
    setprop ro.com.google.networklocation 0 
    setprop profiler.debugmonitor false 
    setprop profiler.launch false 
    setprop profiler.hung.dumpdobugreport false 
    setprop persist.service.pcsync.enable 0 
    setprop persist.service.lgospd.enable 0 
    setprop persist.sys.purgeable_assets 1 
    echo 'disable log and monitoring done .' | tee -a $saveLog;
    echo "  --- --- --- --- --- " | tee -a $saveLog 
}
enableLogSystem(){
# Enable stats logging & monitoring
    echo 'enable log and monitoring . . .' | tee -a $saveLog;
    setprop debug.atrace.tags.enableflags 1 
    setprop profiler.force_disable_ulog false 
    setprop profiler.force_disable_err_rpt false 
    setprop profiler.force_disable_ulog 0 
    setprop profiler.force_disable_err_rpt 0 
    setprop ro.config.nocheckin 0 
    setprop debugtool.anrhistory 1 
    setprop ro.com.google.locationfeatures 1 
    setprop ro.com.google.networklocation 1 
    setprop profiler.debugmonitor true 
    setprop profiler.launch true 
    setprop profiler.hung.dumpdobugreport true 
    setprop persist.service.pcsync.enable 1 
    setprop persist.service.lgospd.enable 1 
    setprop persist.sys.purgeable_assets 0 
    echo 'enable log and monitoring done .' | tee -a $saveLog;
    echo "  --- --- --- --- --- " | tee -a $saveLog
}
runScript(){
    echo "<<--- --- --- --- --- " | tee -a $saveLog 
    echo "starting modules . . ." | tee -a $saveLog 
    echo "Version : $(cat "$PathModulConfig/notes_en.txt" | grep 'Version:' | sed "s/Version:*//g" )" 
    if [ "$FromTerminal" == "tidak" ];then
        echo "running with boot detected" | tee -a $saveLog 
    elif [ "$FromAi" == "ya" ];then
        echo "running with ai detected" | tee -a $saveLog 
    else
        echo "running without boot detected" | tee -a $saveLog 
    fi
    echo "  --- --- --- --- --- " | tee -a $saveLog 
    # status modul
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
    GpuBooster="not found"
    if [ -e $NyariGPU/devfreq/adrenoboost ];then
        if [ ! -e "$PathModulConfig/GpuBooster.txt" ]; then
            MissingFile="iya"
        fi
        GpuBooster=$(cat "$PathModulConfig/GpuBooster.txt")
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
    # log backup nya
        if [ "$MissingFile" == "iya" ]; then
            .$ModulPath/ZyC_Turbo/initialize.sh "boot" & wait
            .$ModulPath/ZyC_Turbo/initialize.sh & wait
        fi
    # end log backup

    GetMode=$(cat "$PathModulConfig/status_modul.txt")
    RenderMode=$(cat "$PathModulConfig/mode_render.txt")
    TotalFps=$(cat "$PathModulConfig/total_fps.txt")
    LogStatus=$(cat "$PathModulConfig/disable_log_system.txt")
    FastCharge=$(cat "$PathModulConfig/fastcharge.txt")
    fsyncMode=$(cat "$PathModulConfig/fsync_mode.txt")
    CustomRam=$(cat "$PathModulConfig/custom_ram_management.txt")
    CustomRamAdj=$(cat "$PathModulConfig/custom_ram_management_adj.txt")
    GMSDoze=$(cat "$PathModulConfig/gms_doze.txt")
    CustomZram=$(cat "$PathModulConfig/zram.txt")
    Swapinnes=$(cat "$PathModulConfig/swapinnes.txt")
    ZramOptimizer=$(cat "$PathModulConfig/zram_optimizer.txt")
    GetDnsType=$(cat "$PathModulConfig/dns.txt")
    if [ -e "$NyariGPU/devfreq/adrenoboost" ];then
        GpuBooster=$(cat "$PathModulConfig/GpuBooster.txt")
    fi
    # ngator mode start
        if [ "$GetMode" == 'off' ];then
            SetOff 2>/dev/null 1>/dev/null
            echo "turn off tweak" | tee -a $saveLog;
            echo "  --- --- --- --- --- " | tee -a $saveLog
        elif [ "$GetMode" == 'on' ];then
            SetOff 2>/dev/null 1>/dev/null
            SetOn 2>/dev/null 1>/dev/null
            # disableFsync
            echo "setting to mode on" | tee -a $saveLog;
            echo "  --- --- --- --- --- " | tee -a $saveLog
        elif [ "$GetMode" == 'turbo' ];then
            SetOn 2>/dev/null 1>/dev/null
            SetTurbo 2>/dev/null 1>/dev/null
            # disableFsync
            # disableThermal
            if [ "$fsyncMode" == "auto" ] && [ "$FromAi" == "ya" ];then
                disableFsync 2>/dev/null 1>/dev/null
                echo "disable fysnc" | tee -a $saveLog;
                echo "  --- --- --- --- --- " | tee -a $saveLog
            fi
            echo "swith to turbo mode" | tee -a $saveLog;
            echo "  --- --- --- --- --- " | tee -a $saveLog
        elif [ "$GetMode" == 'lag' ];then
            # SetOff
            LagMode 2>/dev/null 1>/dev/null
            # disableFsync
            echo "setting to mode lag" | tee -a $saveLog;
            echo "  --- --- --- --- --- " | tee -a $saveLog
        else
            SetOff 2>/dev/null 1>/dev/null
            # SetOn
            # disableFsync
            echo "please read guide, mode $GetMode,not found autmatic set to mode off " | tee -a $saveLog;
            echo 'off' > $PathModulConfig/status_modul.txt
            echo "  --- --- --- --- --- " | tee -a $saveLog
        fi
    # ngator mode end

    # enable fastcharge start
        if [ "$(getprop zyc.status.fastcharge)" == "belom" ];then
            if [ "$FastCharge" == "1" ]; then
                setprop zyc.status.fastcharge "sudah"
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
                fi
                echo "  --- --- --- --- --- " | tee -a $saveLog
            fi  
        fi
    # enable fastcharge end

    # set fps ? start
        if [ "$TotalFps" != "0" ] && [ "$GetMode" != 'turbo' ];then
            setprop persist.sys.NV_FPSLIMIT $TotalFps
            echo "custom fps detected, set to $TotalFps" | tee -a $saveLog;
            echo "  --- --- --- --- --- " | tee -a $saveLog
        fi
    # set fps ? end

    # fstrim start
        if [ "$(getprop zyc.status.fstrim)" == "belom" ];then
            if [ -e system/bin/fstrim ]; then
                fstrimDulu | tee -a $Path/ZyC_Turbo.running.log ;
            elif [ -e system/xbin/fstrim ]; then
                fstrimDulu | tee -a $Path/ZyC_Turbo.running.log ;
            fi;
            setprop zyc.status.fstrim "sudah"
        fi
    # fstrim end

    # gpu turbo start
        if [ "$GpuBooster" != "not found" ];then
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
                if [ "$GpuBooster" != "tweak" ];then
                    echo 'tweak' > $PathModulConfig/GpuBooster.txt
                fi
                echo "nice,use default this tweak GpuBoost" | tee -a $saveLog;
            fi
            echo "  --- --- --- --- --- " | tee -a $saveLog
        fi
    # gpu turbo end

    # echo "ok beres dah . . .\n" | tee -a $saveLog;
    # gpu render start
        if [ "$FromTerminal" == "ya" ];then
            if [ "$(getprop zyc.change.render)" == "belom" ];then
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
                        setprop debug.hwui.renderer "$GetBackupGPU"
                        echo "set render gpu to system setting" | tee -a $saveLog;
                    fi
                fi
                setprop zyc.change.render "udah"
                echo "  --- --- --- --- --- " | tee -a $saveLog 
            fi
        fi
    # gpu render end

    # disable fsync start
        if [ "$FromTerminal" == "ya" ];then
            if [ "$fsyncMode" == "0" ];then
                disableFsync
            elif [ "$fsyncMode" == "1" ];then
                enableFsync
            elif [ "$fsyncMode" == "system" ];then
                systemFsync
            else
                if [ "$fsyncMode" != "auto" ];then
                    echo "fsync value error,set to by system" | tee -a $saveLog;
                    echo "  --- --- --- --- --- " | tee -a $saveLog
                    echo 'system' > $PathModulConfig/fsync_mode.txt
                    systemFsync
                fi
                # disableFsync
            fi
        fi
    # disable fsync end

    # custom ram managent start
        if [ "$FromTerminal" == "ya" ];then
            if [ "$(getprop zyc.change.rm)" == "belom" ];then
                if [ "$CustomRam" == '0' ];then
                        # echo "coming_soon :D"| tee -a $saveLog;
                        if [ -e /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk ]; then
                            echo "not use custom ram management,using stock ram management" | tee -a $saveLog;
                            chmod 0666 /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk;
                            echo "1" > "/sys/module/lowmemorykiller/parameters/enable_adaptive_lmk"
                            chmod 0644 /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk;
                            setprop lmk.autocalc true
                        fi
                        if [ -e "$PathModulConfig/backup/ram_debug_level".txt ] && [ -e /sys/module/lowmemorykiller/parameters/debug_level ];then
                            chmod 0666 /sys/module/lowmemorykiller/parameters/debug_level;
                            echo "$(cat "$PathModulConfig/backup/ram_debug_level.txt")" > "/sys/module/lowmemorykiller/parameters/debug_level"
                            chmod 0644 /sys/module/lowmemorykiller/parameters/debug_level;
                            # rm $PathModulConfig/backup/ram_debug_level.txt
                        fi
                        if [ -e "$PathModulConfig/backup/ram_adj".txt ] && [ -e /sys/module/lowmemorykiller/parameters/adj ];then
                            chmod 0666 /sys/module/lowmemorykiller/parameters/adj;
                            # echo $(cat "$PathModulConfig/backup/ram_adj.txt") > "/sys/module/lowmemorykiller/parameters/adj"
                            #ADJ1=0; ADJ2=100; ADJ3=200; ADJ4=300; ADJ5=900; ADJ6=906 # STOCK
                            echo "0,100,200,300,900,906" > /sys/module/lowmemorykiller/parameters/adj
                            chmod 0644 /sys/module/lowmemorykiller/parameters/adj;
                            rm $PathModulConfig/backup/ram_adj.txt
                        fi
                        if [ -e "$PathModulConfig/backup/ram_minfree".txt ] && [ -e /sys/module/lowmemorykiller/parameters/minfree ];then
                            chmod 0666 /sys/module/lowmemorykiller/parameters/minfree;
                            echo "$(cat "$PathModulConfig/backup/ram_minfree.txt")" > "/sys/module/lowmemorykiller/parameters/minfree"
                            chmod 0644 /sys/module/lowmemorykiller/parameters/minfree;
                            rm $PathModulConfig/backup/ram_minfree.txt
                        fi
                        if [ -e "$PathModulConfig/backup/zram_vm".min_free_kbytes.txt ];then
                            sysctl -e -w vm.dirty_ratio=$(cat "$PathModulConfig/backup/zram_vm.min_free_kbytes.txt") 
                        fi
                        # echo "udah mati broo,selamat battery lu aman :V" | tee -a $saveLog;
                else 
                    .$ModulPath/ZyC_Turbo/initialize.sh "Terminal" & wait
                    echo "using custom ram management method $CustomRam" | tee -a $saveLog;
                    StopModify="no"
                    GetTotalRam=$(free -m | awk '/Mem:/{print $2}');
                    if [ "$CustomRam" == "1" ]; then # Method 1
                        ForegroundApp=$((((GetTotalRam*1/100)*1024)/4))
                        VisibleApp=$((((GetTotalRam*2/100)*1024)/4))
                        SecondaryServer=$((((GetTotalRam*3/100)*1024)/4))
                        HiddenApp=$((((GetTotalRam*5/100)*1024)/4))
                        ContentProvider=$((((GetTotalRam*6/100)*1024)/4))
                        EmptyApp=$((((GetTotalRam*7/100)*1024)/4))
                    elif [ "$CustomRam" == "2" ]; then # Method 2
                        ForegroundApp=$((((GetTotalRam*2/100)*1024)/4))
                        VisibleApp=$((((GetTotalRam*3/100)*1024)/4))
                        SecondaryServer=$((((GetTotalRam*4/100)*1024)/4))
                        HiddenApp=$((((GetTotalRam*7/100)*1024)/4))
                        ContentProvider=$((((GetTotalRam*8/100)*1024)/4))
                        EmptyApp=$((((GetTotalRam*9/100)*1024)/4))
                    elif [ "$CustomRam" == "3" ]; then # Method 3
                        ForegroundApp=$((((GetTotalRam*2/100)*1024)/4))
                        VisibleApp=$((((GetTotalRam*3/100)*1024)/4))
                        SecondaryServer=$((((GetTotalRam*5/100)*1024)/4))
                        HiddenApp=$((((GetTotalRam*6/100)*1024)/4))
                        ContentProvider=$((((GetTotalRam*10/100)*1024)/4))
                        EmptyApp=$((((GetTotalRam*12/100)*1024)/4))
                    elif [ "$CustomRam" == "4" ]; then # Method 4
                        ForegroundApp=$((((GetTotalRam*3/100)*1024)/4))
                        VisibleApp=$((((GetTotalRam*4/100)*1024)/4))
                        SecondaryServer=$((((GetTotalRam*5/100)*1024)/4))
                        HiddenApp=$((((GetTotalRam*7/100)*1024)/4))
                        ContentProvider=$((((GetTotalRam*10/100)*1024)/4))
                        EmptyApp=$((((GetTotalRam*14/100)*1024)/4))
                    elif [ "$CustomRam" == "5" ]; then # Method 5
                        ForegroundApp=$((((GetTotalRam*3/100)*1024)/4))
                        VisibleApp=$((((GetTotalRam*4/100)*1024)/4))
                        SecondaryServer=$((((GetTotalRam*5/100)*1024)/4))
                        HiddenApp=$((((GetTotalRam*7/100)*1024)/4))
                        ContentProvider=$((((GetTotalRam*11/100)*1024)/4))
                        EmptyApp=$((((GetTotalRam*15/100)*1024)/4))
                    elif [ "$CustomRam" == "6" ]; then # Method 6
                        ForegroundApp=$((((GetTotalRam*4/100)*1024)/4))
                        VisibleApp=$((((GetTotalRam*5/100)*1024)/4))
                        SecondaryServer=$((((GetTotalRam*6/100)*1024)/4))
                        HiddenApp=$((((GetTotalRam*7/100)*1024)/4))
                        ContentProvider=$((((GetTotalRam*12/100)*1024)/4))
                        EmptyApp=$((((GetTotalRam*15/100)*1024)/4))
                    elif [ "$CustomRam" == "7" ]; then # Method 7
                        ForegroundApp=$((((GetTotalRam*6/100)*1024)/4))
                        VisibleApp=$((((GetTotalRam*7/100)*1024)/4))
                        SecondaryServer=$((((GetTotalRam*8/100)*1024)/4))
                        HiddenApp=$((((GetTotalRam*9/100)*1024)/4))
                        ContentProvider=$((((GetTotalRam*14/100)*1024)/4))
                        EmptyApp=$((((GetTotalRam*18/100)*1024)/4))   
                    elif  [ "$CustomRam" == "8" ]; then # Method 8
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
                    if [ "$StopModify" == "no" ];then
                        if [ -e /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk ]; then
                            chmod 0666 /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk;
                            if [ "$CustomRam" -le "4" ];then
                                echo "1" > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
                                setprop lmk.autocalc true
                            else
                                echo "0" > /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk
                                setprop lmk.autocalc false
                            fi
                            chmod 0644 /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk;
                        fi;
                        if [ -e /sys/module/lowmemorykiller/parameters/debug_level ]; then
                            chmod 0666 /sys/module/lowmemorykiller/parameters/debug_level;
                            echo "0" > /sys/module/lowmemorykiller/parameters/debug_level
                            chmod 0644 /sys/module/lowmemorykiller/parameters/debug_level;
                        fi;

                        chmod 0666 /sys/module/lowmemorykiller/parameters/adj;
                        chmod 0666 /sys/module/lowmemorykiller/parameters/minfree;
                        # echo "0,120,230,415,910,1000" > /sys/module/lowmemorykiller/parameters/adj
                        if [ "$CustomRamAdj" == "tweak" ];then
                            if [ "$(cat "/sys/module/lowmemorykiller/parameters/adj")" != "0,110,220,355,850,1000" ];then
                                echo "0,110,220,355,850,1000" > /sys/module/lowmemorykiller/parameters/adj
                            fi
                        else
                            if [ "$(cat "/sys/module/lowmemorykiller/parameters/adj")" != "0,100,200,300,900,906" ];then
                                echo "0,100,200,300,900,906" > /sys/module/lowmemorykiller/parameters/adj
                            fi
                        fi
                        echo "$ForegroundApp,$VisibleApp,$SecondaryServer,$HiddenApp,$ContentProvider,$EmptyApp" > /sys/module/lowmemorykiller/parameters/minfree
                        chmod 0644 /sys/module/lowmemorykiller/parameters/minfree;
                        chmod 0644 /sys/module/lowmemorykiller/parameters/adj;

                        minFreeSet=$(($GetTotalRam*4))
                        stop perfd
                        sysctl -e -w vm.min_free_kbytes=$minFreeSet;
                        if [ -e /proc/sys/vm/extra_free_kbytes ]; then
                            sysctl -e -w vm.min_free_kbytes=$(($minFreeSet/2));
                            setprop sys.sysctl.extra_free_kbytes $(($minFreeSet/2));
                        fi;
                        start perfd
                    fi;
                    # echo "done,selamat menikmati.. eh merasakan modul ini\ncuma makanan yg bisa di nikmati" | tee -a $saveLog;
                fi;
                setprop zyc.change.rm "udah"
                echo "  --- --- --- --- --- " | tee -a $saveLog
            fi
        fi
    # custom ram managent end
    # custom zram start
        StopZramSet="iya"
        if [ "$FromTerminal" == "ya" ];then
            StopZramSet="kaga"
        fi
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
                if [ "$(getprop zyc.change.zrm)" == "belom" ];then
                    if [ -e /dev/block/zram0 ]; then
                        setprop zyc.change.zrm "udah"
                        StopZramSet="iya"
                        echo 'disable Zram done .' | tee -a $saveLog;
                        $GetBusyBox swapoff /dev/block/zram0 2>/dev/null 1>/dev/null
                        $GetBusyBox setprop zram.disksize 0 2>/dev/null 1>/dev/null
                        echo 'disable Zram done .' | tee -a $saveLog;
                        echo "  --- --- --- --- --- " | tee -a $saveLog
                    fi;
                fi
                StopZramSet="iya"
            elif [ "$CustomZram" == "system" ];then
                SetZramTo=$(cat "$PathModulConfig/backup/zram_disksize.txt")
                echo "use Zram default system setting" | tee -a $saveLog
                echo "  --- --- --- --- --- " | tee -a $saveLog
            fi
            if [ "$SetZramTo" == "0" ];then
                setprop zyc.change.zrm == "udah"
                StopZramSet="iya"
            fi
            if [ "$(getprop zyc.change.zrm)" == "belom" ];then
                stop perfd
                if [ "$StopZramSet" == "kaga" ];then
                    if [ -e /dev/block/zram0 ]; then
                        setprop zyc.change.zrm "udah" 
                        FixSize=$(echo $SetZramTo |  sed "s/-*//g" )
                        GetSwapNow=$(getprop zram.disksize |  sed "s/-*//g" )
                        if [ "$FixSize" != "$GetSwapNow" ];then
                            echo "enable Zram & use $CustomZram Gb done ." | tee -a $saveLog;
                            echo "Set Zram to $SetZramTo Bytes . . ." | tee -a $saveLog;
                            $PathBusyBox/swapoff "/dev/block/zram0" 
                            $usleep 100000
                            echo "1" > /sys/block/zram0/reset
                            echo "$FixSize" > /sys/block/zram0/disksize | tee -a $saveLog;
                            $PathBusyBox/mkswap "/dev/block/zram0" 
                            $usleep 100000
                            setprop zram.disksize $SetZramTo 2>/dev/null 1>/dev/null
                            $PathBusyBox/swapon "/dev/block/zram0" 
                            $usleep 100000
                        fi
                    fi;
                    if [ -e /dev/block/zram1 ]; then
                        setprop zyc.change.zrm "udah" 
                        FixSize=$(echo $SetZramTo |  sed "s/-*//g" )
                        GetSwapNow=$(getprop zram.disksize |  sed "s/-*//g" )
                        if [ "$FixSize" != "$GetSwapNow" ];then
                            echo "enable Zram1 & use $CustomZram Gb done ." | tee -a $saveLog;
                            echo "Set Zram1 to $SetZramTo Bytes . . ." | tee -a $saveLog;
                            $PathBusyBox/swapoff "/dev/block/zram1" 
                            $usleep 100000
                            echo "1" > /sys/block/zram1/reset
                            echo "$FixSize" > /sys/block/zram1/disksize | tee -a $saveLog;
                            $PathBusyBox/mkswap "/dev/block/zram1" 
                            $usleep 100000
                            setprop zram.disksize $SetZramTo 2>/dev/null 1>/dev/null
                            $PathBusyBox/swapon "/dev/block/zram1" 
                            $usleep 100000
                        fi
                    fi;
                    if [ -e /dev/block/zram2 ]; then
                        setprop zyc.change.zrm "udah" 
                        FixSize=$(echo $SetZramTo |  sed "s/-*//g" )
                        GetSwapNow=$(getprop zram.disksize |  sed "s/-*//g" )
                        if [ "$FixSize" != "$GetSwapNow" ];then
                            echo "enable Zram2 & use $CustomZram Gb done ." | tee -a $saveLog;
                            echo "Set Zram2 to $SetZramTo Bytes . . ." | tee -a $saveLog;
                            $PathBusyBox/swapoff "/dev/block/zram2" 
                            $usleep 100000
                            echo "1" > /sys/block/zram2/reset
                            echo "$FixSize" > /sys/block/zram2/disksize | tee -a $saveLog;
                            $PathBusyBox/mkswap "/dev/block/zram2" 
                            $usleep 100000
                            setprop zram.disksize $SetZramTo 2>/dev/null 1>/dev/null
                            $PathBusyBox/swapon "/dev/block/zram2" 
                            $usleep 100000
                        fi
                    fi;
                    sysctl -e -w vm.swappiness=$Swapinnes 
                    if [ "$ZramOptimizer" == "1" ];then
                        echo "echo optimize zram setting . . ." | tee -a $saveLog;
                        sysctl -e -w vm.dirty_ratio=15 2>/dev/null 1>/dev/null
                        sysctl -e -w vm.dirty_background_ratio=3 2>/dev/null 1>/dev/null
                        sysctl -e -w vm.drop_caches=2 2>/dev/null 1>/dev/null
                        sysctl -e -w vm.vfs_cache_pressure=100 2>/dev/null 1>/dev/null
                    else
                        echo "use stock zram setting . . ." | tee -a $saveLog;
                        if [ ! -z "$(cat $PathModulConfig/backup/zram_vm.dirty_ratio.txt)" ];then
                            sysctl -e -w vm.dirty_ratio=$(cat "$PathModulConfig/backup/zram_vm.dirty_ratio.txt") 2>/dev/null 1>/dev/null
                        fi
                        if [ ! -z "$(cat $PathModulConfig/backup/zram_vm.dirty_background_ratio.txt)" ];then
                            sysctl -e -w vm.dirty_background_ratio=$(cat "$PathModulConfig/backup/zram_vm.dirty_background_ratio.txt") 2>/dev/null 1>/dev/null
                        fi
                        if [ ! -z "$(cat $PathModulConfig/backup/zram_vm.drop_caches.txt)" ];then
                            sysctl -e -w vm.drop_caches=$(cat "$PathModulConfig/backup/zram_vm.drop_caches.txt") 2>/dev/null 1>/dev/null
                        fi
                        if [ ! -z "$(cat $PathModulConfig/backup/zram_vm.vfs_cache_pressure.txt)" ];then
                            sysctl -e -w vm.vfs_cache_pressure=$(cat "$PathModulConfig/backup/zram_vm.vfs_cache_pressure.txt") 2>/dev/null 1>/dev/null
                        fi
                    fi
                    start perfd
                    echo "enable Zram & use $CustomZram Gb done ." | tee -a $saveLog;
                    echo "  --- --- --- --- --- " | tee -a $saveLog
                fi
            fi
        fi
        
    # custom zram end

    if [ "$LogStatus" == '1' ];then
        # enableLogSystem
        disableLogSystem 2>/dev/null 1>/dev/null
    elif [ "$LogStatus" == '2' ];then
        # disableLogSystem
        enableLogSystem 2>/dev/null 1>/dev/null
    fi
    if [ "$GetMode" == 'off' ];then
        echo "turn off tweak succeess :D"| tee -a $saveLog;
    else
        echo "done,tweak has been turned on" | tee -a $saveLog;
    fi;
    if [ "$GetMode" == 'turbo' ];then
        echo "NOTE: just tell you if you use this mode your battery will litle drain" | tee -a $saveLog;
    fi;
    ResetDns(){
        if [ "$FromTerminal" == "ya" ];then
            ip6tables -t nat -F 2>/dev/null 1>/dev/null
            iptables -t nat -F 2>/dev/null 1>/dev/null
            resetprop net.eth0.dns1 2>/dev/null 1>/dev/null
            resetprop net.eth0.dns2 2>/dev/null 1>/dev/null
            resetprop net.dns1 2>/dev/null 1>/dev/null
            resetprop net.dns2 2>/dev/null 1>/dev/null
            resetprop net.ppp0.dns1 2>/dev/null 1>/dev/null
            resetprop net.ppp0.dns2 2>/dev/null 1>/dev/null
            resetprop net.rmnet0.dns1 2>/dev/null 1>/dev/null
            resetprop net.rmnet0.dns2 2>/dev/null 1>/dev/null
            resetprop net.rmnet1.dns1 2>/dev/null 1>/dev/null
            resetprop net.rmnet1.dns2 2>/dev/null 1>/dev/null
            resetprop net.rmnet2.dns1 2>/dev/null 1>/dev/null
            resetprop net.rmnet2.dns2 2>/dev/null 1>/dev/null
            resetprop net.pdpbr1.dns1 2>/dev/null 1>/dev/null
            resetprop net.pdpbr1.dns2 2>/dev/null 1>/dev/null
            resetprop net.wlan0.dns1 2>/dev/null 1>/dev/null
            resetprop net.wlan0.dns2 2>/dev/null 1>/dev/null
            resetprop 2001:4860:4860::8888 2>/dev/null 1>/dev/null
            resetprop 2001:4860:4860::8844 2>/dev/null 1>/dev/null
            resetprop 2606:4700:4700::1111 2>/dev/null 1>/dev/null
            resetprop 2606:4700:4700::1001 2>/dev/null 1>/dev/null
            resetprop 2a00:5a60::ad1:0ff:5353 2>/dev/null 1>/dev/null
            resetprop 2a00:5a60::ad2:0ff:5353 2>/dev/null 1>/dev/null
            # resetprop 2001:67c:28a4:::5353 2>/dev/null 1>/dev/null
            # resetprop 2001:67c:28a4:::5353 2>/dev/null 1>/dev/null
        fi
    }
    if [ "$(getprop zyc.change.dns)" == "belom" ] ;then
        setprop zyc.change.dns 'udah'
        if [ "$GetDnsType" == "cloudflare" ];then
            echo "use cloudflare dns "| tee -a $saveLog
            # reset
            ResetDns
            # reset
            iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination 1.1.1.1:53 2>/dev/null 1>/dev/null
            iptables -t nat -I OUTPUT -p udp --dport 53 -j DNAT --to-destination 1.0.0.1:53 2>/dev/null 1>/dev/null
            iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination 1.1.1.1:53 2>/dev/null 1>/dev/null
            iptables -t nat -I OUTPUT -p tcp --dport 53 -j DNAT --to-destination 1.0.0.1:53 2>/dev/null 1>/dev/null
            ip6tables -t nat -A OUTPUT -p 6 --dport 53 -j DNAT --to-destination  [2606:4700:4700::1111]:53 2>/dev/null 1>/dev/null
            ip6tables -t nat -I OUTPUT -p 6 --dport 53 -j DNAT --to-destination  [2606:4700:4700::1001]:53 2>/dev/null 1>/dev/null
            ip6tables -t nat -A OUTPUT -p 17 --dport 53 -j DNAT --to-destination  [2606:4700:4700::1111]:53 2>/dev/null 1>/dev/null
            ip6tables -t nat -I OUTPUT -p 17 --dport 53 -j DNAT --to-destination  [2606:4700:4700::1001]:53 2>/dev/null 1>/dev/null
            # SETPROP
            setprop net.eth0.dns1 1.1.1.1 2>/dev/null 1>/dev/null
            setprop net.eth0.dns2 1.0.0.1 2>/dev/null 1>/dev/null
            setprop net.dns1 1.1.1.1 2>/dev/null 1>/dev/null
            setprop net.dns2 1.0.0.1 2>/dev/null 1>/dev/null
            setprop net.ppp0.dns1 1.1.1.1 2>/dev/null 1>/dev/null
            setprop net.ppp0.dns2 1.0.0.1 2>/dev/null 1>/dev/null
            setprop net.rmnet0.dns1 1.1.1.1 2>/dev/null 1>/dev/null
            setprop net.rmnet0.dns2 1.0.0.1 2>/dev/null 1>/dev/null
            setprop net.rmnet1.dns1 1.1.1.1 2>/dev/null 1>/dev/null
            setprop net.rmnet1.dns2 1.0.0.1 2>/dev/null 1>/dev/null
            setprop net.rmnet2.dns1 1.1.1.1 2>/dev/null 1>/dev/null
            setprop net.rmnet2.dns2 1.0.0.1 2>/dev/null 1>/dev/null
            setprop net.pdpbr1.dns1 1.1.1.1 2>/dev/null 1>/dev/null
            setprop net.pdpbr1.dns2 1.0.0.1 2>/dev/null 1>/dev/null
            setprop net.wlan0.dns1 1.1.1.1 2>/dev/null 1>/dev/null
            setprop net.wlan0.dns2 1.0.0.1 2>/dev/null 1>/dev/null
            # setprop 2606:4700:4700::1111 '' 2>/dev/null 1>/dev/null
            # setprop 2606:4700:4700::1001 '' 2>/dev/null 1>/dev/null
        elif [ "$GetDnsType" == "google" ];then
            echo "use google dns "| tee -a $saveLog 
            # reset
            ResetDns
            # reset
            iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination 8.8.8.8:53 2>/dev/null 1>/dev/null
            iptables -t nat -I OUTPUT -p udp --dport 53 -j DNAT --to-destination 8.8.4.4:53 2>/dev/null 1>/dev/null
            iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination 8.8.8.8:53 2>/dev/null 1>/dev/null
            iptables -t nat -I OUTPUT -p tcp --dport 53 -j DNAT --to-destination 8.8.4.4:53 2>/dev/null 1>/dev/null
            ip6tables -t nat -A OUTPUT -p 6 --dport 53 -j DNAT --to-destination [2001:4860:4860:8888]:53 2>/dev/null 1>/dev/null
            ip6tables -t nat -I OUTPUT -p 6 --dport 53 -j DNAT --to-destination [2001:4860:4860:8844]:53 2>/dev/null 1>/dev/null
            ip6tables -t nat -A OUTPUT -p 17 --dport 53 -j DNAT --to-destination [2001:4860:4860:8888]:53 2>/dev/null 1>/dev/null
            ip6tables -t nat -I OUTPUT -p 17 --dport 53 -j DNAT --to-destination [2001:4860:4860:8844]:53 2>/dev/null 1>/dev/null
            # SETPROP
            setprop net.eth0.dns1 8.8.8.8 2>/dev/null 1>/dev/null
            setprop net.eth0.dns2 8.8.4.4 2>/dev/null 1>/dev/null
            setprop net.dns1 8.8.8.8 2>/dev/null 1>/dev/null
            setprop net.dns2 8.8.4.4 2>/dev/null 1>/dev/null
            setprop net.ppp0.dns1 8.8.8.8 2>/dev/null 1>/dev/null
            setprop net.ppp0.dns2 8.8.4.4 2>/dev/null 1>/dev/null
            setprop net.rmnet0.dns1 8.8.8.8 2>/dev/null 1>/dev/null
            setprop net.rmnet0.dns2 8.8.4.4 2>/dev/null 1>/dev/null
            setprop net.rmnet1.dns1 8.8.8.8 2>/dev/null 1>/dev/null
            setprop net.rmnet1.dns2 8.8.4.4 2>/dev/null 1>/dev/null
            setprop net.rmnet2.dns1 8.8.8.8 2>/dev/null 1>/dev/null
            setprop net.rmnet2.dns2 8.8.4.4 2>/dev/null 1>/dev/null
            setprop net.pdpbr1.dns1 8.8.8.8 2>/dev/null 1>/dev/null
            setprop net.pdpbr1.dns2 8.8.4.4 2>/dev/null 1>/dev/null
            setprop net.wlan0.dns1 8.8.8.8 2>/dev/null 1>/dev/null
            setprop net.wlan0.dns2 8.8.4.4 2>/dev/null 1>/dev/null
            # setprop 2001:4860:4860::8888 '' 2>/dev/null 1>/dev/null
            # setprop 2001:4860:4860::8844 '' 2>/dev/null 1>/dev/null
        elif [ "$GetDnsType" == "adguard" ];then
            echo "use adguard dns "| tee -a $saveLog 
            # reset
            ResetDns
            # reset
            iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination 176.103.130.130:5353
            iptables -t nat -I OUTPUT -p udp --dport 53 -j DNAT --to-destination 176.103.130.131:5353
            iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination 176.103.130.130:5353
            iptables -t nat -I OUTPUT -p tcp --dport 53 -j DNAT --to-destination 176.103.130.131:5353
            ip6tables -t nat -A OUTPUT -p 6 --dport 53 -j DNAT --to-destination  [2a00:5a60::ad1:0ff]:5353 2>/dev/null 1>/dev/null
            ip6tables -t nat -I OUTPUT -p 6 --dport 53 -j DNAT --to-destination  [2a00:5a60::ad2:0ff]:5353 2>/dev/null 1>/dev/null
            ip6tables -t nat -A OUTPUT -p 17 --dport 53 -j DNAT --to-destination  [2a00:5a60::ad1:0ff]:5353 2>/dev/null 1>/dev/null
            ip6tables -t nat -I OUTPUT -p 17 --dport 53 -j DNAT --to-destination  [2a00:5a60::ad2:0ff]:5353 2>/dev/null 1>/dev/null
            # SETPROP
            setprop net.eth0.dns1 176.103.130.130 2>/dev/null 1>/dev/null
            setprop net.eth0.dns2 176.103.130.131 2>/dev/null 1>/dev/null
            setprop net.dns1 176.103.130.130 2>/dev/null 1>/dev/null
            setprop net.dns2 176.103.130.131 2>/dev/null 1>/dev/null
            setprop net.ppp0.dns1 176.103.130.130 2>/dev/null 1>/dev/null
            setprop net.ppp0.dns2 176.103.130.131 2>/dev/null 1>/dev/null
            setprop net.rmnet0.dns1 176.103.130.130 2>/dev/null 1>/dev/null
            setprop net.rmnet0.dns2 176.103.130.131 2>/dev/null 1>/dev/null
            setprop net.rmnet1.dns1 176.103.130.130 2>/dev/null 1>/dev/null
            setprop net.rmnet1.dns2 176.103.130.131 2>/dev/null 1>/dev/null
            setprop net.rmnet2.dns1 176.103.130.130 2>/dev/null 1>/dev/null
            setprop net.rmnet2.dns2 176.103.130.131 2>/dev/null 1>/dev/null
            setprop net.pdpbr1.dns1 176.103.130.130 2>/dev/null 1>/dev/null
            setprop net.pdpbr1.dns2 176.103.130.131 2>/dev/null 1>/dev/null
            setprop net.wlan0.dns1 176.103.130.130 2>/dev/null 1>/dev/null
            setprop net.wlan0.dns2 176.103.130.131 2>/dev/null 1>/dev/null
            # setprop 2a00:5a60::ad1:0ff:5353 '' 2>/dev/null 1>/dev/null
            # setprop 2a00:5a60::ad2:0ff:5353 '' 2>/dev/null 1>/dev/null
        elif [ "$GetDnsType" == "uncensored" ];then
            echo "use uncensored dns "| tee -a $saveLog 
            # reset
            ResetDns
            # reset
            iptables -t nat -A OUTPUT -p udp --dport 53 -j DNAT --to-destination 91.239.100.100:5353 2>/dev/null 1>/dev/null
            iptables -t nat -I OUTPUT -p udp --dport 53 -j DNAT --to-destination 91.239.100.100:5353 2>/dev/null 1>/dev/null
            iptables -t nat -A OUTPUT -p tcp --dport 53 -j DNAT --to-destination 91.239.100.100:5353 2>/dev/null 1>/dev/null
            iptables -t nat -I OUTPUT -p tcp --dport 53 -j DNAT --to-destination 91.239.100.100:5353 2>/dev/null 1>/dev/null
            ip6tables -t nat -A OUTPUT -p 6 --dport 53 -j DNAT --to-destination  [2001:67c:28a4::]:5353 2>/dev/null 1>/dev/null
            ip6tables -t nat -I OUTPUT -p 6 --dport 53 -j DNAT --to-destination  [2001:67c:28a4::]:5353 2>/dev/null 1>/dev/null
            ip6tables -t nat -A OUTPUT -p 17 --dport 53 -j DNAT --to-destination  [2001:67c:28a4::]:5353 2>/dev/null 1>/dev/null
            ip6tables -t nat -I OUTPUT -p 17 --dport 53 -j DNAT --to-destination  [2001:67c:28a4::]:5353 2>/dev/null 1>/dev/null
            # SETPROP
            setprop net.eth0.dns1 91.239.100.100 2>/dev/null 1>/dev/null
            setprop net.eth0.dns2 91.239.100.100 2>/dev/null 1>/dev/null
            setprop net.dns1 91.239.100.100 2>/dev/null 1>/dev/null
            setprop net.dns2 91.239.100.100 2>/dev/null 1>/dev/null
            setprop net.ppp0.dns1 91.239.100.100 2>/dev/null 1>/dev/null
            setprop net.ppp0.dns2 91.239.100.100 2>/dev/null 1>/dev/null
            setprop net.rmnet0.dns1 91.239.100.100 2>/dev/null 1>/dev/null
            setprop net.rmnet0.dns2 91.239.100.100 2>/dev/null 1>/dev/null
            setprop net.rmnet1.dns1 91.239.100.100 2>/dev/null 1>/dev/null
            setprop net.rmnet1.dns2 91.239.100.100 2>/dev/null 1>/dev/null
            setprop net.rmnet2.dns1 91.239.100.100 2>/dev/null 1>/dev/null
            setprop net.rmnet2.dns2 91.239.100.100 2>/dev/null 1>/dev/null
            setprop net.pdpbr1.dns1 91.239.100.100 2>/dev/null 1>/dev/null
            setprop net.pdpbr1.dns2 91.239.100.100 2>/dev/null 1>/dev/null
            setprop net.wlan0.dns1 91.239.100.100 2>/dev/null 1>/dev/null
            setprop net.wlan0.dns2 91.239.100.100 2>/dev/null 1>/dev/null
            # setprop 2001:67c:28a4:::5353 '' 2>/dev/null 1>/dev/null
            # setprop 2001:67c:28a4:::5353 '' 2>/dev/null 1>/dev/null
        else
            if [ "$GetDnsType" != "system" ];then
                echo "system" > "$PathModulConfig/dns.txt"
            fi
            echo "use system dns "| tee -a $saveLog 
            # reset
            ResetDns
            # reset
        fi
        if [ "$GetDnsType" != "system" ];then
            sysctl -e -w net.ipv4.tcp_low_latency=0 2>/dev/null 1>/dev/null
            sysctl -e -w net.ipv4.tcp_dsack=1 2>/dev/null 1>/dev/null
            sysctl -e -w net.ipv4.tcp_ecn=2 2>/dev/null 1>/dev/null
            sysctl -e -w net.ipv4.tcp_timestamps=1 2>/dev/null 1>/dev/null
            sysctl -e -w net.ipv4.tcp_window_scaling=1 2>/dev/null 1>/dev/null
            sysctl -e -w net.ipv4.tcp_sack=1 2>/dev/null 1>/dev/null
            sysctl -e -w net.ipv4.ip_forward=1 2>/dev/null 1>/dev/null
        fi
        echo "  --- --- --- --- --- " | tee -a $saveLog 
    fi
    if [ "$FromTerminal" == "tidak" ];then
        #fix gms :p
        if [ "$GMSDoze" == "1" ];then
            GetBusyBox="none"
            if [ -e "$Path/ZyC_GmsDoze.log" ];then
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
                echo "GMS Doze fail . . ." | tee -a $Path/ZyC_GmsDoze.log 2>/dev/null 1>/dev/null
            else
                echo "Note : better to use universal gms doze :D" | tee -a $Path/ZyC_GmsDoze.log 2>/dev/null 1>/dev/null
                changeSE="tidak"
                if [ "$(getenforce)" == "Enforcing" ];then
                    changeSE="ya"
                    setenforce 0
                fi
                pm disable com.google.android.gms/com.google.android.gms.mdm.receivers.MdmDeviceAdminReceive 2>/dev/null 1>/dev/null
                pm disable com.google.android.gms/com.google.android.gms.auth.managed.admin.DeviceAdminReceive 2>/dev/null 1>/dev/null
                if  [ ! -z "$(pm list packages -f com.google.android.gms)" ] ; then
                    su -c "pm enable com.google.android.gms/.ads.social.GcmSchedulerWakeupService" 2>/dev/null 1>/dev/null
                    su -c "pm enable com.google.android.gms/.analytics.AnalyticsService" 2>/dev/null 1>/dev/null
                    su -c "pm enable com.google.android.gms/.analytics.service.PlayLogMonitorIntervalService" 2>/dev/null 1>/dev/null
                    su -c "pm enable com.google.android.gms/.update.SystemUpdateService" 2>/dev/null 1>/dev/null
                    su -c "pm enable com.google.android.gms/.update.SystemUpdateService\$ActiveReceiver" 2>/dev/null 1>/dev/null
                    su -c "pm enable com.google.android.gms/.update.SystemUpdateService\$Receiver" 2>/dev/null 1>/dev/null
                    su -c "pm enable com.google.android.gms/.update.SystemUpdateService\$SecretCodeReceiver" 2>/dev/null 1>/dev/null
                    su -c "pm enable com.google.android.gms/.update.SystemUpdateActivity" 2>/dev/null 1>/dev/null
                fi
                if  [ ! -z "$(pm list packages -f com.google.android.gsf)" ] ; then
                    su -c "pm enable com.google.android.gsf/.update.SystemUpdatePanoActivity" s2>/dev/null 1>/dev/null
                    su -c "pm enable com.google.android.gsf/.update.SystemUpdateService" s2>/dev/null 1>/dev/null
                    su -c "pm enable com.google.android.gsf/.update.SystemUpdateService\$Receiver" s2>/dev/null 1>/dev/null
                    su -c "pm enable com.google.android.gsf/.update.SystemUpdateService\$SecretCodeReceiver" s2>/dev/null 1>/dev/null
                    su -c "pm enable com.google.android.gsf/.update.SystemUpdateActivity" s2>/dev/null 1>/dev/null
                fi
                if [ "$changeSE" == "ya" ];then
                    setenforce 1
                fi
                if [ -e $MODPATH/system/etc/sysconfig/google.xml.fixed ]; then
                    if [ "$(cat "$MODPATH/system/etc/sysconfig/google.xml.fixed" )" != "$(cat "$MODPATH/system/etc/sysconfig/google.xml" )" ];then
                        cp -af "$MODPATH/system/etc/sysconfig/google.xml.fixed" $MODPATH/system/etc/sysconfig/google.xml 
                    fi
                fi
                if [ -e $MODPATH/system/product/etc/sysconfig/google.xml.fixed ]; then
                    if [ "$(cat "$MODPATH/system/product/etc/sysconfig/google.xml.fixed" )" != "$(cat "$MODPATH/system/product/etc/sysconfig/google.xml" )" ];then
                        cp -af "$MODPATH/system/product/etc/sysconfig/google.xml.fixed" $MODPATH/system/product/etc/sysconfig/google.xml 
                    fi
                fi
                if [ -e $MODPATH/system/system/product/etc/sysconfig/google.xml.fixed ]; then
                    if [ "$(cat "$MODPATH/system/system/product/etc/sysconfig/google.xml.fixed" )" != "$(cat "$MODPATH/system/system/product/etc/sysconfig/google.xml" )" ];then
                        cp -af "$MODPATH/system/system/product/etc/sysconfig/google.xml.fixed" $MODPATH/system/system/product/etc/sysconfig/google.xml 
                    fi
                fi
                echo "GMS Doze done . . ." | tee -a $Path/ZyC_GmsDoze.log 2>/dev/null 1>/dev/null
            fi
        else
            if [ -e $MODPATH/system/etc/sysconfig/google.xml.ori ]; then
                if [ "$(cat "$MODPATH/system/etc/sysconfig/google.xml.ori" )" != "$(cat "$MODPATH/system/etc/sysconfig/google.xml" )" ];then
                    cp -af "$MODPATH/system/etc/sysconfig/google.xml.ori" $MODPATH/system/etc/sysconfig/google.xml 
                fi
            fi
            if [ -e $MODPATH/system/product/etc/sysconfig/google.xml.ori ]; then
                if [ "$(cat "$MODPATH/system/product/etc/sysconfig/google.xml.ori" )" != "$(cat "$MODPATH/system/product/etc/sysconfig/google.xml" )" ];then
                    cp -af "$MODPATH/system/product/etc/sysconfig/google.xml.ori" $MODPATH/system/product/etc/sysconfig/google.xml 
                fi
            fi
            if [ -e $MODPATH/system/system/product/etc/sysconfig/google.xml.ori ]; then
                if [ "$(cat "$MODPATH/system/system/product/etc/sysconfig/google.xml.ori" )" != "$(cat "$MODPATH/system/system/product/etc/sysconfig/google.xml" )" ];then
                    cp -af "$MODPATH/system/system/product/etc/sysconfig/google.xml.ori" $MODPATH/system/system/product/etc/sysconfig/google.xml 
                fi
            fi
        fi
    fi
}
runScript 2>/dev/null 1>/dev/null| tee -a $Path/ZyC_Turbo.running.log ;
if [ "$FromTerminal" == "tidak" ];then
    if [ -e "/system/etc/ZyC_Ai/ai_mode.sh" ];then
        BASEDIR=/system/etc/ZyC_Ai
        if [ -e "$PathModulConfigAi/ai_status.txt" ]; then
            AiStatus="$(cat "$PathModulConfigAi/ai_status.txt")"
            if [ "$AiStatus" == "1" ];then
                echo "starting ai mode . . . " | tee -a $saveLog 2>/dev/null 1>/dev/null
                echo "  --- --- --- --- --- " | tee -a $saveLog 2>/dev/null 1>/dev/null
                echo "ai start at  : $(date +" %r")"| tee -a $Path/ZyC_Turbo.running.log ;
            elif [ "$AiStatus" == "2" ];then
                echo "re - run ai mode . . . " | tee -a $saveLog 2>/dev/null 1>/dev/null
                echo "  --- --- --- --- --- " | tee -a $saveLog 2>/dev/null 1>/dev/null
                echo "ai start at  : $(date +" %r")"| tee -a $Path/ZyC_Turbo.running.log ;
            elif [ "$AiStatus" == "3" ];then
                echo "deactive ai mode . . . " | tee -a $saveLog 2>/dev/null 1>/dev/null
                echo "  --- --- --- --- --- " | tee -a $saveLog 2>/dev/null 1>/dev/null
            elif [ "$AiStatus" == "0" ];then
                echo "ai status off"| tee -a $saveLog 2>/dev/null 1>/dev/null
                echo "  --- --- --- --- --- " | tee -a $saveLog 2>/dev/null 1>/dev/null
            else
                echo "ai status error,set to 0"| tee -a $saveLog 2>/dev/null 1>/dev/null
                echo '0' > "$PathModulConfigAi/ai_status.txt"
                echo "  --- --- --- --- --- " | tee -a $saveLog 2>/dev/null 1>/dev/null
            fi
        fi
    fi
    $nohup .$BASEDIR/ai_mode.sh "fromBoot" 2>/dev/null 1>/dev/null &
fi
echo "finished at $(date +"%d-%m-%Y %r")"| tee -a $saveLog 2>/dev/null 1>/dev/null
echo "  --- --- --- --- --->> " | tee -a $saveLog 2>/dev/null 1>/dev/null