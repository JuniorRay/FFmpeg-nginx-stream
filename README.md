# FFmpeg-nginx-stream 本地视频推流环境

###window版本视频推流环境(RTMP/HLS)搭建，下载运行后即可直接推流

![Image text](vlc.png)

1.环境
```code
开发环境：windows

开发工具：FFmpeg、nginx、nginx-rtmp-module
```
简介：Nginx是一款轻量级的Web 服务器/反向代理服务器及电子邮件（IMAP/POP3）代理服务器。 nginx-rtmp-module是Nginx服务器的流媒体插件。nginx通过rtmp模块提供rtmp服务, ffmpeg推送一个rtmp流到nginx, 然后客户端通过访问nginx来收看实时视频流


2.准备文件

       需要的配置文件，这里我就全部整理好了，包括Nginx、nginx-rtmp-module、FFmpeg和实例mp4视频
     

3.启动nginx服务器

进入windows的cmd; 
```shell
> cd D://nginx    //进入nginx的目录(我的是放在D://nginx)，目录不要带中文！！！否则无法执行

> nginx.exe -c conf\nginx-win-rtmp.conf   //运行rtmp配置文件 
```
     注意：此时命令行会一直处于执行中 不用理会  也不要关闭

测试：浏览器输入localhost:80  ，如果出现如下页面 说明配置nginx启动成功!

​


4.配置FFmpeg

解压：将ffmpeg放到指定目录 我这里是D://ffmpeg 

环境配置：右键我的电脑（win10是此电脑） -- 》 属性  --》 高级系统设置 --》高级 --》环境变量--》打开Path ，将 D:\ffmpeg\bin （你的ffmepg解压目录下的bin目录的绝对路径）添加到Path 路径下；具体方法不会的可以的百度 

测试：打开windows 的cmd （不要关闭前面的nginx） 输入ffmpeg -help 如果出现如下情况  说明配置成功！

​


5.运行  

将下载的orange.mp4文件放到桌面 

新打开windows的cmd （不要关闭之前的ngnix）进入桌面文件夹

然后输入一下指令：
```code
ffmpeg -re -i orange.mp4 -vcodec libx264 -acodec aac -f flv rtmp://你的ip地址:1935/live/home
```

     // 注意：192.168.1.119是我电脑的ip地址，需要替换成你的ip地址 (ip地址可通过cmd 的ipconfig指令获取)

     //例如：ffmpeg -re -i orange.mp4 -vcodec libx264 -acodec aac -f flv rtmp://192.168.1.119:1935/live/home


![Image text](view.png)

6.rtmp直播(h264)

（如果要用rtsp直接转，可以把下面的orange.mp4 换成rtsp://admin:123456@192.111.111.130:554/h264/ch4/main/av_stream）

```code
ffmpeg -re -i orange.mp4 -vcodec libx264 -acodec aac -f flv rtmp://127.0.0.1:1935/live/home
```
然后先点击命令行回车 再点击播放

// ffmpeg -re -i orange.mp4 -vcodec libx264 -r 25 -b:v 500k -s 640*480 -acodec aac -f flv rtmp://127.0.0.1:1935/live/home

电脑打开vlc播放器     
输入地址：
```code
rtmp://127.0.0.1:1935/live/home  
```




7.hls直播（h264）（会在d:/tmp/hls 生成ts文件，如果没有该文件夹请创建，原理就是通8765端口代理到该文件里面生成的对应的movie.m3u8文件然后指向ts片段）

```code
ffmpeg -re -i orange.mp4 -vcodec libx264 -acodec aac -f flv rtmp://127.0.0.1:1935/hls/movie
```
电脑打开vlc播放器      输入地址:
```code
①（HLS） 
http://127.0.0.1:8765/hls/movie.m3u8

②（RTMP）
rtmp://127.0.0.1:1935/hls/movie
```


然后先点击命令行回车 再点击播放

![Image text](ts.png)

8.rtmp点播(前提是把文件放在代理/vod 的目录（D:/tmp/video; ）然后通过代理访问，不需要ffmpeg命令)

电脑打开vlc播放器      输入地址:
```code
rtmp://localhost:1935/vod/orange.mp4
```

![Image text](vlc.png)


 
9.h264转h265命令
```code
ffmpeg -i h264.mp4 -c:v libx265 -c:a copy h265.mp4
```
10.h265转h264命令
```code
ffmpeg -i h265.mkv -map 0 -c:a copy -c:s copy -c:v libx264 h264.mkv
```
11.切割文件成hls切片命令并用nginx代理播放(h264) nginx-win-rtmp.conf 已经配置目录代理
```code
ffmpeg  -re -i orange.mp4 -codec:v libx264  -map 0 -f hls  -hls_list_size 6 -hls_wrap 10 -hls_time 10 D://tmp/hls/play.m3u8
```
播放地址为：http://127.0.0.1:8765/hls/play.m3u8

12.切割文件成hls切片命令并用nginx代理播放(h265)
```code
ffmpeg  -re -i h265.mp4 -codec:v libx265  -map 0 -f hls  -hls_list_size 6 -hls_wrap 10 -hls_time 10 D://tmp/hls/play265video.m3u8
```
播放地址为：http://127.0.0.1:8765/hls/play265video.m3u8
