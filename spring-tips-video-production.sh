#!/bin/bash


function usage(){
  echo "SPRING TIPS PRODUCER"
  echo
  echo "1.) you must provide an \$SPRING_TIPS_INPUT_ASSETS environment variable pointing to a directory containing:"
  echo " intro.mov"
  echo " outro.mov"
  echo " cnj.mov"

  echo "2.) use: spring-tips-video-production.sh my-screen-recording.ogv"
  echo "(no input recording given.)"
}

if [ -z "$SPRING_TIPS_INPUT_ASSETS" ]
then
  usage
  exit 1
fi

if [ -z "$1" ]
then
  usage
  exit 1
else
  echo "creating Spring Tip video for file '$1'."
fi

movie=$1

in=$(
  echo "using assets from: $SPRING_TIPS_INPUT_ASSETS."
  mkdir -p in
  cd in
  cp $SPRING_TIPS_INPUT_ASSETS/intro.mov .
  cp $SPRING_TIPS_INPUT_ASSETS/outro.mov .
  cp $SPRING_TIPS_INPUT_ASSETS/cover.png .
  pwd
  cd ..
)

out=$(
  rm -rf out
  mkdir -p out
  cd out
  pwd
  cd ..
);


function detect_audio(){
  ffprobe -i $1 -show_streams -select_streams a -loglevel error
}

function add_audio_track(){
  rm $2
  ffmpeg -f lavfi -i anullsrc=channel_layout=stereo:sample_rate=44100 -i $1   -shortest -c:v copy -c:a aac $2
}

## build the cover image
rm -rf out/cover-15s.mov
ffmpeg -loop 1 -i in/cover.png -c:v libx264 -t 15 -pix_fmt yuv420p -vf scale=1920:1080,setsar=1:1 out/cover-15s.mov

## add the audio track to the cover image
rm out/cover-15s-audio.mov
add_audio_track  out/cover-15s.mov out/cover-15s-audio.mov

## make sure the rest of the clips have audio tracks 
add_audio_track in/outro.mov out/outro-audio.mov
add_audio_track in/intro.mov out/intro-audio.mov

#ffmpeg -i $movie -c:v libtheora -q:v 7 -c:a libvorbis -q:a 4 out/STAGE.ogv
ffmpeg -i $movie -c:v libtheora -q:v 7 -c:a libvorbis -q:a 4 out/STAGE.ogv

ffmpeg -i out/STAGE.ogv   -vf "scale=1920:1080,setsar=1"  out/MOVIE.mov

ffmpeg -i out/cover-15s-audio.mov  -i out/intro-audio.mov -i out/MOVIE.mov -i out/outro-audio.mov \
 -filter_complex "[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0][3:v:0][3:a:0] concat=n=4:v=1:a=1 [v] [a]" -map "[v]" -map "[a]" out/RESULT.mov


mv out/RESULT.mov .
rm -rf out
rm -rf in
