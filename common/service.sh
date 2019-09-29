# Created By : ZyCromerZ
# tweak gpu
# you can try on off my feature
# prepare function
# sleep 2s
# MODDIR=${0%/*}
FromTerminal="tidak";
FromAi="tidak"
if [ ! -z "$1" ];then
    if [ "$1" == "Terminal" ];then
        FromTerminal="ya";
    fi
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

# Path=/sdcard/modul_mantul/ZyC_mod
if [ ! -e /data/mod_path.txt ]; then
    echo "/data/media/0" > /data/mod_path.txt
fi
ModPath=$(cat /data/mod_path.txt)

Path=$ModPath/modul_mantul/ZyC_mod
if [ ! -d $Path/ZyC_Ai ]; then
    mkdir -p $Path/ZyC_Ai
    echo '1' > "$Path/ZyC_Ai/ai_status.txt"
fi
PathModulConfigAi=$Path/ZyC_Ai
if [ ! -d $Path/ZyC_Turbo_config ]; then
    mkdir -p $Path/ZyC_Turbo_config
fi
PathModulConfig=$Path/ZyC_Turbo_config

if [ -e $Path/ZyC_Turbo.log ]; then
    rm $Path/ZyC_Turbo.log
fi
saveLog=$Path/ZyC_Turbo.log

echo "<<--- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1;
echo "starting modules . . ." | tee -a $saveLog > /dev/null 2>&1;
if [ $FromTerminal == "tidak" ];then
    echo "running with boot detected" | tee -a $saveLog > /dev/null 2>&1;
elif [ $FromAi == "ya" ];then
    echo "running with ai detected" | tee -a $saveLog > /dev/null 2>&1;
else
    echo "running without boot detected" | tee -a $saveLog > /dev/null 2>&1;
fi
echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1;
# status modul
if [ ! -e $PathModulConfig/status_modul.txt ]; then
    echo 'turbo' > $PathModulConfig/status_modul.txt
fi
GetMode=$(cat $PathModulConfig/status_modul.txt)

# mode render
if [ ! -e $PathModulConfig/mode_render.txt ]; then
    echo 'skiagl' > $PathModulConfig/mode_render.txt
fi
RenderMode=$(cat $PathModulConfig/mode_render.txt)

# max fps nya
if [ ! -e $PathModulConfig/total_fps.txt ]; then
    echo '0' > $PathModulConfig/total_fps.txt
fi
SetRefreshRate=$(cat $PathModulConfig/total_fps.txt)

# Status Log nya
if [ ! -e $PathModulConfig/disable_log_system.txt ]; then
    echo '1' > $PathModulConfig/disable_log_system.txt
fi
LogStatus=$(cat $PathModulConfig/disable_log_system.txt)

# fast charging
if [ ! -e $PathModulConfig/fastcharge.txt ]; then
    echo '1' > $PathModulConfig/fastcharge.txt
fi
FastCharge=$(cat $PathModulConfig/fastcharge.txt)

# setting adrenoboost
if [ ! -e $PathModulConfig/GpuBooster.txt ]; then
    echo '4' > $PathModulConfig/GpuBooster.txt
fi
GpuBooster=$(cat $PathModulConfig/GpuBooster.txt)

# setting fsync
if [ ! -e $PathModulConfig/fsync_mode.txt ]; then
    echo '0' > $PathModulConfig/fsync_mode.txt
fi
fsyncMode=$(cat $PathModulConfig/fsync_mode.txt)

# setting custom Ram Management
if [ ! -e $PathModulConfig/custom_ram_management.txt ]; then
    echo '0' > $PathModulConfig/custom_ram_management.txt
fi
CustomRam=$(cat $PathModulConfig/custom_ram_management.txt)

# Check notes version
if [ -e $PathModulConfig/notes_en.txt ];then
    if [ "$(cat "$PathModulConfig/notes_en.txt" | grep 'Version:' | sed "s/Version:*//g" )" != "3.341-4 BETA" ];then
        rm $PathModulConfig/notes_en.txt
    fi
fi
if [ -e $PathModulConfig/notes_id.txt ];then
    if [ "$(cat "$PathModulConfig/notes_id.txt" | grep 'Version:' | sed "s/Version:*//g" )" != "3.341-4 BETA" ];then
        rm $PathModulConfig/notes_id.txt
    fi
fi
if [ ! -e $PathModulConfig/notes_en.txt ]; then
    # echo "please read this xD \nyou can set mode.txt to:\n- off \n- on \n- turbo \nvalue must same as above without'-'\n\nchange mode_render.txt to:\n-  opengl \n-  skiagl \n-  skiavk \n\n note:\n-skiavk = Vulkan \n-skiagl = OpenGL (SKIA)\ndont edit total_fps.txt still not tested" > $PathModulConfig/notes.txt
    SetNotes=$PathModulConfig/notes_en.txt;
    echo "This module functions to disable thermal GPU and setting some other parts in the GPU for get better performance, 
provided additional features to make it more better performance :p

There are 2 versions, v3 and v2

For v3:

How to install v3

1.) Download the latest v3 version

2.) Flash via magisk

3.) Reboot

4.) Done



How to update v3.33 version and above

1.) Same as above



How to update versions v3 - v3.33

1.) Set to off mode

2.) Delete the modul_mantul or zyc_turbo_config folder (just check it inside internal memory)

3.) just flash via magisk

4.) Done



How to set a special module version 3.33 and above:

1.) The first way, module settings

Open a terminal type

su

zyc_setting

2.) Only to run auto / ai mode

zyc_auto



If for the previous version 3.32 to 3 (the latest can also only not recomended) there are several ways, namely:

1.) The first way, just to run the module

su

zyc_start



2.) The second way, run the module and change the module mode

zyc_startnamename



3.) The third way, run the module and change the module mode + rendering mode

zyc_start namemode code



4.) The fourth way, change the rendering mode

zyc_render

namarender



5.) The fifth way, change the module mode

zyc_mode

code name



6.) The sixth method, just run the module

zyc_turbo



For module config files in the zyc_turbo_config folder (ignore if file does not exist)

- custom_ram_management.txt

  for custom your ram management
Value = 0 ( use system default ) / 1 (method 1) / 2 (method 2) / 3 (method 3)



- disable_log_system.txt

 disable the cellphone log, is believed to improve the performance of the cellphone

Value = 0 (disable) [recommendation] / 1 (enable)



- fsync_mode.txy

 Disable fsync can improve game fps, if you find a bug in the launcher, enable it!

Values ​​= 0 (disable) [recommendation] / 1 (enable)



- GpuBooster.txt

 For the adrenoboost value setting, if the kernel supports adrenoboost, though.

Value = 0 (disable) / 1 (low) / 2 (medium) / 3 (high) / 4 (set automatically) [recommendation]



- mode_render.txt

 For the cell phone rendering mode settings, there are some ROMs that don't support the rendering mode settings, you can set them here

Value = opengl (OpenGL) / skiagl (OpenGL SKIA) / skiavk (VULKAN)



- status_modul.txt

 for the module mode settings, there are 3 settings

Value = off (on) / on / turbo (fastest mode)



- total_fps.txt

 For the set fps like that, but I don't test anything, leave 0 ae



- fastcharge.txt

 Fastcharge setting if the cellphone supports it

Value = 0 (using system settings) / 1 (tweaked I tried to activate fastcharge on his cellphone)





For module config files in the zyc_ai folder (ignore the missing files)

- ai_status.txt

 For setting the AI ​​status

Value = 0 (off) / 1 (can be turned on) / 2 (currently running) / 3 (currently shutting down)

Note: do not edit status if value 2/3



- list_app_turbo.txt

 List app to enter turbo mode quickly



- list_app_package_detected.txt

 The app list can be added into the turbo list



- status_end_gpu.txt

  Trigger for the module to change the status to off mode based on the gpu usage based inside this value to lowest (for example, the value is 5, if the usage is 5% to down automatically change to off mode)



- status_start_gpu.txt

  Trigger for the module to change the status to turbo mode based on the gpu usage based inside this value to lowest (for example, the value is 70, if the usage is 70% to up automatically change to turbo mode)



- wait_time_off.txt

  Time to check the running app or GPU usage when off mode



- wait_time_on.txt

  Time to check the app that is running or GPU usage when in turbo mode

- ai_notif_mode.txt

 Fot setting ai notification led

Value=0 (off) / 1 (vibration mode) / 2 (notification method 1) / 3 (notification metode 2)



For V2, just flash it via magisk, it will automatically activates after rebooted



Note:

mode = off / on / turbo

namarender = opengl / skiagl / skiavk

Version:3.341-4 BETA" | tee -a $SetNotes > /dev/null 2>&1;
fi
if [ ! -e $PathModulConfig/notes_id.txt ]; then
    SetNotes=$PathModulConfig/notes_id.txt;
    echo "Created By : ZyCromerZ
    
Oke . . .

Jadi gini . . .



Gw mo ngejelasin dikit apa itu modul yg gw bikin

Jadi baca,teros pahami.



Ni modul fungsinya buat disable thermal gpu ama setting beberapa bagian lainnya di bagian gpu biar performa nya makin mantap,di sediakan fitur tambahan biar makin enak & ini mungkin terakhir gw bikin note dengan deskripsi kaya gini :p



Dah lanjut cara install dah . . .

Ada 2 versi,v3 ama v2



Untuk v3 :

Cara install v3

1.) download versi v3 yg terbaru

2.) Flash via magisk

3.) Reboot

4.) Done



Cara update versi v3.33 ke atas

1.) Sama kaya di atas



Cara update versi v3 - v3.33 

1.) Set ke mode off

2.) Delete folder modul_mantul ato zyc_turbo_config (ada di internal cek aja)

3.) Langsung flash via magisk

4.) Done



Cara setting modul khusus versi 3.33 ke atas :

1.) Cara pertama,setting modul

Buka terminal ketik

su

zyc_setting

2.) Hanya untuk menjalankan mode auto/ai

zyc_auto



Kalau untuk versi sebelumnya 3.32 sampai 3 ( terbaru juga bisa cuma not recomen ) ada beberapa cara,yaitu :

1.) Cara pertama,hanya untuk menjalakan modul

su

zyc_start



2.) Cara kedua,menjalankan modul dan ganti mode modul

zyc_start namamode



3.) Cara ketiga,menjalankan modul dan ganti mode modul + mode render

zyc_start namamode namarender



4.) Cara keempat,ganti mode render

zyc_render

namarender



5.) Cara kelima,ganti mode modul

zyc_mode

namamode



6.) Cara keenam,hanya menjalankan modul

zyc_turbo



Untuk file config modul dalam folder zyc_turbo_config (abaikan kalo file ada tidak ada)

- custom_ram_management.txt  

  buat setting ram management nya
Valuenya = 0(pake default)/1(cara 1)/2(cara 2)/3(cara 3)



- disable_log_system.txt

 disable log hp nya,dipercaya bisa meningkatkan performa hp nya

Valuenya = 0(disable)[rekomendasi]/1(enable)



- fsync_mode.txy

 Disable fsync bisa meningkatkan fps game,kalo nemu bug di launchernya enable ini !

Valuenya = 0(disable)[rekomendasi]/1(enable)



- GpuBooster.txt

 Buat setting value adrenoboost nya,kalo kernel support adrenoboost sih.

Value = 0(disable)/1(low)/2(medium)/3(high)/4(di atur otomatis)[rekomendasi]



- mode_render.txt

 Buat setting mode render hp nya,ada beberapa rom yg gak support buat setting mode render,bisa setting di sini

Value = opengl(OpenGL)/skiagl(OpenGL SKIA)/skiavk(VULKAN)



- status_modul.txt

 buat setting mode modul,ada 3 pengaturan

Value = off(mati)/on(hidup)/turbo(mode paling cepat)



- total_fps.txt

 Buat set fps gitu,tapi gw test ga ngaruh apa apa,biarkan 0 ae



- fastcharge.txt

 Setting fastcharge kalo hp situ support

Value = 0(menggunakan settingan system)/1(tweak gw mencoba untuk mengaktifkan fastcharge di hp nya)





Untuk file config modul dalam folder zyc_ai ( abaikan kalo file tidak ada )

- ai_status.txt

 Untuk setting status ai

Value=0(mati)/1(bisa di hidupkan)/2(sedang berjalan)/3(sedang mematikan)

Note:kalau status 2/3 jangan di edit



- list_app_turbo.txt

 List app agar masuk ke mode turbo dengan cepat



- list_app_package_detected.txt

 List app yg bisa di masukan ke mode auto ke list turbo 



- status_end_gpu.txt

 Trigger untuk modul agar mengubah status ke mode off berdasarkan usage gpu dari value yang ada di dalam ini ke terbawah (misalkan isinya 5, kalau usage nya 5% ke bawah otomatis ganti ke mode off)



- status_start_gpu.txt

 Trigger untuk modul agar mengubah status ke mode turbo berdasarkan usage gpu dari value yang ada di dalam ini ke terbawah (misalkan isinya 70,kalau usage nya 70% ke bawah otomatis ganti ke mode turbo)



- wait_time_off.txt

  Waktu untuk ai mengecek app yg di jalankan atau gpu usage hp ketika di mode off



- wait_time_on.txt

  Waktu untuk ai mengecek app yg di jalankan atau gpu usage hp ketika di mode turbo


- ai_notif_mode.txt

 Untuk setting notif led ai

Value=0(mati)/1(mode getaran)/2(notif metode 1)/3(notif metode 2)




Untuk V2 cukup flash teros biarkan,udah otomatis aktif kalo udah reboot



Note :

namamode = off/on/turbo

namarender = opengl/skiagl/skiavk

Version:3.341-4 BETA" | tee -a $SetNotes > /dev/null 2>&1;
    
fi
backupDolo(){
  # backup data dolo boss start
  backup="kaga";
    if [ ! -d $PathModulConfig/backup ]; then
        mkdir -p $PathModulConfig/backup
    fi
  #val gpu nya
    if [ ! -e $PathModulConfig/backup/gpu_throttling.txt ]; then
        if [ -e $NyariGPU/throttling ]; then
            echo $(cat "$NyariGPU/throttling") > "$PathModulConfig/backup/gpu_throttling.txt"
            backup="pake"
            sleep 0.1s
        fi
    fi

    if [ ! -e $PathModulConfig/backup/gpu_force_no_nap.txt ]; then
        if [ -e $NyariGPU/force_no_nap ]; then
            echo $(cat "$NyariGPU/force_no_nap") > "$PathModulConfig/backup/gpu_force_no_nap.txt"
            backup="pake"
            sleep 0.1s
        fi
    fi

    if [ ! -e $PathModulConfig/backup/gpu_force_bus_on.txt ]; then
        if [ -e $NyariGPU/force_bus_on ]; then
            echo $(cat "$NyariGPU/force_bus_on") > "$PathModulConfig/backup/gpu_force_bus_on.txt"
            backup="pake"
            sleep 0.1s
        fi
    fi

    if [ ! -e $PathModulConfig/backup/gpu_force_clk_on.txt ]; then
        if [ -e $NyariGPU/force_clk_on ]; then
            echo $(cat "$NyariGPU/force_clk_on") > "$PathModulConfig/backup/gpu_force_clk_on.txt"
            backup="pake"
            sleep 0.1s
        fi
    fi

    if [ ! -e $PathModulConfig/backup/gpu_force_rail_on.txt ]; then
        if [ -e $NyariGPU/force_rail_on ]; then
            echo $(cat "$NyariGPU/force_rail_on") > "$PathModulConfig/backup/gpu_force_rail_on.txt"
            backup="pake"
            sleep 0.1s
        fi
    fi

    if [ ! -e $PathModulConfig/backup/gpu_bus_split.txt ]; then
        if [ -e $NyariGPU/bus_split ]; then
            echo $(cat "$NyariGPU/bus_split") > "$PathModulConfig/backup/gpu_bus_split.txt"
            backup="pake"
            sleep 0.1s
        fi
    fi

    if [ ! -e $PathModulConfig/backup/gpu_max_pwrlevel.txt ]; then
        if [ -e $NyariGPU/max_pwrlevel ]; then
            echo $(cat "$NyariGPU/max_pwrlevel") > "$PathModulConfig/backup/gpu_max_pwrlevel.txt"
            backup="pake"
            sleep 0.1s
        fi
    fi

    if [ ! -e $PathModulConfig/backup/gpu_adrenoboost.txt ]; then
        if [ -e $NyariGPU/devfreq/adrenoboost ]; then
            echo $(cat "$NyariGPU/devfreq/adrenoboost") > "$PathModulConfig/backup/gpu_adrenoboost.txt"
            backup="pake"
            sleep 0.1s
        fi
    fi

    if [ ! -e $PathModulConfig/backup/gpu_thermal_pwrlevel.txt ]; then
        if [ -e $NyariGPU/devfreq/thermal_pwrlevel ]; then
            echo $(cat "$NyariGPU/devfreq/thermal_pwrlevel") > "$PathModulConfig/backup/gpu_thermal_pwrlevel.txt"
            backup="pake"
            sleep 0.1s
        fi
    fi

  # fsync backup
    if [ ! -e $PathModulConfig/backup/misc_Dyn_fsync_active.txt ]; then
        if [ -e /sys/kernel/dyn_fsync/Dyn_fsync_active ]; then
            echo $(cat  "/sys/kernel/dyn_fsync/Dyn_fsync_active") > "$PathModulConfig/backup/misc_Dyn_fsync_active.txt"
            backup="pake"
            sleep 0.1s
        fi
    fi

    if [ ! -e $PathModulConfig/backup/misc_class_fsync_enabled.txt ]; then
        if [ -e /sys/class/misc/fsynccontrol/fsync_enabled ]; then
            echo $(cat  "/sys/class/misc/fsynccontrol/fsync_enabled") > "$PathModulConfig/backup/misc_class_fsync_enabled.txt"
            backup="pake"
            sleep 0.1s
        fi 
    fi

    if [ ! -e $PathModulConfig/backup/misc_fsync.txt ]; then
        if [ -e /sys/module/sync/parameters/fsync ]; then
            echo $(cat  "/sys/module/sync/parameters/fsync") > "$PathModulConfig/backup/misc_fsync.txt"
            backup="pake"
            sleep 0.1s
        fi
    fi

    if [ ! -e $PathModulConfig/backup/misc_module_fsync_enabled.txt ]; then
        if [ -e /sys/module/sync/parameters/fsync_enabled ]; then
            echo $(cat  "/sys/module/sync/parameters/fsync_enabled") > "$PathModulConfig/backup/misc_module_fsync_enabled.txt"
            backup="pake"
            sleep 0.1s
        fi
    fi
  # log prop bakcup :D
  # Disable stats logging & monitoring
  # debug.atrace.tags.enableflags=0
    if [ ! -e $PathModulConfig/backup/prop_debug.atrace.tags.enableflags.txt ]; then
        echo $(getprop  debug.atrace.tags.enableflags) > "$PathModulConfig/backup/prop_debug.atrace.tags.enableflags.txt"
        backup="pake"
        sleep 0.1s
    fi

    # profiler.force_disable_ulog=true
    if [ ! -e $PathModulConfig/backup/prop_profiler.force_disable_ulog.txt ]; then
        echo $(getprop  profiler.force_disable_ulog) > "$PathModulConfig/backup/prop_profiler.force_disable_ulog.txt"
        backup="pake"
        sleep 0.1s
    fi

    # profiler.force_disable_err_rpt=true
    if [ ! -e $PathModulConfig/backup/prop_profiler.force_disable_err_rpt.txt ]; then
        echo $(getprop  profiler.force_disable_err_rpt) > "$PathModulConfig/backup/prop_profiler.force_disable_err_rpt.txt"
        backup="pake"
        sleep 0.1s
    fi
    
    # profiler.force_disable_err_rpt=1
    if [ ! -e $PathModulConfig/backup/prop_profiler.force_disable_err_rpt.txt ]; then
        echo $(getprop  profiler.force_disable_err_rpt) > "$PathModulConfig/backup/prop_profiler.force_disable_err_rpt.txt"
        backup="pake"
        sleep 0.1s
    fi

    # ro.config.nocheckin=1
    if [ ! -e $PathModulConfig/backup/prop_ro.config.nocheckin.txt ]; then
        echo $(getprop  ro.config.nocheckin) > "$PathModulConfig/backup/prop_ro.config.nocheckin.txt"
        backup="pake"
        sleep 0.1s
    fi

    # debugtool.anrhistory=0
    if [ ! -e $PathModulConfig/backup/prop_debugtool.anrhistory.txt ]; then
        echo $(getprop  debugtool.anrhistory) > "$PathModulConfig/backup/prop_debugtool.anrhistory.txt"
        backup="pake"
        sleep 0.1s
    fi
  # disable log
    if [ $LogStatus == '1' ];then
        # ro.com.google.locationfeatures=0
        if [ ! -e $PathModulConfig/backup/prop_ro.com.google.locationfeatures.txt ]; then
            echo $(getprop  ro.com.google.locationfeatures) > "$PathModulConfig/backup/prop_ro.com.google.locationfeatures.txt"
            backup="pake"
            sleep 0.1s
        fi

        # ro.com.google.networklocation=0
        if [ ! -e $PathModulConfig/backup/prop_ro.com.google.networklocation.txt ]; then
            echo $(getprop  ro.com.google.networklocation) > "$PathModulConfig/backup/prop_ro.com.google.networklocation.txt"
            backup="pake"
            sleep 0.1s
        fi

        # profiler.debugmonitor=false
        if [ ! -e $PathModulConfig/backup/prop_profiler.debugmonitor.txt ]; then
            echo $(getprop  profiler.debugmonitor) > "$PathModulConfig/backup/prop_profiler.debugmonitor.txt"
            backup="pake"
            sleep 0.1s
        fi

        # profiler.launch=false
        if [ ! -e $PathModulConfig/backup/prop_profiler.launch.txt ]; then
            echo $(getprop  profiler.launch) > "$PathModulConfig/backup/prop_profiler.launch.txt"
            backup="pake"
            sleep 0.1s
        fi

        # profiler.hung.dumpdobugreport=false
        if [ ! -e $PathModulConfig/backup/prop_profiler.hung.dumpdobugreport.txt ]; then
            echo $(getprop  profiler.hung.dumpdobugreport) > "$PathModulConfig/backup/prop_profiler.hung.dumpdobugreport.txt"
            backup="pake"
            sleep 0.1s
        fi

        # persist.service.pcsync.enable=0
        if [ ! -e $PathModulConfig/backup/prop_persist.service.pcsync.enable.txt ]; then
            echo $(getprop  persist.service.pcsync.enable) > "$PathModulConfig/backup/prop_persist.service.pcsync.enable.txt"
            backup="pake"
            sleep 0.1s
        fi

        # persist.service.lgospd.enable=0
        if [ ! -e $PathModulConfig/backup/prop_persist.service.lgospd.enable.txt ]; then
            echo $(getprop  persist.service.lgospd.enable) > "$PathModulConfig/backup/prop_persist.service.lgospd.enable.txt"
            backup="pake"
            sleep 0.1s
        fi

        # persist.sys.purgeable_assets=1
        if [ ! -e $PathModulConfig/backup/prop_persist.sys.purgeable_assets.txt ]; then
            echo $(getprop  persist.sys.purgeable_assets) > "$PathModulConfig/backup/prop_persist.sys.purgeable_assets.txt"
            backup="pake"
            sleep 0.1s
        fi
    fi
  # ram management 
    if [ "$CustomRam" != "0" ];then
        if [ ! -e $PathModulConfig/backup/ram_enable_adaptive_lmk.txt ];then
            if [ -e /sys/module/lowmemorykiller/parameters/enable_adaptive_lmk ];then
                echo $(cat "/sys/module/lowmemorykiller/parameters/enable_adaptive_lmk") > "$PathModulConfig/backup/ram_enable_adaptive_lmk.txt"  
                backup="pake"
            fi
        fi
        if [ ! -e $PathModulConfig/backup/ram_debug_level.txt ];then
            if [ -e /sys/module/lowmemorykiller/parameters/debug_level ];then
                echo $(cat "/sys/module/lowmemorykiller/parameters/debug_level") > "$PathModulConfig/backup/ram_debug_level.txt"  
                backup="pake"
            fi
        fi
        if [ ! -e $PathModulConfig/backup/ram_adj.txt ];then
            if [ -e /sys/module/lowmemorykiller/parameters/adj ];then
                echo $(cat "/sys/module/lowmemorykiller/parameters/adj") > "$PathModulConfig/backup/ram_adj.txt"  
                backup="pake"
            fi
        fi
        if [ ! -e $PathModulConfig/backup/ram_minfree.txt ];then
            if [ -e /sys/module/lowmemorykiller/parameters/minfree ];then
                echo $(cat "/sys/module/lowmemorykiller/parameters/minfree") > "$PathModulConfig/backup/ram_minfree.txt"  
                backup="pake"
            fi
        fi
    fi
# backup data dolo boss end
}

backupDolo
# echo 'aelah';
sleep 0.5s
# log backup nya
    if [ $backup == "pake" ]; then
        echo "backup setting done" | tee -a $saveLog;
        echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1;
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
    echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1;
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
    if [ $NyariGPU != '' ];then
        if [ -e $NyariGPU/max_pwrlevel ]; then
            echo "0" > "$NyariGPU/max_pwrlevel"
            echo "0" > "$NyariGPU/max_pwrlevel"
        fi
        if [ -e $NyariGPU/devfreq/adrenoboost ]; then
            echo "3" > "$NyariGPU/devfreq/adrenoboost"
        fi
    fi
    echo 'use "on" done. . .' | tee -a $saveLog;
    echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1;

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
    echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1;
}
fstrimDulu(){
    echo "fstrim data cache & system, please wait" | tee -a $saveLog;
    fstrim -v /cache | tee -a $saveLog;
    fstrim -v /data | tee -a $saveLog;
    fstrim -v /system | tee -a $saveLog;
    echo "done ." | tee -a $saveLog;
    echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1;
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
    echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1;
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
    echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1;
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
    echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1;
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
    echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1;
}

# ngator mode start
    if [ $GetMode == 'off' ];then
        SetOff
        echo "turn off tweak" | tee -a $saveLog;
    elif [ $GetMode == 'on' ];then
        SetOff
        SetOn
        # disableFsync
        echo "setting to mode on" | tee -a $saveLog;
    elif [ $GetMode == 'turbo' ];then
        SetOn
        SetTurbo
        # disableFsync
        # disableThermal
        echo "swith to turbo mode" | tee -a $saveLog;
    else
        SetOff
        SetOn
        # disableFsync
        echo "please read guide, mode $GetMode,not found autmatic set to mode on " | tee -a $saveLog;
        echo 'on' > $PathModulConfig/status_modul.txt
        echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1;
    fi
# ngator mode end

# enable fastcharge start
    if [ $FastCharge == "1" ]; then
        if [ -e /sys/kernel/fast_charge/force_fast_charge ]; then
            echo "tying to enable fastcharging using first method" | tee -a $saveLog;
            echo "2" > /sys/kernel/fast_charge/force_fast_charge
            if [ "$(cat /sys/kernel/fast_charge/force_fast_charge)" == "0" ]; then
                echo "tying to enable fastcharging using second method" | tee -a $saveLog;
                echo "1" > /sys/kernel/fast_charge/force_fast_charge
            fi
            if [ "$(cat /sys/kernel/fast_charge/force_fast_charge)" == "0" ]; then
                echo "fastcharge off,maybe your kernel/phone not support it" | tee -a $saveLog;
            else
                echo "fastcharge on" | tee -a $saveLog;
            fi
            echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1;
        fi
    fi  
# enable fastcharge end

# set fps ? start
    if [ $SetRefreshRate != "0" ];then
        setprop persist.sys.NV_FPSLIMIT $SetRefreshRate
        echo "custom fps detected, set to $SetRefreshRate" | tee -a $saveLog;
        echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1;
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
    if [ $GpuBooster == "0" ];then
        echo "$GpuBooster" > $NyariGPU/devfreq/adrenoboost
        echo "custom GpuBoost detected, set to $GpuBooster" | tee -a $saveLog;
    elif [ $GpuBooster == "1" ];then
        echo "$GpuBooster" > $NyariGPU/devfreq/adrenoboost
        echo "custom GpuBoost detected, set to $GpuBooster" | tee -a $saveLog;
    elif [ $GpuBooster == "2" ];then
        echo "$GpuBooster" > $NyariGPU/devfreq/adrenoboost
        echo "custom GpuBoost detected, set to $GpuBooster" | tee -a $saveLog;
    elif [ $GpuBooster == "3" ];then
        echo "$GpuBooster" > $NyariGPU/devfreq/adrenoboost
        echo "custom GpuBoost detected, set to $GpuBooster" | tee -a $saveLog;
    else
        echo "nice,use default this tweak GpuBoost" | tee -a $saveLog;
        echo '4' > $PathModulConfig/GpuBooster.txt
    fi
    echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1;
# gpu turbo end

# echo "ok beres dah . . .\n" | tee -a $saveLog;
# gpu render start
    if [ $RenderMode == 'skiagl' ];then
        setprop debug.hwui.renderer skiagl
        echo "set render gpu to OpenGL (SKIA) done" | tee -a $saveLog;
    elif [ $RenderMode == 'skiavk' ];then
        setprop debug.hwui.renderer skiavk
        echo "set render gpu to Vulkan (SKIA) done" | tee -a $saveLog;
    elif [ $RenderMode == 'opengl' ];then
        setprop debug.hwui.renderer opengl
        echo "set render gpu to OpenGL default done" | tee -a $saveLog;
    else
        setprop debug.hwui.renderer skiagl
        echo "mode not found,set to OpenGL (skia) " | tee -a $saveLog;
        echo 'skiagl' > $PathModulConfig/mode_render.txt
    fi
    echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1;
# gpu render end

# disable fsync start
    if [ $FromTerminal == "ya" ];then
        if [ $fsyncMode == "0" ];then
            disableFsync
            echo "custom fsync detected, set to disable" | tee -a $saveLog;
        elif [ $fsyncMode == "1" ];then
            enableFsync
            echo "custom fsync detected, set to enable" | tee -a $saveLog;
        else
            disableFsync
            echo "fsync value error,set to disable" | tee -a $saveLog;
            echo '0' > $PathModulConfig/fsync_mode.txt
        fi
        echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1;
    fi
# disable fsync end

# custom ram managent start
    if [ $FromTerminal == "ya" ];then
        if [ $CustomRam == '0' ];then
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
                echo "using custom ram management method $CustomRam" | tee -a $saveLog;
                StopModify="no"
                GetTotalRam=$(free -m | awk '/Mem:/{print $2}');
                if [ "$CustomRam" == "1" ]; then # Method 1
                    ForegroundApp=$(((($GetTotalRam*2/100)*1024)/4))
                    VisibleApp=$(((($GetTotalRam*3/100)*1024)/4))
                    SecondaryServer=$(((($GetTotalRam*5/100)*1024)/4))
                    HiddenApp=$(((($GetTotalRam*6/100)*1024)/4))
                    ContentProvider=$(((($GetTotalRam*10/100)*1024)/4))
                    EmptyApp=$(((($GetTotalRam*12/100)*1024)/4))
                elif [ "$CustomRam" == "2" ]; then # Method 2
                    ForegroundApp=$(((($GetTotalRam*3/100)*1024)/4))
                    VisibleApp=$(((($GetTotalRam*4/100)*1024)/4))
                    SecondaryServer=$(((($GetTotalRam*5/100)*1024)/4))
                    HiddenApp=$(((($GetTotalRam*7/100)*1024)/4))
                    ContentProvider=$(((($GetTotalRam*11/100)*1024)/4))
                    EmptyApp=$(((($GetTotalRam*15/100)*1024)/4))
                elif [ "$CustomRam" == "3" ]; then # Method 3
                    ForegroundApp=$(((($GetTotalRam*4/100)*1024)/4))
                    VisibleApp=$(((($GetTotalRam*5/100)*1024)/4))
                    SecondaryServer=$(((($GetTotalRam*6/100)*1024)/4))
                    HiddenApp=$(((($GetTotalRam*7/100)*1024)/4))
                    ContentProvider=$(((($GetTotalRam*12/100)*1024)/4))
                    EmptyApp=$(((($GetTotalRam*15/100)*1024)/4))
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
        echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1;
    fi
# custom ram managent end

if [ $GetMode == 'off' ];then
    echo "turn off tweak succeess :D"| tee -a $saveLog;
else
    echo "done,tweak has been turned on" | tee -a $saveLog;
fi;
if [ $GetMode == 'turbo' ];then
    echo "NOTE: just tell you if you use this mode your battery will litle drain" | tee -a $saveLog;
fi;
if [ $LogStatus == '1' ];then
    # enableLogSystem
    disableLogSystem
else
    # disableLogSystem
    enableLogSystem
fi
if [ $FromTerminal == "tidak" ];then
    if [ -e "/system/etc/ZyC_Ai/ai_mode.sh" ];then
        BASEDIR=/system/etc/ZyC_Ai
        if [ -e $PathModulConfigAi/ai_status.txt ]; then
            AiStatus=$(cat "$PathModulConfigAi/ai_status.txt")
            if [ $AiStatus == "1" ];then
                echo "starting ai mode . . . " | tee -a $saveLog > /dev/null 2>&1;
                echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1;
                sh $BASEDIR/ai_mode.sh "fromBoot" | tee -a $saveLog;
            elif [ $AiStatus == "2" ];then
                echo "re - run ai mode . . . " | tee -a $saveLog > /dev/null 2>&1;
                echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1;
                sh $BASEDIR/ai_mode.sh "fromBoot" | tee -a $saveLog;
            elif [ $AiStatus == "3" ];then
                echo "deactive ai mode . . . " | tee -a $saveLog > /dev/null 2>&1;
                echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1;
                sh $BASEDIR/ai_mode.sh "fromBoot" | tee -a $saveLog;
            elif [ $AiStatus == "0" ];then
                echo "ai status off"| tee -a $saveLog;
                echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1;
            else
                echo "ai status error,set to 0"| tee -a $saveLog;
                echo '0' > "$PathModulConfigAi/ai_status.txt"
                echo "  --- --- --- --- --- " | tee -a $saveLog > /dev/null 2>&1;
            fi
        fi
    fi
fi
echo "finished at $(date +"%d-%m-%Y %r")"| tee -a $saveLog;
echo "  --- --- --- --- --->> " | tee -a $saveLog > /dev/null 2>&1;
exit 0;