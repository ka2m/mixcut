#!/bin/bash

MIXTAPE=$1
TIMELINE=$2

if [[ ! $MIXTAPE ]] || [ ! $TIMELINE ]; then
    echo "Mixtape file or timeline file are not in parameters."
    echo "Usage: mixtape.sh ARTIST-NAME.mp3 yourtimeline"
    exit 1
fi

if [[ ! $MIXTAPE == *.mp3 ]]; then
    echo "Filename doesn't end with .mp3"
    exit 2
fi

ARTIST=$(echo $MIXTAPE | awk -F '-' '{print $1}')
ALBUM=$(echo $MIXTAPE | awk -F '-' '{print $2}' | awk -F '.mp3' '{print $1}')
BITRATE=$(ffmpeg -i $MIXTAPE 2>&1 | grep bitrate: | awk '{print $6}')

echo $BITRATE
if [[ ! $BITRATE == *k ]]; then
    BITRATE+="k"
fi

echo $ARTIST
echo $ALBUM
echo $BITRATE

count=0
while read -r line
do
    count=$((count+1))
    begin=$(echo $line | awk -F',' '{print $1}')
    end=$(echo $line | awk -F',' '{print $2}')
    songName=$(echo $line | awk -F',' '{print $3}')
    begin_secs=$(( $(echo $begin | awk -F ':' '{print $1 + 0}')*60 + $(echo $begin | awk -F ':' '{print $2 + 0}') ))
    length=$(( $(echo $end | awk -F ':' '{print $1 + 0}')*60 + $(echo $end | awk -F ':' '{print $2 + 0}') - $begin_secs ))
    echo $begin $end $length $songName
    output=${songName}".mp3"
    ffmpeg -ss 00:${begin}.00 -t $length -i $MIXTAPE -ab $BITRATE "${output}" </dev/null 
    mp3info -a ${ARTIST} -l ${ALBUM}  -n $count -t ${songName} "${output}"
done < $TIMELINE


