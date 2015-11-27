---
layout: post
title: "mupdf集成pyc加密算法"
date: 2015-08-14 10:45:35 +0800
comments: true
categories: 
---
####加密算法中区分64位
```
#if __LP64__ || (TARGET_OS_EMBEDDED && !TARGET_OS_IPHONE) || TARGET_OS_WIN32 || NS_BUILD_32_LIKE_64
    #ifndef uint32
        #define uint32 unsigned int
    #endif
#else
    #ifndef uint32
        #define uint32 unsigned long int
    #endif
#endif
```

1. 把SMS4.h文件内容合并到include/mupdf/fitz/stream.h文件中，然后删除SMS4.h文件
2. 把SMS4.c文件内容合并到source/fitz/stream-open.c 文件中，然后删除SMS4.c
3. 在include/mupdf/fitz/stream.h增加以下内容:  用于方法声明，供其他类使用。
<!--more-->
 ```
 void set_key_info(char* key, long long code_len);  
int pbb_read(int fd, unsigned char *buf, int size);  
int fpbb_read(unsigned char *buf, int count, int size, FILE* fp);  	
 ```  
4. 替换source/pdf/pdf-write.c  2530：fread 替换为 fpbb_read
5. 替换source/fitz/stream-prog.c  57: read 替换为  pbb_read
6. 替换source/fitz/stream-open.c  73: read 替换为  pbb_read 
7. 配置document Type    public.data,public.centent

传递秘钥：
```
char keycode[] = {-12,7,106,95,82,118,-64,-78,-98,5,-3,-128,-28,95,-84,120};      
long long keylength = 37761;  
set_key_info(keycode, keylength);
```
		
####ijkplayer
- https://github.com/kolyvan/kxmovie.git  
- https://github.com/Bilibili/ijkplayer.git
- 支持所有视频格式的操作：
	- cd ijkplyer-master/config/
	- rm module.sh
	- ln -s module-default.sh module.sh
- 加密集成  
  - 处理文件的目录位置：ijkplyer-master/ios/ffmpeg-arm64,armv7,armv7s,i386,x86_64/libavformat目录
  - 把pyckey.h,sms4.h文件内容移动到处理文件目录中的avformat.h文件中
  - 把pyckey.c, sms4.c文件内容移动到处理文件目录中的file.c文件中  
  - 将extra.tar.gz解压，放入ijkplayer-master/extra目录下 
  - 暴漏头文件，编辑目录中的Makefile文件
  - - HEADERS = 新增.h文件，例如:url.h
  - - OBJS = 新增.o文件，例如:url.o
  ```
  注意：要替换ios目录下针对不同内核的目录arm64,armv7,armv7s,i386，都需要操作如上步骤。
  ```
  
然后，在IOS目录下执行编译命令脚本集合文件:   
  
  ```
  ./compile-ffmpeg.sh clean     
  ./compile-ffmpeg.sh all
  ```

####将ijkplayer集成到自己的项目中
1. 将ijkplayer-master/ios、目录下的IJKMediaPlayer目录拷贝到自己项目的同目录下
2. 打开自己的项目，将IJKMediaPlayer.xcodeproj项目文件拖入自己项目中
3. 选择项目名称，配置Targets
	- 选中 build phases标签，添加 Target Dpendencies  ，选中IJKMediaFramework 添加即可。 
4. 因为移动了IJK项目目录到本项目，需要重新配置IJKMediaPlayer中文件关联设置
	- 需要将ijkplayer-master/目录下的ijkmedia目录中的ijkplayer目录和ijksdl目录(Android.mk除外)，拷贝到IJKMediaPlyaer项目的IJKMediaPlyaer/IJKMediaPllayer/ijkmedia/目录下
	- 需要将编译后得到的静态库（ijkplayer-master/ios/build/universal/目录）拷贝至IJKMediaPlayer目录：$(PROJECT_DIR)/ffmpeg/universal/lib
	- 选中IJKMediaPlayer项目名称，配置Targets
	- 选中 build Setting标签：  
	**设置HeaderSearch Paths**:$(PROJECT_DIR)/IJKMediaPlayer/ijkmedia $(PROJECT_DIR)/ffmpeg/universal/include  
	**设置Library Search Paths**:$(PROJECT_DIR)/ffmpeg/universal/lib  















