##########################################################################################
#
# Magisk Module Template Config Script
# by topjohnwu
#
##########################################################################################
##########################################################################################
#
# Instructions:
#
# 1. Place your files into system folder (delete the placeholder file)
# 2. Fill in your module's info into module.prop
# 3. Configure the settings in this file (config.sh)
# 4. If you need boot scripts, add them into common/post-fs-data.sh or common/service.sh
# 5. Add your additional or modified system properties into common/system.prop
#
##########################################################################################

##########################################################################################
# Configs
##########################################################################################

# Set to true if you need to enable Magic Mount
# Most mods would like it to be enabled
AUTOMOUNT=true

# Set to true if you need to load system.prop
PROPFILE=true

# Set to true if you need post-fs-data script
POSTFSDATA=true

# Set to true if you need late_start service script
LATESTARTSERVICE=true

##########################################################################################
# Installation Message
##########################################################################################

# Set what you want to show when installing your mod

print_modname() {
  ui_print ""
  ui_print "preparing . . ."
  ui_print ""
  ui_print "Modul GG ini(B aja sih) hanya untuk orang ganteng... eh untuk membantu meningkatkan performa GPU(bukan obat GPU YAHUD COK)"
  ui_print ""
  ui_print "thx for some people for help me tested this module :D"
  ui_print ""
  ui_print "This modul help your gpu to increase performance"
  ui_print ""
  ui_print "Created By : ZyCromerZ"
  ui_print ""
  ui_print "hanya untuk max pro m2, boleh di coba untuk yang laen :v "
  ui_print ""
  ui_print "Thx to people for trying this module"
  ui_print ""
  ui_print "kalo install ni tweak teros bootloop FF Gan"
  ui_print ""
  ui_print "this modul not make bootloop!!!"
  ui_print ""
  # ui_print "Hapus other fde.ai,nfs,lkt dari magisk modul, kalo mau ni modul jalan nya maksimal sih ... :D"
  # ui_print ""
  # ui_print "please dont combine this module with other module ( like fde.ai,nfs,lkt) that will not make this modul stronger xD"
  ui_print ""
  ui_print "bisa di install bareng Temod atau disable thermal (pilih 1 aja jangan sekarah) biar makin joss"
  ui_print ""
  ui_print "you can try to flash Thermalmod atau disable thermal (choose 1) for better performance"
  ui_print ""
  ui_print "after reboot check log inside internal/modul_mantul/ZyC_Turbo.log, if is there done,find notes_en.txt and read it xD"
  ui_print ""
  ui_print "setelah restart cek log dalem internal/modul_mantul/ZyC_Turbo.log buat mastin aja :v,car cari notes_id.txt terus BACA"
  ui_print ""
  ui_print "enjoy . . ."
}

##########################################################################################
# Replace list
##########################################################################################

# List all directories you want to directly replace in the system
# Check the documentations for more info about how Magic Mount works, and why you need this

# This is an example
# REPLACE="
# /system/app/Youtube
# /system/priv-app/SystemUI
# /system/priv-app/Settings
# /system/framework
# "

# Construct your own list here, it will override the example above
# !DO NOT! remove this if you don't need to replace anything, leave it empty as it is now
# REPLACE="
# "

##########################################################################################
# Permissions
##########################################################################################

set_permissions() {
  # Only some special files require specific permissions
  # The default permissions should be good enough for most cases

  # Here are some examples for the set_perm functions:

  # set_perm_recursive  <dirname>                <owner> <group> <dirpermission> <filepermission> <contexts> (default: u:object_r:system_file:s0)
  # set_perm_recursive  $MODPATH/system/lib       0       0       0755            0644

  # set_perm  <filename>                         <owner> <group> <permission> <contexts> (default: u:object_r:system_file:s0)
  # set_perm  $MODPATH/system/bin/app_process32   0       2000    0755         u:object_r:zygote_exec:s0
  # set_perm  $MODPATH/system/bin/dex2oat         0       2000    0755         u:object_r:dex2oat_exec:s0
  # set_perm  $MODPATH/system/lib/libart.so       0       0       0644

  # The following is default permissions, DO NOT remove
  bin=xbin
  if [ ! -d $SYS/xbin ]; then
    bin=bin
    mkdir $MODPATH/system/$bin
    mv $MODPATH/system/xbin/zyc_turbo $MODPATH/system/$bin
    mv $MODPATH/system/xbin/zyc_mode $MODPATH/system/$bin
    mv $MODPATH/system/xbin/zyc_render $MODPATH/system/$bin
    mv $MODPATH/system/xbin/zyc_start $MODPATH/system/$bin
    rm -rf $MODPATH/system/xbin/*
    rmdir $MODPATH/system/xbin
  else
    rm -rf $MODPATH/system/bin/*
    rmdir $MODPATH/system/bin
  fi
  set_perm_recursive $MODPATH 0 0 0755 0644
  set_perm_recursive $MODPATH/system/$bin 0 0 0755 0777
  set_perm $MODPATH/service.sh 0 0 0777
  set_perm $MODPATH/system/$bin/zyc_turbo 0 0 0755 0777
  set_perm $MODPATH/system/$bin/zyc_mode 0 0 0755 0777
  set_perm $MODPATH/system/$bin/zyc_render 0 0 0755 0777
  set_perm $MODPATH/system/$bin/zyc_start 0 0 0755 0777
  # set_perm_recursive  $MODPATH  0  0  0755  0644
  # set_perm_recursive  $MODPATH/service.sh 0 0 0755 0777
}

##########################################################################################
# Custom Functions
##########################################################################################

# This file (config.sh) will be sourced by the main flash script after util_functions.sh
# If you need custom logic, please add them here as functions, and call these functions in
# update-binary. Refrain from adding code directly into update-binary, as it will make it
# difficult for you to migrate your modules to newer template versions.
# Make update-binary as clean as possible, try to only do function calls in it.

