#!/bin/bash

EXAMPLE="./mixcut -a Nas -m Hip-Hop\ Is\ Dead -i nas-hiphopisdead.mp3 -t nas"

ARTIST=""
ALBUM=""
MIXTAPE=""
TIMELINE=""

while getopts "h:a:m:i:t:" opt; do
    case "$opt" in
    h|\?)

printf "mixcut – cut mixtape into separate files using ffmpeg and mp3info by Vlad Slepukhin

  USAGE:
       -h – prints this page.
       -a – defines artist to set.
       -m – defines album name to set.
       -i – defines input filename, must end with *.mp3.
       -t – defines timeline file.\n

  EXAMPLE:
       ./mixcut -a Nas -m Hip-Hop\ Is\ Dead -i nas-hiphopisdead.mp3 -t nas

  TIMELINE FILE:
        This is the file, where you define start, stop and trackname
        line by line and comma separated like this:
              00:00,02:15,My name
              02:16,03:59,Another name
"
        exit 0
        ;;
    a)  ARTIST=$OPTARG
        ;;
    m)  ALBUM=$OPTARG
        ;;
    i)  MIXTAPE=$OPTARG
        ;;
    t)  TIMELINE=$OPTARG
    esac
done

if [[ ! "${ARTIST}" ]] || [[ ! "${ALBUM}" ]] || [[ ! "${MIXTAPE}" ]] || [[ ! "${TIMELINE}" ]] || [[ ! "${MIXTAPE}" == *mp3 ]]; then
  echo "Can't run due to improper format. Usage: "${EXAMPLE}
  exit 1
fi

if [ ! -f "${MIXTAPE}" ]; then
  echo "File not found: "${MIXTAPE}". Exiting. "
  exit 2
fi

BITRATE=$(ffmpeg -i "${MIXTAPE}" 2>&1 | grep bitrate: | awk '{print $6}' || true)

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
    beginSecs=$(($(echo $begin | awk -F ':' '{print $1 + 0}')*60 + $(echo $begin | awk -F ':' '{print $2 + 0}')))
    length=$(($(echo $end | awk -F ':' '{print $1 + 0}')*60 + $(echo $end | awk -F ':' '{print $2 + 0}') - $beginSecs))
    echo $begin $end $length $songName
    output=${songName}".mp3"
    ffmpeg -ss 00:${begin}.00 -t $length -i "${MIXTAPE}" -ab ${BITRATE} "${output}" </dev/null
    mp3info -a ${ARTIST} -l ${ALBUM}  -n $count -t ${songName} "${output}"
done < ${TIMELINE}
