#!/bin/sh

#  postsUpdated.sh
#  HexoDeploy
#
#  Created by pengyucheng on 22/12/2016.
#
#脚本更新博客更新时间
echo "执行 postsUpdated.sh 文件"
#将Git配置变量 core.quotepath 设置为false，就可以解决中文文件名称在这些Git命令输出中的显示问题
git config --global core.quotepath false
git status -s > modified.txt
cat modified.txt | grep 'M _posts' | sed 's/^.*M //g' > postfile.txt
#"重定向法；管道法: cat $FILENAME | while read LINE"
cat postfile.txt | while read line
do
    #逐行循环开始
    postPath=${line}

    if [ -f "${postPath}" ]; then

        echo "--开始替换${postPath}--"
        #直接修改文件内容(危险动作) updated:值
        createdLine=$(cat ${postPath} | grep 'date: 创建时间')
        updatedLine=$(cat ${postPath} | grep 'updated:')
        time=`date '+%Y-%m-%d %H:%M:%S'`
        sed -i '' "s/${createdLine}/date: ${time}/g" ${postPath}
        sed -i '' "s/${updatedLine}/updated: ${time}/g" ${postPath}
        exit 0
    else
        echo "${postPath}不存在"
    fi
done
#删除临时文件
rm -r modified.txt postfile.txt
