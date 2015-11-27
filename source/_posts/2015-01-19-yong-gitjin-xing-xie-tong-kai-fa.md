---
layout: post
title: "Git协议介绍"
date: 2015-01-19 19:57:04 +0800
comments: true
categories:
---
###列表：
1. <a href="#Stashing">Stashing</a>
2. <a href="#work">储藏工作</a>
3. <a href="#apply">应用储藏</a>
4. <a href="#applyIndex">被暂存的文件重新暂存</a>
5. <a href="#drop">应用后，移除储藏的内容</a>
6. <a href="#unapply">取消储藏(Un-applying a Stash)</a>
7. <a href="#stash-unapply">新建stash-unapply别名</a>
8. <a href="#stashBranch">从储藏中创建分支</a>

####惨痛经历
 将代码全提交值 默认的head分支中，切换分支后，无法找到分支的严重后果：
 解决办法：
 查看本地的索引的提交日志：
 
 	admin$ git reflog
 		
 			a1d09fd HEAD@{0}: checkout: moving from all to master
			a1d09fd HEAD@{1}: checkout: moving from master to all
			a1d09fd HEAD@{2}: checkout: moving from HEAD to master
			a1d09fd HEAD@{3}: checkout: moving from all to HEAD
根据上面的sh2值，回滚：

	admin$ git reset  —hard  a1d09fd 
这样就可以找回代码.
 	
####<a name="Stashing">Git工具 - 储藏（Stashing）</a>

场景：当项目中某一部分正在编码中，突然接到新任务，又必须换至其他分支去完成。

问题：你不想提交进行了一半的工作，否则以后你无法回到这个工作点。

解决：**<font color="red">git stash </font>**命令。

“Stashing”可以获取工作目录的中间状态，即：将修改过的被追踪的文件和暂存的变更，保存到一个未完结变更的堆栈中，随时可以重新应用。

####<a name="work">储藏工作</a>
演示：
step 1 ：进入项目目录，修改某个文件，有可能还暂存其中的一个变更。
step 2 ：**<font color="red">git status </font>**命令,查看中间状态：
{%codeblock lang:js%}
$ git status
# On branch master
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#      modified:   index.html
#
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#
#      modified:   lib/simplegit.rb
#
{%endcodeblock%}
step 3 : 切换分支，但不提交step 1 中的变更，所以储藏这些变更。
执行**<font color="red">git stash </font>**命令，往堆栈中推送一个新的储藏：
{%codeblock lang:js%}
$ git stash
Saved working directory and index state \
  "WIP on master: 049d078 added the index file"
HEAD is now at 049d078 added the index file
(To restore them type "git stash apply")
{%endcodeblock%}
step 4 : 执行step 2查看目录库，中间状态就不见了：
{%codeblock lang:js%}
$ git status
#######On branch master
nothing to commit, working directory clean
{%endcodeblock%}
这时，你可以方便地切换到其他分支工作；你的变更都保存在栈上。
step 5 : 使用**<font color="red">git stash list</font>**要查看现有的储藏：
{%codeblock lang:js%}
$ git stash list
stash@{0}: WIP on master: 049d078 added the index file
stash@{1}: WIP on master: c264051 Revert "added file_size"
stash@{2}: WIP on master: 21d80a5 added number to log
{%endcodeblock%}
在这个案例中，之前已经进行了两次储藏，所以你可以访问到三个不同的储藏。
####<a name="apply">应用储藏</a>
执行**<font color="red">git stash apply</font>**命令, 可以重新应用最近的一次储藏；
执行**<font color="red">git stash apply stash@{2}</font>**命令，即通过指定储藏的名字，来应用更早的储藏。
{%codeblock lang:js%}
$ git stash apply
# On branch master
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#
#      modified:   index.html
#      modified:   lib/simplegit.rb
#
{%endcodeblock%}
<!--more-->
可以看到 Git 重新修改了你所储藏的那些当时尚未提交的文件。在这个案例里，你尝试应用储藏的工作目录是干净的，并且属于同一分支；但是一个干净的工作目录和应用到相同的分支上并不是应用储藏的必要条件。你可以在其中一个分支上保留一份储藏，随后切换到另外一个分支，再重新应用这些变更。在工作目录里包含已修改和未提交的文件时，你也可以应用储藏——Git 会给出归并冲突如果有任何变更无法干净地被应用。

####<a name="applyIndex">被暂存的文件重新暂存</a>
执行**<font color="red">git stash apply</font>**命令,虽然对文件的变更被重新应用，但是被暂存的文件没有重新被暂存。
执行**<font color="red">git stash apply --index</font>**命令,即可让被暂存的文件重新暂存。
**--index**选项告诉命令重新应用被暂存的变更：
{%codeblock lang:js%}
$ git stash apply --index
# On branch master
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#      modified:   index.html
#
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#
#      modified:   lib/simplegit.rb
#
{%endcodeblock%}
####<a name="drop">应用后，移除储藏的内容</a>
**apply **选项只尝试应用储藏的工作——储藏的内容仍然在栈上。
执行**<font color="red">git stash drop 储藏的名字</font>**命令，，即可从栈中彻底移除储藏内容：
{%codeblock lang:js%}
$ git stash list
stash@{0}: WIP on master: 049d078 added the index file
stash@{1}: WIP on master: c264051 Revert "added file_size"
stash@{2}: WIP on master: 21d80a5 added number to log
$ git stash drop stash@{0}
Dropped stash@{0} (364e91f3f268f0900bc3ee613f9f733e82aaed43)
{%endcodeblock%}
你也可以运行 **<font color="red">git stash pop</font>**命令，来重新应用储藏，同时立刻将其从堆栈中移走。
####<a name="unapply">取消储藏(Un-applying a Stash)</a>
在某些情况下，重新应用了之前的储藏的变更，进行了一些其他的修改后，又想要取消之前所应用储藏的修改。
Git没有提供类似于 **<font color="red">stash unapply</font>**的命令，但是可以通过取消该储藏的补丁达到同样的效果：
{%codeblock lang:js%}
$ git stash show -p stash@{0} | git apply -R
{%endcodeblock%}
同样的，如果你沒有指定具体的某个储藏，Git 会选择最近的储藏：
{%codeblock lang:js%}
$ git stash show -p | git apply -R
{%endcodeblock%}
######<a name="stash-unapply">新建stash-unapply别名</a>
你可能会想要新建一个別名，在你的 Git 里增加一个**<font color="red">stash-unapply</font>** 命，这样更有效率。例如：
{%codeblock lang:js%}
$ git config --global alias.stash-unapply '!git stash show -p | git apply -R'
$ git stash apply
$ #... work work work
$ git stash-unapply
{%endcodeblock%}
####<a name="stashBranch">从储藏中创建分支</a>
如果你储藏了一些工作，暂时不去理会，然后继续在你储藏工作的分支上工作，你在重新应用工作时可能会碰到一些问题。如果尝试应用的变更是针对一个你那之后修改过的文件，你会碰到一个归并冲突并且必须去化解它。如果你想用更方便的方法来重新检验你储藏的变更，你可以运行 git stash branch，这会创建一个新的分支，检出你储藏工作时的所处的提交，重新应用你的工作，如果成功，将会丢弃储藏。
{%codeblock lang:js%}
$ git stash branch testchanges
Switched to a new branch "testchanges"
# On branch testchanges
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#      modified:   index.html
#
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#
#      modified:   lib/simplegit.rb
#
Dropped refs/stash@{0} (f0dfc4d5dc332d1cee34a634182e168c4efc3359)
{%endcodeblock%}
这是一个很棒的捷径来恢复储藏的工作然后在新的分支上继续当时的工作。
=======
* * <a href="#stash-unapply">新建stash-unapply别名</a>
8. <a href="#stashBranch">从储藏中创建分支</a>

####<a name="Stashing">Git工具 - 储藏（Stashing）</a>

场景：当项目中某一部分正在编码中，突然接到新任务，又必须换至其他分支去完成。

问题：你不想提交进行了一半的工作，否则以后你无法回到这个工作点。

解决：**<font color="red">git stash </font>**命令。

“Stashing”可以获取工作目录的中间状态，即：将修改过的被追踪的文件和暂存的变更，保存到一个未完结变更的堆栈中，随时可以重新应用。

####<a name="work">储藏工作</a>
演示：
step 1 ：进入项目目录，修改某个文件，有可能还暂存其中的一个变更。
step 2 ：**<font color="red">git status </font>**命令,查看中间状态：
{%codeblock lang:js %}
$ git status
# On branch master
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#      modified:   index.html
#
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#
#      modified:   lib/simplegit.rb
#
{%endcodeblock%}
step 3 : 切换分支，但不提交step 1 中的变更，所以储藏这些变更。
执行**<font color="red">git stash </font>**命令，往堆栈中推送一个新的储藏：
{%codeblock lang:js %}
$ git stash
Saved working directory and index state \
  "WIP on master: 049d078 added the index file"
HEAD is now at 049d078 added the index file
(To restore them type "git stash apply")
{%endcodeblock%}
step 4 : 执行step 2查看目录库，中间状态就不见了：
{%codeblock lang:js %}
$ git status
#######On branch master
nothing to commit, working directory clean
{%endcodeblock%}
这时，你可以方便地切换到其他分支工作；你的变更都保存在栈上。
step 5 : 使用**<font color="red">git stash list</font>**要查看现有的储藏：
{%codeblock lang:js %}
$ git stash list
stash@{0}: WIP on master: 049d078 added the index file
stash@{1}: WIP on master: c264051 Revert "added file_size"
stash@{2}: WIP on master: 21d80a5 added number to log
{%endcodeblock%}
在这个案例中，之前已经进行了两次储藏，所以你可以访问到三个不同的储藏。
####<a name="apply">应用储藏</a>
执行**<font color="red">git stash apply</font>**命令, 可以重新应用最近的一次储藏；
执行**<font color="red">git stash apply stash@{2}</font>**命令，即通过指定储藏的名字，来应用更早的储藏。
{%codeblock lang:js %}
$ git stash apply
# On branch master
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#
#      modified:   index.html
#      modified:   lib/simplegit.rb
#
{%endcodeblock%}
可以看到 Git 重新修改了你所储藏的那些当时尚未提交的文件。在这个案例里，你尝试应用储藏的工作目录是干净的，并且属于同一分支；但是一个干净的工作目录和应用到相同的分支上并不是应用储藏的必要条件。你可以在其中一个分支上保留一份储藏，随后切换到另外一个分支，再重新应用这些变更。在工作目录里包含已修改和未提交的文件时，你也可以应用储藏——Git 会给出归并冲突如果有任何变更无法干净地被应用。

####<a name="applyIndex">被暂存的文件重新暂存</a>
执行**<font color="red">git stash apply</font>**命令,虽然对文件的变更被重新应用，但是被暂存的文件没有重新被暂存。
执行**<font color="red">git stash apply --index</font>**命令,即可让被暂存的文件重新暂存。
**--index**选项告诉命令重新应用被暂存的变更：
{%codeblock lang:js %}
$ git stash apply --index
# On branch master
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#      modified:   index.html
#
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#
#      modified:   lib/simplegit.rb
#
{%endcodeblock%}
####<a name="drop">应用后，移除储藏的内容</a>
**apply **选项只尝试应用储藏的工作——储藏的内容仍然在栈上。
执行**<font color="red">git stash drop 储藏的名字</font>**命令，，即可从栈中彻底移除储藏内容：
{%codeblock lang:js %}
$ git stash list
stash@{0}: WIP on master: 049d078 added the index file
stash@{1}: WIP on master: c264051 Revert "added file_size"
stash@{2}: WIP on master: 21d80a5 added number to log
$ git stash drop stash@{0}
Dropped stash@{0} (364e91f3f268f0900bc3ee613f9f733e82aaed43)
{%endcodeblock%}
你也可以运行 **<font color="red">git stash pop</font>**命令，来重新应用储藏，同时立刻将其从堆栈中移走。
####<a name="unapply">取消储藏(Un-applying a Stash)</a>
在某些情况下，重新应用了之前的储藏的变更，进行了一些其他的修改后，又想要取消之前所应用储藏的修改。
Git没有提供类似于 **<font color="red">stash unapply</font>**的命令，但是可以通过取消该储藏的补丁达到同样的效果：
{%codeblock lang:js %}
$ git stash show -p stash@{0} | git apply -R
{%endcodeblock%}
同样的，如果你沒有指定具体的某个储藏，Git 会选择最近的储藏：
{%codeblock lang:js%}
$ git stash show -p | git apply -R
{%endcodeblock%}
######<a name="stash-unapply">新建stash-unapply别名</a>
你可能会想要新建一个別名，在你的 Git 里增加一个**<font color="red">stash-unapply</font>** 命，这样更有效率。例如：
{%codeblock lang:js %}
$ git config --global alias.stash-unapply '!git stash show -p | git apply -R'
$ git stash apply
$ #... work work work
$ git stash-unapply
{%endcodeblock%}
####<a name="stashBranch">从储藏中创建分支</a>
如果你储藏了一些工作，暂时不去理会，然后继续在你储藏工作的分支上工作，你在重新应用工作时可能会碰到一些问题。如果尝试应用的变更是针对一个你那之后修改过的文件，你会碰到一个归并冲突并且必须去化解它。如果你想用更方便的方法来重新检验你储藏的变更，你可以运行 git stash branch，这会创建一个新的分支，检出你储藏工作时的所处的提交，重新应用你的工作，如果成功，将会丢弃储藏。
{%codeblock lang:js %}
$ git stash branch testchanges
Switched to a new branch "testchanges"
# On branch testchanges
# Changes to be committed:
#   (use "git reset HEAD <file>..." to unstage)
#
#      modified:   index.html
#
# Changes not staged for commit:
#   (use "git add <file>..." to update what will be committed)
#
#      modified:   lib/simplegit.rb
#
Dropped refs/stash@{0} (f0dfc4d5dc332d1cee34a634182e168c4efc3359)
{%endcodeblock%}
这是一个很棒的捷径来恢复储藏的工作然后在新的分支上继续当时的工作。
