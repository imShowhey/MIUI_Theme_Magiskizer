##########################################################################################
#
# MIUI主题 Magisk模块配置脚本
# author: cjybyjk
#
##########################################################################################

##########################################################################################
# 配置
##########################################################################################

# 如果您需要启用 Magic Mount, 请把它设置为 true
# 大多数模块都需要启用它
AUTOMOUNT=true

# 如果您需要加载 system.prop, 请把它设置为 true
PROPFILE=false

# 如果您需要执行 post-fs-data 脚本, 请把它设置为 true
POSTFSDATA=false

# 如果您需要执行 service 脚本, 请把它设置为 true
LATESTARTSERVICE=false

##########################################################################################
# 安装信息
##########################################################################################

# 在这里设置您想要在模块安装过程中显示的信息

print_modname() {
  ui_print "*******************************"
  ui_print "        MIUI_Theme_Module"
  ui_print "Created by MIUI_Theme_Magiskizer"
  ui_print "*******************************"
}

##########################################################################################
# 替换列表
##########################################################################################

# 列出您想在系统中直接替换的所有目录
# 查看文档，了解更多关于Magic Mount如何工作的信息，以及您为什么需要它

# 这是个示例
REPLACE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"

# 在这里构建您自己的列表，它将覆盖上面的示例
# 如果你不需要替换任何东西，!千万不要! 删除它，让它保持现在的状态
REPLACE="
"

##########################################################################################
# 权限设置
##########################################################################################

set_permissions() {
  # 只有一些特殊文件需要特定的权限
  # 默认的权限应该适用于大多数情况

  # 下面是 set_perm 函数的一些示例:

  # set_perm_recursive  <目录>                <所有者> <用户组> <目录权限> <文件权限> <上下文> (默认值是: u:object_r:system_file:s0)
  # set_perm_recursive  $MODPATH/system/lib       0       0       0755        0644

  # set_perm  <文件名>                         <所有者> <用户组> <文件权限> <上下文> (默认值是: u:object_r:system_file:s0)
  # set_perm  $MODPATH/system/bin/app_process32   0       2000      0755       u:object_r:zygote_exec:s0
  # set_perm  $MODPATH/system/bin/dex2oat         0       2000      0755       u:object_r:dex2oat_exec:s0
  # set_perm  $MODPATH/system/lib/libart.so       0       0         0644

  # 以下是默认权限，请勿删除
  set_perm_recursive  $MODPATH  0  0  0755  0644
}

##########################################################################################
# 自定义函数
##########################################################################################

# 这个文件 (config.sh) 将被安装脚本在 util_functions.sh 之后 source 化(设置为环境变量)
# 如果你需要自定义操作, 请在这里以函数方式定义它们, 然后在 update-binary 里调用这些函数
# 不要直接向 update-binary 添加代码，因为这会让您很难将模块迁移到新的模板版本
# 尽量不要对 update-binary 文件做其他修改，尽量只在其中执行函数调用

# 移动指定的文件
move_files() {
  while read lineinText
	do
    sourceFile='system/media/theme/default/'`echo $lineinText | awk -F ' -> ' '{print \$1}'`
    pathtofile=`echo $lineinText | awk -F ' -> ' '{print \$2}'`
    filepath=${pathtofile%/*}
    if [ -f "$MODPATH/$sourceFile" ]; then
      mkdir -p $MODPATH/$filepath
      mv -f $MODPATH/$sourceFile $MODPATH/$pathtofile
    fi
	done < $INSTALLER/common/list_of_moving_files
}
