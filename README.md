# episodes-dl

A wrapper around youtube-dl program.  It scraps multiple video files listed in
a csv file from the websites that host them.

```
[me@my-house:favorite-show]$ episodes-dl --help
usage: episodes-dl [OPTION]... [FILE]
Download videos listed in episodes.csv or FILE.
Skip videos already present.

-h, --help         display this help and exit
-n, --count=NUM    download at most NUM videos
[me@my-house:favorite-show]$ cat episodes.csv
url,basename
https://cda.pl/video/337601887,s02e03-humpty-dumpty
https://cda.pl/video/33684072f,s02e04-tb-or-not-tb
[me@my-house:favorite-show]$ episodes-dl
[CDA] 337601887: Downloading webpage
[CDA] 337601887: Fetching 360p url
[CDA] 337601887: Fetching 720p url
[CDA] 337601887: Fetching 1080p url
[info] 337601887: Downloading 1 format(s): 1080p
[download] Destination: s02e03-humpty-dumpty.mp4
[download] 100% of 1.88GiB in 04:08
[episodes-dl] File 's02e04-tb-or-not-tb.mp4' exists. Skipping.
[me@my-house:favorite-show]$ episodes-dl
[episodes-dl] File 's02e03-humpty-dumpty.mp4' exists. Skipping.
[episodes-dl] File 's02e04-tb-or-not-tb.mp4' exists. Skipping.
[me@my-house:favorite-show]$ 
```
