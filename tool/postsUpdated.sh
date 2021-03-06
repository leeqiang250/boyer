#!/bin/sh

#  postsUpdated.sh
#  HexoDeploy
#
#  Created by pengyucheng on 22/12/2016.
#
## 脚本不支持带空格的文件名
#脚本更新博客更新时间
echo "执行 postsUpdated.sh 文件"
#将Git配置变量 core.quotepath 设置为false，就可以解决中文文件名称在这些Git命令输出中的显示问题
git config --global core.quotepath false
git status -s > modified.txt
#shell命令过滤文件路径，写入到postfile.txt临时文件中
#原理：根据git status -s 输入来筛选博文文件的更新：文件必须是处于M状态，文件名不能包含空格
#如果文件名中存在空格：git status 输入就会存在双引号
# 例如：M "_posts/Awsome Apple Develop Guide.md"
cat modified.txt | grep 'M.*_posts' | sed 's/^.*M.*_posts//g' | sed 's/md"/md/g' > postfile.txt
#"重定向法 管道法: cat $FILENAME | while read LINE"
if [ -f postfile.txt ]; then
    #读取文件路径，找到文件替换文件内容
    cat postfile.txt | while read line
    do
        #逐行循环开始
        postPath="_posts${line}"
        echo "$postPath"
        if [ -f "${postPath}" ]; then
            #直接修改文件内容(危险动作) updated:值
            createdLine=$(cat ${postPath} | grep 'date: 创建时间')  #当初始值"创建时间"时才更新
            updatedLine=$(cat ${postPath} | grep 'updated: ') # 每次执行都更新
            time=`date '+%Y-%m-%d %H:%M:%S'`
            #替换创建时间
            if [ "$createdLine" != "" ]; then
                echo "--开始替换 date: --"
                sed -i '' "s/${createdLine}/date: ${time}/g" "${postPath}"
            else
                echo "date: 不存在"
            fi
            #替换更新时间
            if [ "$updatedLine" != "" ]; then
                echo "--开始替换 updated: --"
                sed -i '' "s/${updatedLine}/updated: ${time}/g" "${postPath}"
            else
                echo "updated: 不存在"
            fi
    #        exit 0
        else
            echo "${postPath}不存在"
        fi
    done

    echo "移除临时文件"
    rm -r modified.txt postfile.txt # _posts/.\!9*
fi
