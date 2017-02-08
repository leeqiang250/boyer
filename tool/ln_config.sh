#!/bin/sh

#  ln_config.sh
#  HexoDeploy
#
#  Created by pengyucheng on 08/02/2017.
#

#替换替身的原始文件
SRC_HOME=`pwd`  # 处于source目录
themename=${TARGET_NAME} #主题名称
themePath=${SRC_HOME}/_config/${themename}.yml
#进入根目录，创建主题配置文件替身
cd ../
ROOT_HOME=`pwd`
updateConfig=${ROOT_HOME}/_config.yml
# 在根目录（即`pwd`目录）下，创建git版本库中的_config.yml的替身
echo "ln -fs ${themePath} ${updateConfig}"
ln -fs ${themePath} ${updateConfig}
#打印效果
logtheme=$(cat ${updateConfig} | grep "${themename}\:") #: 冒号需要反斜杠转译
echo "$logtheme ----"

#执行发布操作
echo "执行发布操作 `pwd`"
hexo g
hexo d
