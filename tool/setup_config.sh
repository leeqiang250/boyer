#! /bin/bash
SRC_HOME=`pwd`
hexo clean
next=$(cat _config.yml | grep 'theme: next')
#替换主题发布到对应站点库中
    #语法：sed -i '' 's/就内容/新内容/g' 文件
if [ "$next" != "" ]; then
    #主题next替换成jacman，同步至coding
    sed -i '' 's/theme: next/theme: jacman/g' _config.yml
    sed -i '' "s/github:/#github:/g" _config.yml
    sed -i '' "s/#coding:/coding:/g" _config.yml
else
    #主题jacman替换成next，同步至github
    sed -i '' 's/theme: jacman/theme: next/g' _config.yml
    sed -i '' "s/coding:/#coding:/g" _config.yml
    sed -i '' "s/#github:/github:/g" _config.yml
fi

cd ../
if [ -f _config.yml.backup ]; then
    echo "_config.yml已经备份过"
else
    #备份Hexo自带设置文件
    mv _config.yml _config.yml.backup
    #在`pwd`目录下创建库中的设置文件的提示替身
    ln -s ${SRC_HOME}/_config.yml `pwd`/_config.yml
fi

