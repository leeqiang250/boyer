#! /bin/bash
SRC_HOME=`pwd`  # 处于source目录
#清空历史
hexo clean
#next=$(cat _config.yml | grep 'theme: next')
#maupassant=$(cat _config.yml | grep 'theme: maupassant')
#替换主题
#语法：sed -i '' 's/就内容/新内容/g' 文件
echo "主题名称：$TARGET_NAME"
themename=$TARGET_NAME
themeLine=$(cat _config.yml | grep 'theme: ') # 替换当前主题
sed -i '' "s/${themeLine}/theme: ${themename}/g" _config.yml

#重置站点库
sed -i '' "s/.*next:/#next:/g" _config.yml
sed -i '' "s/.*maupassant:/#maupassant:/g" _config.yml
sed -i '' "s/.*jacman:/#jacman:/g" _config.yml

#打印站点名称
githubURL="https:\/\/huos3203.github.io"
if [ "$themename" == "jacman" ]; then
    echo "站点：coding"
elif [ "$themename" == "next" ]; then
    #主题next
    echo "站点：github"
    sed -i '' "s/url:.*/url: ${githubURL}/g" _config.yml
elif  [ "$themename" == "maupassant" ]; then
    #主题maupassant
    echo "站点：github/boyer"
    sed -i '' "s/url:.*/url: ${githubURL}\/boyer/g" _config.yml
fi
#打开发布到对应站点库
sed -i '' "s/#${themename}:/${themename}:/g" _config.yml
logtheme=$(cat _config.yml | grep "${themename}\:") #: 冒号需要反斜杠转译
echo "$logtheme ----"


### 进入boyers根目录即：存在_config.yml的目录 ####
cd ../
if [ -f _config.yml.backup ]; then
    echo "_config.yml已经备份过"
else
    #备份Hexo自带设置文件
    mv _config.yml _config.yml.backup
    # 在根目录（即`pwd`目录）下，创建git版本库中的_config.yml的替身
    ln -s ${SRC_HOME}/_config.yml `pwd`/_config.yml
fi

#执行发布操作
echo "执行发布操作 `pwd`"
hexo g
hexo d
