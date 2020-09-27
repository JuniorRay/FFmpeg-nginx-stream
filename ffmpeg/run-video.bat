for((;;)); do \
ffmpeg -re -i "D:\ffmpeg\orange.mp4" \
-vcodec libx264 -acodec aac \
-c copy \
-f flv -y rtmp://192.168.1.111:1935/live/home; \
sleep 1; \
done

