#!/bin/bash

out=$(
  rm -rf out
  mkdir -p out
  cd out
  pwd
  cd ..
);


function add_audio_track(){
  ffmpeg -ar 44100 -acodec pcm_s16le -f s16le -ac 2 -channel_layout 2.1 \
       -i /dev/zero -i $1 -vcodec copy -acodec  aac -shortest $2
}

function convert() {
  echo $out
  in=$1
  o=$2.mp4
  rm -rf $o

  # https://support.google.com/youtube/answer/1722171?hl=en
  # -r = video frame rate  (recommended for YT SDR is 25)
  # -b:a = audio frame rate (recommended for YT SDR is 128)
  # -acodec audio codec (recommended for YT is AAC-LC)
  # -vcodec video codec (recommended for YT is H264)
  # -f force a format (recommended for YT is MP4)
  # -vf set the filter graph

  # ffmpeg -i $in -acodec mp3 -b:a 128k -vf "scale=1920:1080,setsar=1" -vcodec mpeg4 \
  #     -r 60 -b:v 1200k -flags +aic+mv4 -f mp4 out/$o

  ffmpeg -i $in -acodec mp3  -vf "scale=1920:1080,setsar=1" -vcodec mpeg4 \
       -flags +aic+mv4 -f mp4 out/$o


  echo "file '$out/$o'"  >>  $out/files.txt
}

rm files.txt

# the 3 bumpers don't have a sound track, so add them here
add_audio_track in/intro.mov out/intro-audio.mov
add_audio_track in/outro.mov out/outro-audio.mov
add_audio_track in/cnj.mov out/cnj-audio.mov

# then convert everything to the same size and shape of a file
convert out/intro-audio.mov intro
convert out/cnj-audio.mov cnj
convert in/test.ogv test  #### TODO: REPLACE THIS WITH THE FILE YOU WANT TO BUILD A VIDEO FOR
convert out/outro-audio.mov outro

# then concatenate everything
ffmpeg -f concat  -safe 0 -i $out/files.txt $out/final.mov
