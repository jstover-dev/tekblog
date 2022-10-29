---
title: Extract a segment of a video using ffmpeg
tags: [video, media, ffmpeg]
---

### 1. Extract segment to a series of bitmap files

Cut out a section of `input_file.mkv` starting at `0:58:57.000` and lasting `5.0` seconds.
Individual frame images will be saved to the current directory.

```sh
ffmpeg -ss 00:58:57.000 -t 5.0 -i input_file.mkv frame-%03d.bmp
```


### 2. Manually edit / delete frames as desired


### 3. Rename frames to prepare for encoding

```sh
N=0; for f in frame-*.bmp; do N=$((N+1)); mv "$f" $(printf 'frame-%03d.bmp' $N); done
```

### 4. Convert to gif, compressed mp4 or lossless avi

```sh
# Create an MP4 file
ffmpeg -i frame-%03d.bmp final.mp4
```

```sh
# Create an AVI file
ffmpeg -i frame-%03d.bmp -c:v huffyuv -pix_fmt rgb24 final.avi
```

```sh
# Create a GIF file
convert *.bmp final.gif
```



